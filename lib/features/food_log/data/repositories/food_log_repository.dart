import '../../../../core/services/local_storage_service.dart';
import '../models/food_entry.dart';

/// Stores food entries in local storage (shared_preferences) as JSON.
class FoodLogRepository {
  FoodLogRepository(this._storage);

  final LocalStorageService _storage;

  List<FoodEntry> _readAll() =>
      _storage.readList(StorageKeys.foodEntries, FoodEntry.fromJson);

  Future<void> _writeAll(List<FoodEntry> entries) => _storage.setJsonList(
    StorageKeys.foodEntries,
    entries.map((e) => e.toJson()).toList(),
  );

  Future<List<FoodEntry>> getEntriesFor(DateTime day) async {
    return _readAll()
        .where(
          (e) =>
              e.loggedAt.year == day.year &&
              e.loggedAt.month == day.month &&
              e.loggedAt.day == day.day,
        )
        .toList();
  }

  Future<void> add(FoodEntry entry) => _writeAll([..._readAll(), entry]);

  Future<void> remove(String id) =>
      _writeAll(_readAll()..removeWhere((e) => e.id == id));
}
