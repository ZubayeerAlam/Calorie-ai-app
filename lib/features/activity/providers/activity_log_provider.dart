import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../../core/services/health_service.dart';
import '../../../core/services/step_counter_service.dart';
import '../../../core/utils/calorie_calculator.dart';
import '../../../core/utils/date_utils.dart';
import '../../exercise/data/repositories/workout_log_repository.dart';
import '../data/activity_log_repository.dart';
import '../data/step_log_repository.dart';

enum StepTrackingStatus { off, tracking, denied, unavailable }

/// Burned calories: activity logged by hand, workouts imported from
/// Health, workouts done in Cal AI's Exercise tab, and walking from steps
/// (phone sensor or Health).
///
/// A Cal AI workout that Health also recorded (their times overlap, e.g.
/// tracked on a watch too) is counted once: Health's measured number is
/// used and Cal AI's estimate is left out.
class ActivityLogProvider extends ChangeNotifier {
  ActivityLogProvider(
    this._repository,
    this._steps,
    this._stepCounter, {
    this._health = const UnavailableHealthService(),
    this._workouts,
    this._workoutChanges,
  }) {
    _workoutChanges?.addListener(notifyListeners);
    // Health data changes while the app is in the background.
    _lifecycle = AppLifecycleListener(onResume: syncHealth);
  }

  final ActivityLogRepository _repository;
  final StepLogRepository _steps;
  final StepCounterService _stepCounter;
  final HealthService _health;

  /// Cal AI workouts, and what notifies when they change.
  final WorkoutLogRepository? _workouts;
  final Listenable? _workoutChanges;
  late final AppLifecycleListener _lifecycle;

  StreamSubscription<int>? _subscription;
  StepTrackingStatus _status = StepTrackingStatus.off;
  bool _syncing = false;
  bool _disposed = false;

  StepTrackingStatus get stepStatus => _status;

  /// "Apple Health" or "Health Connect".
  String get healthName => _health.name;

  bool get healthConnected => _repository.healthConnected;

  /// Activity kcal logged by hand for [date].
  int burnedOn(DateTime date) => _repository.burnedOn(date);

  /// Workout kcal imported from Health for [date].
  int workoutKcalOn(DateTime date) => _repository.workoutKcalOn(date);

  /// Estimated kcal of the Cal AI workouts on [date] that Health didn't
  /// also record.
  int appWorkoutKcalOn(DateTime date) {
    final workouts = _workouts;
    if (workouts == null) return 0;
    final health = healthConnected
        ? _repository.healthWorkoutsOn(date)
        : const <HealthWorkout>[];
    var kcal = 0.0;
    for (final record in workouts.on(date)) {
      final end = record.endedAt ?? record.updatedAt ?? record.startedAt;
      if (health.any((w) => w.overlaps(record.startedAt, end))) continue;
      kcal += record.estimatedKcal;
    }
    return kcal.round();
  }

  /// Hand-logged activity, imported workouts and Cal AI workouts.
  int activityOn(DateTime date) =>
      burnedOn(date) + workoutKcalOn(date) + appWorkoutKcalOn(date);

  int stepsOn(DateTime date) => _steps.stepsOn(date);

  /// Walking kcal for [date] from its saved steps and the user's weight.
  int walkingOn(DateTime date, {required double weightKg}) =>
      CalorieCalculator.walkingKcal(stepsOn(date), weightKg);

  int totalBurnedOn(DateTime date, {required double weightKg}) =>
      activityOn(date) + walkingOn(date, weightKg: weightKg);

  Future<void> setBurned(DateTime date, int kcal) async {
    await _repository.setBurned(date, kcal);
    notifyListeners();
  }

  /// Asks for step access once and starts listening. Safe to call again.
  Future<void> startStepTracking() async {
    if (_status != StepTrackingStatus.off) return;
    _status = StepTrackingStatus.tracking; // claim before awaiting
    unawaited(syncHealth());
    if (!await _stepCounter.requestAccess()) {
      _setStatus(StepTrackingStatus.denied);
      return;
    }
    _subscription = _stepCounter.stepsSinceBoot.listen(
      (total) async {
        await _steps.record(total, DateTime.now());
        notifyListeners();
      },
      // No step sensor, or Motion access refused on iOS.
      onError: (_) => _setStatus(StepTrackingStatus.unavailable),
      cancelOnError: true,
    );
  }

  Future<HealthAvailability> healthAvailability() => _health.availability();

  Future<void> installHealth() => _health.install();

  /// Asks for Health access; on success imports the last 30 days.
  Future<bool> connectHealth() async {
    if (!await _health.requestAccess()) return false;
    await _repository.setHealthConnected(true);
    notifyListeners();
    await syncHealth(days: 30);
    return true;
  }

  /// Stops importing and removes the imported numbers.
  Future<void> disconnectHealth() async {
    await _repository.setHealthConnected(false);
    await _steps.clearHealthSteps();
    notifyListeners();
  }

  /// Imports steps and workout kcal for the last [days] days (today
  /// included) when Health is connected.
  Future<void> syncHealth({int days = 7}) async {
    if (!healthConnected || _syncing) return;
    _syncing = true;
    try {
      final now = DateTime.now();
      final today = AppDates.dateOnly(now);
      for (var i = 0; i < days; i++) {
        final start = DateTime(today.year, today.month, today.day - i);
        final end = i == 0
            ? now
            : DateTime(start.year, start.month, start.day + 1);
        final steps = await _health.stepsBetween(start, end);
        if (steps != null) await _steps.setHealthSteps(start, steps);
        await _repository.setHealthWorkouts(
          start,
          await _health.workoutsBetween(start, end),
        );
      }
    } finally {
      _syncing = false;
    }
    if (!_disposed) notifyListeners();
  }

  /// Re-reads storage, e.g. after cloud data was downloaded.
  void reload() => notifyListeners();

  void _setStatus(StepTrackingStatus status) {
    _status = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _workoutChanges?.removeListener(notifyListeners);
    _lifecycle.dispose();
    _subscription?.cancel();
    super.dispose();
  }
}
