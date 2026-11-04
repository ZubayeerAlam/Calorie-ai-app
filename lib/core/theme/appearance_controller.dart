import 'package:flutter/material.dart';

import '../services/local_storage_service.dart';

/// Light, dark, or follow the phone (Account → Appearance). Kept on this
/// phone only.
class AppearanceController extends ChangeNotifier {
  AppearanceController(this._storage)
    : _mode =
          ThemeMode.values.asNameMap()[_storage.getString(
            StorageKeys.themeMode,
          )] ??
          ThemeMode.system;

  final LocalStorageService _storage;
  ThemeMode _mode;

  ThemeMode get mode => _mode;

  void setMode(ThemeMode mode) {
    if (mode == _mode) return;
    _mode = mode;
    _storage.setString(StorageKeys.themeMode, mode.name);
    notifyListeners();
  }

  /// Whether to use the dark palette, given the phone's own setting.
  bool isDark(Brightness platform) => switch (_mode) {
    ThemeMode.dark => true,
    ThemeMode.light => false,
    ThemeMode.system => platform == Brightness.dark,
  };
}
