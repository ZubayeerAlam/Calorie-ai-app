import 'package:flutter/foundation.dart';

import '../../../core/services/rule_based_workout_plan_service.dart';
import '../../../core/services/workout_plan_service.dart';
import '../../../core/utils/date_utils.dart';
import '../../profile/providers/profile_provider.dart';
import '../data/catalog/exercise_catalog.dart';
import '../data/exercise_estimate.dart';
import '../data/models/exercise_settings.dart';
import '../data/models/workout_plan.dart';
import '../data/models/workout_record.dart';
import '../data/repositories/exercise_settings_repository.dart';
import '../data/repositories/workout_log_repository.dart';
import '../data/repositories/workout_plan_repository.dart';
import '../data/workout_plan_request.dart';
import '../data/workout_plan_validator.dart';

/// The Exercise tab: setup, the weekly plan and today's progress.
///
/// Plans come from [WorkoutPlanService] (Gemini in the app). If it fails,
/// the built-in rules make the plan instead, and [aiFailure] says why, so
/// the dashboard can offer to try the AI again.
class ExerciseProvider extends ChangeNotifier {
  ExerciseProvider({
    required this._settingsRepo,
    required this._planRepo,
    required this._log,
    required this._planner,
    required this._profile,
    this._fallback = const RuleBasedWorkoutPlanService(),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now {
    _load();
    _profile.addListener(_onProfileChanged);
  }

  final ExerciseSettingsRepository _settingsRepo;
  final WorkoutPlanRepository _planRepo;
  final WorkoutLogRepository _log;
  final WorkoutPlanService _planner;
  final WorkoutPlanService _fallback;
  final ProfileProvider _profile;
  final DateTime Function() _clock;

  ExerciseSettings? _settings;
  WorkoutPlan? _plan;
  bool _generating = false;
  WorkoutPlanFailure? _aiFailure;
  int? _selected;

  ExerciseSettings? get settings => _settings;
  WorkoutPlan? get plan => _plan;

  /// True while a plan is being made.
  bool get generating => _generating;

  /// Why the AI couldn't make the current plan (it was made by the rules
  /// instead); null when the AI worked or wasn't asked.
  WorkoutPlanFailure? get aiFailure => _aiFailure;

  /// The plan was made without AI although the app has it (e.g. offline).
  bool get madeWithoutAi =>
      _plan?.source == PlanSource.rules && _planner.usesAi;

  bool get isSetUp => _settings != null && _plan != null;

  /// The profile or settings changed since the plan was made.
  bool get planOutdated {
    final request = _request();
    return _plan != null &&
        request != null &&
        _plan!.inputsKey != request.inputsKey;
  }

  double get weightKg => _profile.profile?.weightKg ?? 70;

  /// Saves the choices from the setup screen and makes a new plan.
  Future<void> setUp(ExerciseSettings settings) async {
    _settings = settings;
    await _settingsRepo.save(settings);
    await generate();
  }

  /// Makes a new plan for the current settings (Regenerate, Update plan).
  Future<void> generate() async {
    final request = _request();
    if (request == null || _generating) return;
    _generating = true;
    notifyListeners();
    WorkoutPlan plan;
    WorkoutPlanFailure? failure;
    try {
      plan = await _planner.generatePlan(request);
    } on WorkoutPlanException catch (e) {
      failure = e.failure;
      plan = await _fallback.generatePlan(request);
    }
    _plan = plan;
    _aiFailure = _planner.usesAi ? failure : null;
    _selected = null;
    await _planRepo.save(plan);
    _generating = false;
    notifyListeners();
  }

  WorkoutPlanRequest? _request() {
    final profile = _profile.profile;
    final settings = _settings;
    if (profile == null || settings == null) return null;
    return WorkoutPlanRequest(
      profile: profile,
      settings: settings,
      now: _clock(),
    );
  }

  // Sessions

  /// The session up next: today's if one was started today, otherwise
  /// the one after the last workout of this plan.
  int get todaySessionIndex {
    final plan = _plan;
    if (plan == null || plan.sessions.isEmpty) return 0;
    final mine = _log.all().where((r) => r.planId == plan.id).toList();
    if (mine.isEmpty) return 0;
    final today = mine.where((r) => AppDates.isSameDay(r.startedAt, _clock()));
    if (today.isNotEmpty) return today.last.sessionIndex % plan.sessions.length;
    final finished = mine.where((r) => r.isFinished);
    if (finished.isEmpty) return mine.last.sessionIndex % plan.sessions.length;
    return (finished.last.sessionIndex + 1) % plan.sessions.length;
  }

  /// The session shown on the dashboard (today's unless another was
  /// picked).
  int get selectedSessionIndex {
    final count = _plan?.sessions.length ?? 0;
    final selected = _selected;
    if (selected != null && selected < count) return selected;
    return todaySessionIndex;
  }

  PlannedSession? get selectedSession =>
      _plan?.sessions.elementAtOrNull(selectedSessionIndex);

  void selectSession(int index) {
    _selected = index;
    notifyListeners();
  }

  /// Today's workout record for the shown session, if one was started.
  WorkoutRecord? get selectedRecord {
    final plan = _plan;
    if (plan == null) return null;
    final today = _log
        .on(_clock())
        .where(
          (r) => r.planId == plan.id && r.sessionIndex == selectedSessionIndex,
        );
    return today.isEmpty ? null : today.last;
  }

  /// Where an exercise of the shown session stands today.
  ExerciseStatus statusOf(String exerciseId) {
    for (final e in selectedRecord?.exercises ?? const <ExerciseRecord>[]) {
      if (e.exerciseId == exerciseId) return e.status;
    }
    return ExerciseStatus.notStarted;
  }

  // Progress of the shown session

  int get totalExercises => selectedSession?.exercises.length ?? 0;

  int get completedExercises => [
    for (final e in selectedSession?.exercises ?? const <PlannedExercise>[])
      if (statusOf(e.exerciseId) == ExerciseStatus.completed) e,
  ].length;

  int get remainingExercises => totalExercises - completedExercises;

  /// Estimated minutes for the whole session, rests included.
  int get estimatedMinutes {
    final session = selectedSession;
    if (session == null) return 0;
    return (WorkoutPlanValidator.sessionSeconds(session) / 60).round();
  }

  /// Estimated net kcal for one planned exercise done in full.
  double plannedKcal(PlannedExercise planned) {
    final exercise = ExerciseCatalog.byId(planned.exerciseId);
    if (exercise == null) return 0;
    return ExerciseEstimate.plannedKcal(exercise, planned, weightKg: weightKg);
  }

  /// Estimated net kcal for the whole shown session.
  double get estimatedKcal => (selectedSession?.exercises ?? const []).fold(
    0,
    (sum, e) => sum + plannedKcal(e),
  );

  // Keeping in step

  /// Re-reads storage (after sign-in, log out or Reset all data).
  void reload() {
    _load();
    notifyListeners();
  }

  void _load() {
    _settings = _settingsRepo.read();
    _plan = _planRepo.read();
    _aiFailure = null;
    _selected = null;
  }

  void _onProfileChanged() {
    // Reset all data removed everything.
    if (_profile.profile == null && _settings != null) _load();
    notifyListeners();
  }

  @override
  void dispose() {
    _profile.removeListener(_onProfileChanged);
    super.dispose();
  }
}
