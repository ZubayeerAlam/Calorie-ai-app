import '../models/food_entry.dart';

/// In-memory store for now; swap for local DB or remote API later.
class FoodLogRepository {
  final List<FoodEntry> _entries = [];

  Future<List<FoodEntry>> getEntriesFor(DateTime day) async {
    return _entries
        .where(
          (e) =>
              e.loggedAt.year == day.year &&
              e.loggedAt.month == day.month &&
              e.loggedAt.day == day.day,
        )
        .toList();
  }

  Future<void> add(FoodEntry entry) async => _entries.add(entry);

  Future<void> remove(String id) async =>
      _entries.removeWhere((e) => e.id == id);
}
