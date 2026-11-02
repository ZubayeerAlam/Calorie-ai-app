import 'package:cal_ai_app/core/services/auth_service.dart';

/// Test double for Firebase Auth: accounts by email, in memory.
class FakeAuthService implements AuthService {
  FakeAuthService({Map<String, String>? accounts, AppUser? signedIn})
    : accounts = accounts ?? {},
      _user = signedIn;

  /// email → password.
  final Map<String, String> accounts;
  AppUser? _user;

  /// When set, the next call fails with it.
  AuthFailure? failNext;

  static String uidFor(String email) => 'uid-$email';

  @override
  bool get isAvailable => true;

  @override
  AppUser? get currentUser => _user;

  void _maybeFail() {
    final failure = failNext;
    failNext = null;
    if (failure != null) throw AuthException(failure);
  }

  @override
  Future<AppUser> signIn(String email, String password) async {
    _maybeFail();
    if (accounts[email] != password) {
      throw const AuthException(AuthFailure.wrongCredentials);
    }
    return _user = AppUser(uid: uidFor(email), email: email);
  }

  @override
  Future<AppUser> createAccount(String email, String password) async {
    _maybeFail();
    if (accounts.containsKey(email)) {
      throw const AuthException(AuthFailure.emailInUse);
    }
    accounts[email] = password;
    return _user = AppUser(uid: uidFor(email), email: email);
  }

  @override
  Future<void> sendPasswordReset(String email) async => _maybeFail();

  @override
  Future<void> signOut() async => _user = null;
}
