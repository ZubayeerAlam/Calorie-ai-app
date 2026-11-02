import 'dart:convert';

import 'package:cal_ai_app/core/services/cloud_store.dart';

/// Test double for Firestore: each user's values and food entries in memory.
class FakeCloudStore implements CloudStore {
  final Map<String, Map<String, Object>> values = {};
  final Map<String, Map<String, Map<String, dynamic>>> food = {};

  /// When true, reads fail (offline, or Firestore not created).
  bool failReads = false;
  int writes = 0;

  Map<String, Object> valuesOf(String uid) => values.putIfAbsent(uid, () => {});

  Map<String, Map<String, dynamic>> foodOf(String uid) =>
      food.putIfAbsent(uid, () => {});

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
  Future<Map<String, Map<String, dynamic>>> readFoodEntries(String uid) async {
    if (failReads) throw StateError('offline');
    // Copies, like documents read from the server.
    return {
      for (final MapEntry(:key, :value) in foodOf(uid).entries)
        key: jsonDecode(jsonEncode(value)) as Map<String, dynamic>,
    };
  }

  @override
  Future<void> writeFoodEntry(String uid, Map<String, dynamic> entry) async {
    writes++;
    foodOf(uid)[entry['id'] as String] =
        jsonDecode(jsonEncode(entry)) as Map<String, dynamic>;
  }

  @override
  Future<void> deleteFoodEntry(String uid, String id) async {
    writes++;
    foodOf(uid).remove(id);
  }
}
