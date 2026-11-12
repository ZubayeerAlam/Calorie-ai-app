import '../../features/exercise/data/models/exercise.dart';
import '../../features/exercise/data/models/exercise_settings.dart';
import '../../features/exercise/data/models/workout_plan.dart';
import '../../features/exercise/data/workout_plan_request.dart';
import '../../features/exercise/data/workout_plan_validator.dart';
import '../../l10n/l10n.dart';
import '../../features/profile/data/models/user_profile.dart';
import 'workout_plan_service.dart';

enum _SessionType { fullBody, upperBody, lowerBody }

/// Builds a balanced plan with fixed rules, without AI. Used when the AI
/// can't be reached, and in tests.
///
/// - **Sessions:** 2–3 workout days are full body; 4–5 alternate upper
///   and lower body (5 adds a full-body day in the middle).
/// - **Exercises:** each session fills movement slots (legs, push, pull,
///   core, cardio) from the allowed exercises, 4–7 depending on the
///   chosen minutes, varying the picks between sessions.
/// - **Sets and reps:** sets by level (2 / 3 / 4); 10 reps when building
///   muscle (8 for advanced), 15 to lose weight, otherwise 12; holds and
///   cardio by level; cardio machines are one longer set.
/// - **Rest:** the exercise's default, 15 s shorter to lose weight and
///   15 s longer when building muscle.
class RuleBasedWorkoutPlanService implements WorkoutPlanService {
  const RuleBasedWorkoutPlanService();

  @override
  bool get usesAi => false;

  @override
  Future<WorkoutPlan> generatePlan(WorkoutPlanRequest request) async =>
      build(request);

  static const Map<_SessionType, List<MovementPattern>> _slots = {
    _SessionType.fullBody: [
      MovementPattern.legs,
      MovementPattern.push,
      MovementPattern.pull,
      MovementPattern.core,
      MovementPattern.cardio,
      MovementPattern.legs,
      MovementPattern.push,
    ],
    _SessionType.upperBody: [
      MovementPattern.push,
      MovementPattern.pull,
      MovementPattern.push,
      MovementPattern.pull,
      MovementPattern.core,
      MovementPattern.cardio,
      MovementPattern.push,
    ],
    _SessionType.lowerBody: [
      MovementPattern.legs,
      MovementPattern.legs,
      MovementPattern.core,
      MovementPattern.legs,
      MovementPattern.cardio,
      MovementPattern.core,
      MovementPattern.legs,
    ],
  };

  static List<_SessionType> _types(int sessions) => switch (sessions) {
    <= 3 => List.filled(sessions, _SessionType.fullBody),
    4 => const [
      _SessionType.upperBody,
      _SessionType.lowerBody,
      _SessionType.upperBody,
      _SessionType.lowerBody,
    ],
    _ => const [
      _SessionType.upperBody,
      _SessionType.lowerBody,
      _SessionType.fullBody,
      _SessionType.upperBody,
      _SessionType.lowerBody,
    ],
  };

  /// Exercises per session for the chosen minutes.
  static int exercisesFor(int minutes) => switch (minutes) {
    <= 20 => 4,
    <= 30 => 5,
    <= 45 => 6,
    _ => 7,
  };

  static WorkoutPlan build(WorkoutPlanRequest request) {
    final types = _types(request.sessionsPerWeek);
    final count = exercisesFor(request.settings.sessionMinutes);
    // How often each movement type was picked, to vary the choices.
    final picks = <MovementPattern, int>{};
    final letters = <_SessionType, int>{};

    final sessions = [
      for (final type in types)
        {
          'name': _name(
            type,
            letters.update(type, (n) => n + 1, ifAbsent: () => 0),
          ),
          'focus': _focus(type),
          'exercises': [
            for (final e in _pick(
              request.allowed,
              _slots[type]!.take(count),
              picks,
            ))
              _prescribe(e, request),
          ],
        },
    ];

    return WorkoutPlanValidator.validate(
      {'summary': l10n.rulesPlanSummary(types.length), 'sessions': sessions},
      request,
      id: 'rules-${request.now.microsecondsSinceEpoch}',
      source: PlanSource.rules,
    );
  }

