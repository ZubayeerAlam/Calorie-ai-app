import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../core/services/cloud_store.dart';
import '../../../core/services/local_storage_service.dart';

/// Thrown when the cloud copy can't be read while linking an account.
class SyncException implements Exception {
  const SyncException(this.cause);

  final Object cause;

  @override
  String toString() => 'SyncException($cause)';
}

/// Keeps a signed-in user's local data and their cloud copy in step.
///
/// The app always reads and writes local storage (it works offline). While
/// connected, every local change is copied to the cloud. Connecting merges
/// the two copies:
/// - food entries: the union of both, by id;
/// - day-by-day logs (activity, weight, steps): merged per day, the
///   cloud's value winning when both have the same day;
/// - profile and targets: the cloud's copy, when it has one.
///
/// Known limitation: an entry deleted on one phone comes back from another
/// phone that still has it, the next time that phone connects.
class SyncService {
  SyncService({required this._storage, required this._cloud});

  /// Synced storage values. Device-only data (the step sensor's baseline,
  /// Health imports and the Health switch) stays on the device.
  static const List<String> syncedKeys = [
    StorageKeys.userProfile,
    StorageKeys.userGoals,
    StorageKeys.goalsCustomized,
    StorageKeys.activityKcal,
    StorageKeys.weightLog,
    StorageKeys.walkingSteps,
  ];

  /// Values that are `{ "yyyy-mm-dd": value }` maps, merged per day.
  static const Set<String> _dayMaps = {
    StorageKeys.activityKcal,
    StorageKeys.weightLog,
    StorageKeys.walkingSteps,
  };

  final LocalStorageService _storage;
  final CloudStore _cloud;

  String? _uid;

  /// What the cloud has for each food entry id (as JSON text), so only
  /// changed entries are written.
  Map<String, String> _cloudFood = {};

  /// True while merged data is written locally, so it isn't sent back.
  bool _applying = false;

  bool get isConnected => _uid != null;

  /// Merges local and cloud data for [uid], then copies every later local
  /// change to the cloud. Throws [SyncException] if the cloud can't be
  /// read; with [requireCloud] false (app start, maybe offline) it carries
  /// on with local data only.
  Future<void> connect(String uid, {bool requireCloud = true}) async {
    disconnect();
    Map<String, Object> values;
    Map<String, Map<String, dynamic>> food;
    try {
      values = await _cloud.readValues(uid);
      food = await _cloud.readFoodEntries(uid);
    } catch (e) {
      debugPrint('Cloud read failed: $e');
      if (requireCloud) throw SyncException(e);
      // Offline at start: keep copying changes; Firestore sends them later.
      _uid = uid;
      _storage.addChangeListener(_onLocalChange);
      return;
    }

    _cloudFood = {
      for (final MapEntry(:key, :value) in food.entries) key: jsonEncode(value),
    };
    await _applyMerge(values, food);
    _uid = uid;
    _storage.addChangeListener(_onLocalChange);
    _uploadDifferences(values);
  }

  /// Stops copying changes (e.g. on log out).
  void disconnect() {
    _storage.removeChangeListener(_onLocalChange);
    _uid = null;
    _cloudFood = {};
  }

  Future<void> _applyMerge(
    Map<String, Object> cloudValues,
    Map<String, Map<String, dynamic>> cloudFood,
  ) async {
    _applying = true;
    try {
      for (final key in syncedKeys) {
        final cloud = cloudValues[key];
        if (cloud == null) continue;
        final local = _storage.getRaw(key);
        await _storage.setRaw(
          key,
          _dayMaps.contains(key) ? _mergeDayMaps(local, cloud) : cloud,
        );
      }
      if (cloudFood.isNotEmpty) {
        final merged = {
          for (final e in _localFood()) e['id'] as String: e,
          ...cloudFood,
        };
        await _storage.setJsonList(StorageKeys.foodEntries, [...merged.values]);
      }
    } finally {
      _applying = false;
    }
  }

  /// `{...local, ...cloud}` for two day maps stored as JSON text.
  static Object _mergeDayMaps(Object? local, Object cloud) {
    Map<String, dynamic> parse(Object? raw) {
      try {
        return raw is String ? jsonDecode(raw) as Map<String, dynamic> : {};
      } catch (_) {
        return {};
      }
    }

    return jsonEncode({...parse(local), ...parse(cloud)});
  }

  /// Sends whatever the merge left different from the cloud.
  void _uploadDifferences(Map<String, Object> cloudValues) {
    for (final key in syncedKeys) {
      final local = _storage.getRaw(key);
      if (local != null && local != cloudValues[key]) _pushValue(key, local);
    }
    _pushFood();
  }

  void _onLocalChange(String key) {
    if (_applying || _uid == null) return;
    if (key == StorageKeys.foodEntries) {
      _pushFood();
    } else if (syncedKeys.contains(key)) {
      _pushValue(key, _storage.getRaw(key));
    }
  }

  void _pushValue(String key, Object? value) {
    final uid = _uid;
    if (uid == null) return;
    _send(_cloud.writeValue(uid, key, value), 'value $key');
  }

  /// Writes new or changed food entries and deletes removed ones.
  void _pushFood() {
    final uid = _uid;
    if (uid == null) return;
    final local = {for (final e in _localFood()) e['id'] as String: e};
    for (final MapEntry(key: id, value: entry) in local.entries) {
      final json = jsonEncode(entry);
      if (_cloudFood[id] == json) continue;
      _cloudFood[id] = json;
      _send(_cloud.writeFoodEntry(uid, entry), 'food $id');
    }
    for (final id in _cloudFood.keys.toList()) {
      if (local.containsKey(id)) continue;
      _cloudFood.remove(id);
      _send(_cloud.deleteFoodEntry(uid, id), 'delete food $id');
    }
  }

  List<Map<String, dynamic>> _localFood() =>
      _storage.readList(StorageKeys.foodEntries, (json) => json);

  // Not awaited: Firestore queues writes made offline and sends them later.
  void _send(Future<void> write, String what) => unawaited(
    write.catchError(
      (Object e) => debugPrint('Cloud write failed ($what): $e'),
    ),
  );
}
