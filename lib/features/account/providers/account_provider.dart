import 'package:flutter/foundation.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/local_storage_service.dart';
import '../data/sync_service.dart';

/// The optional account: signing in backs the data up to the cloud and
/// keeps it in sync; logging out removes it from this phone.
class AccountProvider extends ChangeNotifier {
  AccountProvider({
    required this._auth,
    required this._sync,
    required this._storage,
    required this._onDataChanged,
  });

  final AuthService _auth;
  final SyncService _sync;
  final LocalStorageService _storage;

  /// Reloads every screen's data after it changed underneath them.
  final VoidCallback _onDataChanged;

  AppUser? _user;
  bool _busy = false;

  /// False when accounts aren't set up; sign-in is hidden then.
  bool get isAvailable => _auth.isAvailable;
  AppUser? get user => _user;
  bool get isSignedIn => _user != null;
  bool get busy => _busy;

  /// At app start: a user still signed in from last time syncs again.
  Future<void> start() async {
    final user = _auth.currentUser;
    if (user == null) return;
    _user = user;
    notifyListeners();
    await _sync.connect(user.uid, requireCloud: false);
    _onDataChanged();
  }

  /// Signs in and merges this phone's data with the account's.
  Future<void> signIn(String email, String password) =>
      _link(() => _auth.signIn(email.trim(), password));

  /// Creates an account and uploads this phone's data to it.
  Future<void> createAccount(String email, String password) =>
      _link(() => _auth.createAccount(email.trim(), password));

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordReset(email.trim());

  /// Signs out and clears this phone; the data stays in the account.
  Future<void> signOut() async {
    _sync.disconnect();
    await _auth.signOut();
    await _storage.clear();
    _user = null;
    notifyListeners();
    _onDataChanged();
  }

  /// Deletes everything and starts over with onboarding. While signed in
  /// the account's copy is deleted too (sync copies the removals); the
  /// account itself stays signed in.
  Future<void> resetAllData() async {
    await _storage.clear();
    notifyListeners();
    _onDataChanged();
  }

  /// Throws [AuthException], or [SyncException] when the account's data
  /// can't be read (then it signs out again so nothing is half-linked).
  Future<void> _link(Future<AppUser> Function() authenticate) async {
    _setBusy(true);
    try {
      final user = await authenticate();
      try {
        await _sync.connect(user.uid);
      } on SyncException {
        await _auth.signOut();
        rethrow;
      }
      _user = user;
      _onDataChanged();
    } finally {
      _setBusy(false);
    }
  }

  void _setBusy(bool busy) {
    _busy = busy;
    notifyListeners();
  }

  @override
  void dispose() {
    _sync.disconnect();
    super.dispose();
  }
}
