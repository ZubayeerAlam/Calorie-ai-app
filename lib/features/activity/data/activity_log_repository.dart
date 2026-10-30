import '../../../core/services/local_storage_service.dart';
import '../../../core/utils/date_utils.dart';

/// Activity calories burned per day, stored as `{ "2026-10-18": 320, ... }`.
class ActivityLogRepository {
  ActivityLogRepository(this._storage);

  final LocalStorageService _storage;

  Map<String, int> _readAll() =>
      _storage.readObject(
        StorageKeys.activityKcal,
        (json) => json.map((day, kcal) => MapEntry(day, kcal as int)),
      ) ??
      {};

  int burnedOn(DateTime date) => _readAll()[AppDates.key(date)] ?? 0;

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
