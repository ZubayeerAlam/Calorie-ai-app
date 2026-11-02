import '../../../core/services/local_storage_service.dart';
import '../../../core/utils/date_utils.dart';

/// Turns the phone's running step total into steps per day and saves them.
///
/// Storage:
/// - `walking_steps`: `{ "2026-10-18": 4210, ... }` (phone's step sensor)
/// - `step_baseline`: `{ "day": "2026-10-18", "base": 51234, "last": 55444 }`
///   where today's steps = latest total − base.
///
/// - `health_steps`: `{ "2026-10-18": 6120, ... }` (Apple Health / Health
///   Connect, which also has the steps walked before the app was opened)
///
/// A day's steps are the higher of the two. Without Health, counting
/// starts the first time the app sees a new day, so steps walked earlier
/// that day aren't included.
class StepLogRepository {
  StepLogRepository(this._storage);

  static const String _stepsKey = StorageKeys.walkingSteps;
  static const String _baselineKey = StorageKeys.stepBaseline;

  final LocalStorageService _storage;

  Map<String, int> _readSteps([String key = _stepsKey]) =>
      _storage.readObject(
        key,
        (json) => json.map((day, steps) => MapEntry(day, steps as int)),
      ) ??
      {};

  int stepsOn(DateTime date) {
    final day = AppDates.key(date);
    final sensor = _readSteps()[day] ?? 0;
    final health = _readSteps(StorageKeys.healthSteps)[day] ?? 0;
    return sensor > health ? sensor : health;
  }

  /// Saves the steps Health reported for [date].
  Future<void> setHealthSteps(DateTime date, int steps) {
    final all = _readSteps(StorageKeys.healthSteps);
    all[AppDates.key(date)] = steps;
    return _storage.setJson(StorageKeys.healthSteps, all);
  }

  Future<void> clearHealthSteps() => _storage.remove(StorageKeys.healthSteps);

  /// Records a new running total read at [now]; returns today's steps.
  Future<int> record(int stepsSinceBoot, DateTime now) async {
    final today = AppDates.key(now);
    final all = _readSteps();
    final savedToday = all[today] ?? 0;
    final baseline = _storage.getJson(_baselineKey);

    int base;
    if (baseline == null || baseline['day'] != today) {
      // New day (or first run): start counting from this reading.
      base = stepsSinceBoot - savedToday;
    } else if (stepsSinceBoot < (baseline['last'] as int)) {
      // The phone restarted and its total reset: carry today's count on.
      base = stepsSinceBoot - savedToday;
    } else {
      base = baseline['base'] as int;
    }

    final steps = (stepsSinceBoot - base).clamp(0, 1 << 31);
    all[today] = steps;
    await _storage.setJson(_stepsKey, all);
    await _storage.setJson(_baselineKey, {
      'day': today,
      'base': base,
      'last': stepsSinceBoot,
    });
    return steps;
  }
}
