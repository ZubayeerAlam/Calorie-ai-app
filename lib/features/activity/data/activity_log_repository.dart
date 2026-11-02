import '../../../core/services/local_storage_service.dart';
import '../../../core/utils/date_utils.dart';

/// Activity calories burned per day, stored as `{ "2026-10-18": 320, ... }`:
/// logged by hand (`activity_kcal`) and workouts imported from Health
/// (`health_workout_kcal`).
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

  Future<void> setWorkoutKcal(DateTime date, int kcal) {
    final all = _readAll(StorageKeys.healthWorkoutKcal);
    all[AppDates.key(date)] = kcal;
    return _storage.setJson(StorageKeys.healthWorkoutKcal, all);
  }

  bool get healthConnected =>
      _storage.getBool(StorageKeys.healthConnected) ?? false;

  Future<void> setHealthConnected(bool connected) async {
    await _storage.setBool(StorageKeys.healthConnected, connected);
    if (!connected) await _storage.remove(StorageKeys.healthWorkoutKcal);
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