  /// One exercise per slot, no repeats; a slot with nothing left takes any
  /// unused exercise (core and legs first, the gentlest to add).
  static List<Exercise> _pick(
    List<Exercise> allowed,
    Iterable<MovementPattern> slots,
    Map<MovementPattern, int> picks,
  ) {
    final chosen = <Exercise>[];
    for (final pattern in slots) {
      final options = [
        for (final e in allowed)
          if (e.pattern == pattern && !chosen.contains(e)) e,
      ];
      if (options.isNotEmpty) {
        final n = picks.update(pattern, (n) => n + 1, ifAbsent: () => 0);
        chosen.add(options[n % options.length]);
        continue;
      }
      final spare = [
        for (final e in allowed)
          if (!chosen.contains(e)) e,
      ]..sort((a, b) => _spareRank(a).compareTo(_spareRank(b)));
      if (spare.isNotEmpty) chosen.add(spare.first);
    }
    return chosen;
  }

  static int _spareRank(Exercise e) => switch (e.pattern) {
    MovementPattern.core => 0,
    MovementPattern.legs => 1,
    _ => 2,
  };

  static Map<String, dynamic> _prescribe(
    Exercise e,
    WorkoutPlanRequest request,
  ) {
    final level = request.settings.level;
    final goal = request.profile.goal;
    final building = request.buildsMuscle;
    final machineCardio =
        e.equipment == Equipment.gym && e.pattern == MovementPattern.cardio;

    final sets = machineCardio
        ? 1
        : switch (level) {
            FitnessLevel.beginner => 2,
            FitnessLevel.intermediate => 3,
            FitnessLevel.advanced => 4,
          };
    var rest = e.defaultRestSeconds;
    if (goal == GoalType.lose && !building) rest -= 15;
    if (building) rest += 15;

    final json = <String, dynamic>{
      'exerciseId': e.id,
      'sets': sets,
      'restSeconds': rest,
    };
    if (e.isTimed) {
      json['durationSeconds'] = switch ((machineCardio, level)) {
        (true, FitnessLevel.beginner) => 300,
        (true, FitnessLevel.intermediate) => 480,
        (true, FitnessLevel.advanced) => 600,
        (false, FitnessLevel.beginner) => 20,
        (false, FitnessLevel.intermediate) => 30,
        (false, FitnessLevel.advanced) => 45,
      };
    } else {
      json['reps'] = building
          ? (level == FitnessLevel.advanced ? 8 : 10)
          : goal == GoalType.lose
          ? (level == FitnessLevel.beginner ? 12 : 15)
          : 12;
    }
    return json;
  }

  // Texts in the current language, worked out again from the session's
  // position, so a saved plan follows a later change of language.

  /// The name of session [index] of a plan with [count] sessions.
  static String sessionName(int count, int index) {
    final types = _types(count);
    if (index >= types.length) {
      return l10n.planDay(String.fromCharCode(65 + index));
    }
    final type = types[index];
    final letter = types.take(index).where((t) => t == type).length;
    return _name(type, letter);
  }

  static String sessionFocus(int count, int index) {
    final types = _types(count);
    return index < types.length ? _focus(types[index]) : '';
  }

  static String summary(int count) => l10n.rulesPlanSummary(count);

  static String _name(_SessionType type, int index) {
    final letter = String.fromCharCode(65 + index);
    return switch (type) {
      _SessionType.fullBody => l10n.planFullBody(letter),
      _SessionType.upperBody => l10n.planUpperBody(letter),
      _SessionType.lowerBody => l10n.planLowerBody(letter),
    };
  }

  static String _focus(_SessionType type) => switch (type) {
    _SessionType.fullBody => l10n.planFocusFullBody,
    _SessionType.upperBody => l10n.planFocusUpperBody,
    _SessionType.lowerBody => l10n.planFocusLowerBody,
  };
}
