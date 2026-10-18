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
}

/// Wraps shared_preferences so features don't depend on it directly.
///
/// Reads are synchronous (values are cached in memory after [init]);
/// writes are persisted asynchronously.
class LocalStorageService {
  LocalStorageService._(this._prefs);

  final SharedPreferences _prefs;

  static Future<LocalStorageService> init() async =>
      LocalStorageService._(await SharedPreferences.getInstance());

  String? getString(String key) => _prefs.getString(key);

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  Map<String, dynamic>? getJson(String key) {
    final raw = _prefs.getString(key);
    return raw == null ? null : jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<bool> setJson(String key, Map<String, dynamic> value) =>
      _prefs.setString(key, jsonEncode(value));

  List<Map<String, dynamic>> getJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  Future<bool> setJsonList(String key, List<Map<String, dynamic>> value) =>
      _prefs.setString(key, jsonEncode(value));

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

  Future<bool> remove(String key) => _prefs.remove(key);

  Future<bool> clear() => _prefs.clear();
}
