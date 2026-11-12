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
/// - lists saved by id (food entries, workouts): the union of both; when
///   both have an entry, the one updated last (its `updatedAt`) wins, or
///   the cloud's without one;
/// - day-by-day logs (activity, weight, steps): merged per day, the
///   cloud's value winning when both have the same day;
/// - profile, targets, exercise setup and plan: the cloud's copy, when it
///   has one.
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
    StorageKeys.exerciseSettings,
    StorageKeys.workoutPlan,
  ];

  /// Lists saved one cloud document per entry: storage key → collection.
  static const Map<String, String> entryCollections = {
    StorageKeys.foodEntries: 'food_entries',
    StorageKeys.workoutSessions: 'workout_sessions',
  };

  /// Values that are `{ "yyyy-mm-dd": value }` maps, merged per day.
  static const Set<String> _dayMaps = {
    StorageKeys.activityKcal,
    StorageKeys.weightLog,
    StorageKeys.walkingSteps,
  };

  final LocalStorageService _storage;
  final CloudStore _cloud;

  String? _uid;

  /// What the cloud has, per list, for each entry id (as JSON text), so
  /// only changed entries are written.
  Map<String, Map<String, String>> _cloudEntries = {};

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
    final entries = <String, Map<String, Map<String, dynamic>>>{};
    try {
      values = await _cloud.readValues(uid);
      for (final MapEntry(key: key, value: collection)
          in entryCollections.entries) {
        entries[key] = await _cloud.readEntries(uid, collection);
      }
    } catch (e) {
      debugPrint('Cloud read failed: $e');
      if (requireCloud) throw SyncException(e);
      // Offline at start: keep copying changes; Firestore sends them later.
      _uid = uid;
      _storage.addChangeListener(_onLocalChange);
      return;
    }

    _cloudEntries = {
      for (final MapEntry(:key, :value) in entries.entries)
        key: {
          for (final MapEntry(key: id, value: entry) in value.entries)
            id: jsonEncode(entry),
        },
    };
    await _applyMerge(values, entries);
    _uid = uid;
    _storage.addChangeListener(_onLocalChange);
    _uploadDifferences(values);
  }

  /// Stops copying changes (e.g. on log out).
  void disconnect() {
    _storage.removeChangeListener(_onLocalChange);
    _uid = null;
    _cloudEntries = {};
  }

  Future<void> _applyMerge(
    Map<String, Object> cloudValues,
    Map<String, Map<String, Map<String, dynamic>>> cloudEntries,
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
      for (final MapEntry(:key, value: cloud) in cloudEntries.entries) {
        if (cloud.isEmpty) continue;
        final merged = {
          for (final e in _localEntries(key)) e['id'] as String: e,
        };
        for (final MapEntry(key: id, value: entry) in cloud.entries) {
          final local = merged[id];
          if (local == null || !_isNewer(local, entry)) merged[id] = entry;
        }
        await _storage.setJsonList(key, [...merged.values]);
      }
    } finally {
      _applying = false;
    }
  }

  /// True when [a] was updated after [b] (both have an `updatedAt`).
  static bool _isNewer(Map<String, dynamic> a, Map<String, dynamic> b) {
    final ta = a['updatedAt'];
    final tb = b['updatedAt'];
    return ta is String && tb is String && ta.compareTo(tb) > 0;
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
    entryCollections.keys.forEach(_pushEntries);
  }

  void _onLocalChange(String key) {
    if (_applying || _uid == null) return;
    if (entryCollections.containsKey(key)) {
      _pushEntries(key);
    } else if (syncedKeys.contains(key)) {
      _pushValue(key, _storage.getRaw(key));
    }
  }

  void _pushValue(String key, Object? value) {
    final uid = _uid;
    if (uid == null) return;
    _send(_cloud.writeValue(uid, key, value), 'value $key');
  }

  /// Writes new or changed entries of the list [key] and deletes removed
  /// ones.
  void _pushEntries(String key) {
    final uid = _uid;
    final collection = entryCollections[key];
    if (uid == null || collection == null) return;
    final cloud = _cloudEntries.putIfAbsent(key, () => {});
    final local = {for (final e in _localEntries(key)) e['id'] as String: e};
    for (final MapEntry(key: id, value: entry) in local.entries) {
      final json = jsonEncode(entry);
      if (cloud[id] == json) continue;
      cloud[id] = json;
      _send(_cloud.writeEntry(uid, collection, entry), '$collection $id');
    }
    for (final id in cloud.keys.toList()) {
      if (local.containsKey(id)) continue;
      cloud.remove(id);
      _send(_cloud.deleteEntry(uid, collection, id), 'delete $collection $id');
    }
  }

  List<Map<String, dynamic>> _localEntries(String key) =>
      _storage.readList(key, (json) => json);

  // Not awaited: Firestore queues writes made offline and sends them later.
  void _send(Future<void> write, String what) => unawaited(
    write.catchError(
      (Object e) => debugPrint('Cloud write failed ($what): $e'),
    ),
  );
}
