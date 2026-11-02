import '../../../core/services/local_storage_service.dart';
import '../../../core/utils/date_utils.dart';
import 'models/weight_entry.dart';

/// Body weight per day, stored as `{ "2026-10-18": 71.4, ... }`. One
/// weigh-in per day; logging again replaces it.
class WeightLogRepository {
  WeightLogRepository(this._storage);

  final LocalStorageService _storage;

  Map<String, double> _readAll() =>
      _storage.readObject(
        StorageKeys.weightLog,
        (json) => json.map((day, kg) => MapEntry(day, (kg as num).toDouble())),
      ) ??
      {};

  /// Every weigh-in, oldest first.
  List<WeightEntry> all() {
    final entries = [
      for (final MapEntry(key: day, value: kg) in _readAll().entries)
        WeightEntry(date: DateTime.parse(day), weightKg: kg),
    ];
    return entries..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<void> set(DateTime date, double weightKg) {
    final all = _readAll()..[AppDates.key(date)] = weightKg;
    return _storage.setJson(StorageKeys.weightLog, all);
  }

  Future<void> remove(DateTime date) {
    final all = _readAll()..remove(AppDates.key(date));
    return _storage.setJson(StorageKeys.weightLog, all);
  }
}
