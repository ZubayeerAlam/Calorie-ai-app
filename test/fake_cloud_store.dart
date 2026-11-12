import 'dart:convert';

import 'package:cal_ai_app/core/services/cloud_store.dart';

/// Test double for Firestore: each user's values and entries in memory.
class FakeCloudStore implements CloudStore {
  final Map<String, Map<String, Object>> values = {};

  /// collection → uid → id → entry.
  final Map<String, Map<String, Map<String, Map<String, dynamic>>>> entries =
      {};

  /// When true, reads fail (offline, or Firestore not created).
  bool failReads = false;
  int writes = 0;

  Map<String, Object> valuesOf(String uid) => values.putIfAbsent(uid, () => {});

  Map<String, Map<String, dynamic>> entriesOf(String uid, String collection) =>
      entries.putIfAbsent(collection, () => {}).putIfAbsent(uid, () => {});

  Map<String, Map<String, dynamic>> foodOf(String uid) =>
      entriesOf(uid, 'food_entries');

  Map<String, Map<String, dynamic>> workoutsOf(String uid) =>
      entriesOf(uid, 'workout_sessions');

  @override
  Future<Map<String, Object>> readValues(String uid) async {
    if (failReads) throw StateError('offline');
    return Map.of(valuesOf(uid));
  }

  @override
  Future<void> writeValue(String uid, String key, Object? value) async {
    writes++;
    if (value == null) {
      valuesOf(uid).remove(key);
    } else {
      valuesOf(uid)[key] = value;
    }
  }

  @override
  Future<Map<String, Map<String, dynamic>>> readEntries(
    String uid,
    String collection,
  ) async {
    if (failReads) throw StateError('offline');
    // Copies, like documents read from the server.
    return {
      for (final MapEntry(:key, :value) in entriesOf(uid, collection).entries)
        key: jsonDecode(jsonEncode(value)) as Map<String, dynamic>,
    };
  }

  @override
  Future<void> writeEntry(
    String uid,
    String collection,
    Map<String, dynamic> entry,
  ) async {
    writes++;
    entriesOf(uid, collection)[entry['id'] as String] =
        jsonDecode(jsonEncode(entry)) as Map<String, dynamic>;
  }

  @override
  Future<void> deleteEntry(String uid, String collection, String id) async {
    writes++;
    entriesOf(uid, collection).remove(id);
  }
}
