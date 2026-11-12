import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Keys for everything the app keeps in local storage.
class StorageKeys {
  StorageKeys._();

  static const String userProfile = 'user_profile';
  static const String userGoals = 'user_goals';
  static const String goalsCustomized = 'goals_customized';
  static const String foodEntries = 'food_entries';
  static const String activityKcal = 'activity_kcal';
  static const String weightLog = 'weight_log';
  static const String walkingSteps = 'walking_steps';
  static const String stepBaseline = 'step_baseline';
  static const String healthConnected = 'health_connected';
  static const String healthSteps = 'health_steps';
  static const String healthWorkoutKcal = 'health_workout_kcal';
  static const String reminders = 'reminders';
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String exerciseSettings = 'exercise_settings';
  static const String workoutPlan = 'workout_plan';
  static const String workoutSessions = 'workout_sessions';
}

/// Wraps shared_preferences so features don't depend on it directly.
///
/// Reads are synchronous (values are cached in memory after [init]);
/// writes are persisted asynchronously.
class LocalStorageService {
  LocalStorageService._(this._prefs);

  final SharedPreferences _prefs;
  final List<void Function(String key)> _listeners = [];

  static Future<LocalStorageService> init() async =>
      LocalStorageService._(await SharedPreferences.getInstance());

  /// Calls [listener] with the key after every write or removal (used to
  /// copy changes to the cloud).
  void addChangeListener(void Function(String key) listener) =>
      _listeners.add(listener);

  void removeChangeListener(void Function(String key) listener) =>
      _listeners.remove(listener);

  void _changed(String key) {
    for (final listener in List.of(_listeners)) {
      listener(key);
    }
  }

  // shared_preferences updates its in-memory copy before the returned
  // future completes, so listeners already read the new value.
  Future<bool> _write(String key, Future<bool> write) {
    _changed(key);
    return write;
  }

  String? getString(String key) => _prefs.getString(key);

  Future<bool> setString(String key, String value) =>
      _write(key, _prefs.setString(key, value));

  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setBool(String key, bool value) =>
      _write(key, _prefs.setBool(key, value));

  /// The stored value as is (a String or bool here), or null.
  Object? getRaw(String key) => _prefs.get(key);

  /// Stores a value read with [getRaw]; null removes the key.
  Future<bool> setRaw(String key, Object? value) => switch (value) {
    null => remove(key),
    final String s => setString(key, s),
    final bool b => setBool(key, b),
    _ => throw ArgumentError.value(value, 'value', 'Not a String or bool'),
  };

  Map<String, dynamic>? getJson(String key) {
    final raw = _prefs.getString(key);
    return raw == null ? null : jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<bool> setJson(String key, Map<String, dynamic> value) =>
      setString(key, jsonEncode(value));

  List<Map<String, dynamic>> getJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  Future<bool> setJsonList(String key, List<Map<String, dynamic>> value) =>
      setString(key, jsonEncode(value));

  /// Reads [key] as a model via [fromJson]. Unreadable data (corrupt or from
  /// an older model shape) is deleted and `null` returned instead of throwing,
  /// so a bad value can never crash app start.
  T? readObject<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    try {
      final json = getJson(key);
      return json == null ? null : fromJson(json);
    } catch (_) {
      remove(key);
      return null;
    }
  }

  /// List version of [readObject]; unreadable data gives an empty list.
  List<T> readList<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    try {
      return getJsonList(key).map(fromJson).toList();
    } catch (_) {
      remove(key);
      return [];
    }
  }

  Future<bool> remove(String key) => _write(key, _prefs.remove(key));

  /// Deletes everything (e.g. on log out).
  Future<bool> clear() {
    final keys = _prefs.getKeys().toList();
    final done = _prefs.clear();
    keys.forEach(_changed);
    return done;
  }
}
