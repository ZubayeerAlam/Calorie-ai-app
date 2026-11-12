import '../../../core/services/health_service.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/utils/date_utils.dart';

/// Activity calories burned per day, stored as `{ "2026-10-18": 320, ... }`:
/// logged by hand (`activity_kcal`) and workouts imported from Health
/// (`health_workout_kcal`, with each workout's times in
/// `health_workouts`).
class ActivityLogRepository {
  ActivityLogRepository(this._storage);

  final LocalStorageService _storage;

  Map<String, int> _readAll([String key = StorageKeys.activityKcal]) =>
      _storage.readObject(
        key,
        (json) => json.map((day, kcal) => MapEntry(day, kcal as int)),
      ) ??
      {};

  /// Logged by hand.
  int burnedOn(DateTime date) => _readAll()[AppDates.key(date)] ?? 0;

  /// Imported from Health workouts.
  int workoutKcalOn(DateTime date) =>
      _readAll(StorageKeys.healthWorkoutKcal)[AppDates.key(date)] ?? 0;

  /// Health workouts on [date], with their times (to recognise a Cal AI
  /// workout that Health also recorded).
  List<HealthWorkout> healthWorkoutsOn(DateTime date) {
    final all = _storage.readObject(StorageKeys.healthWorkouts, (json) => json);
    final day = all?[AppDates.key(date)];
    if (day is! List) return const [];
    try {
      return [
        for (final w in day) HealthWorkout.fromJson(w as Map<String, dynamic>),
      ];
    } catch (_) {
      return const [];
    }
  }

  /// Saves the Health workouts of [date]: each one (with times) and the
  /// day's total kcal.
  Future<void> setHealthWorkouts(
    DateTime date,
    List<HealthWorkout> workouts,
  ) async {
    final day = AppDates.key(date);
    final totals = _readAll(StorageKeys.healthWorkoutKcal)
      ..[day] = workouts.fold(0, (sum, w) => sum + w.kcal);
    await _storage.setJson(StorageKeys.healthWorkoutKcal, totals);
    final all =
        _storage.readObject(StorageKeys.healthWorkouts, (json) => json) ??
        <String, dynamic>{};
    all[day] = [for (final w in workouts) w.toJson()];
    await _storage.setJson(StorageKeys.healthWorkouts, all);
  }

  bool get healthConnected =>
      _storage.getBool(StorageKeys.healthConnected) ?? false;

  Future<void> setHealthConnected(bool connected) async {
    await _storage.setBool(StorageKeys.healthConnected, connected);
    if (!connected) {
      await _storage.remove(StorageKeys.healthWorkoutKcal);
      await _storage.remove(StorageKeys.healthWorkouts);
    }
  }

  /// Sets (not adds to) the activity kcal for [date]; 0 clears it.
  Future<void> setBurned(DateTime date, int kcal) {
    final all = _readAll();
    final day = AppDates.key(date);
    if (kcal <= 0) {
      all.remove(day);
    } else {
      all[day] = kcal;
    }
    return _storage.setJson(StorageKeys.activityKcal, all);
  }
}
