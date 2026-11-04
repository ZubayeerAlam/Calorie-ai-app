import 'package:flutter/widgets.dart';

import '../core/services/local_storage_service.dart';

/// Account → Language: follow the phone, or always English or Bangla.
/// Kept on this phone only.
class LanguageController extends ChangeNotifier {
  LanguageController(this._storage)
    : _code = _storage.getString(StorageKeys.language);

  /// Languages the app is translated into, by code, in their own words.
  static const Map<String, String> languages = {'en': 'English', 'bn': 'বাংলা'};

  final LocalStorageService _storage;

  /// A code from [languages], or null to follow the phone.
  String? _code;

  String? get code => _code;

  /// The locale to force, or null for the phone's language.
  Locale? get locale => _code == null ? null : Locale(_code!);

  void setCode(String? code) {
    if (code == _code) return;
    _code = code;
    if (code == null) {
      _storage.remove(StorageKeys.language);
    } else {
      _storage.setString(StorageKeys.language, code);
    }
    notifyListeners();
  }
}
