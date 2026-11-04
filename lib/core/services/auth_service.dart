import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../l10n/l10n.dart';

/// The signed-in user.
class AppUser {
  const AppUser({required this.uid, this.email});

  final String uid;
  final String? email;
}

enum AuthFailure {
  invalidEmail,
  wrongCredentials,
  emailInUse,
  weakPassword,
  network,
  tooManyRequests,

  /// Email/Password sign-in isn't enabled in the Firebase Console.
  notEnabled,
  unknown,
}

class AuthException implements Exception {
  const AuthException(this.failure);

  final AuthFailure failure;

  String get message => switch (failure) {
    AuthFailure.invalidEmail => l10n.authInvalidEmail,
    AuthFailure.wrongCredentials => l10n.authWrongCredentials,
    AuthFailure.emailInUse => l10n.authEmailInUse,
    AuthFailure.weakPassword => l10n.authWeakPassword,
    AuthFailure.network => l10n.authNetwork,
    AuthFailure.tooManyRequests => l10n.authTooManyRequests,
    AuthFailure.notEnabled => l10n.authNotEnabled,
    AuthFailure.unknown => l10n.authUnknown,
  };

  @override
  String toString() => 'AuthException($failure)';
}

/// Email/password accounts. Signing in is optional: the app works the same
/// without an account, and signing in adds cloud backup and sync.
abstract class AuthService {
  /// False where accounts aren't set up (e.g. tests); sign-in is hidden.
  bool get isAvailable;

  AppUser? get currentUser;

  Future<AppUser> signIn(String email, String password);

  Future<AppUser> createAccount(String email, String password);

  Future<void> sendPasswordReset(String email);

  Future<void> signOut();
}

/// Accounts turned off; the default until Firebase Auth is passed in.
class UnavailableAuthService implements AuthService {
  const UnavailableAuthService();

  @override
  bool get isAvailable => false;

  @override
  AppUser? get currentUser => null;

  @override
  Future<AppUser> signIn(String email, String password) =>
      Future.error(const AuthException(AuthFailure.notEnabled));

  @override
  Future<AppUser> createAccount(String email, String password) =>
      Future.error(const AuthException(AuthFailure.notEnabled));

  @override
  Future<void> sendPasswordReset(String email) =>
      Future.error(const AuthException(AuthFailure.notEnabled));

  @override
  Future<void> signOut() async {}
}

/// Firebase Authentication with Email/Password.
class FirebaseAuthService implements AuthService {
  FirebaseAuthService([FirebaseAuth? auth])
    : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  bool get isAvailable => true;

  @override
  AppUser? get currentUser => _toUser(_auth.currentUser);

  @override
  Future<AppUser> signIn(String email, String password) => _run(
    () => _auth.signInWithEmailAndPassword(email: email, password: password),
  );

  @override
  Future<AppUser> createAccount(String email, String password) => _run(
    () =>
        _auth.createUserWithEmailAndPassword(email: email, password: password),
  );

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(failureFor(e.code));
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  Future<AppUser> _run(Future<UserCredential> Function() call) async {
    try {
      final user = _toUser((await call()).user);
      if (user == null) throw const AuthException(AuthFailure.unknown);
      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Auth failed: ${e.code} ${e.message}');
      throw AuthException(failureFor(e.code));
    }
  }

  static AppUser? _toUser(User? user) =>
      user == null ? null : AppUser(uid: user.uid, email: user.email);

  /// Firebase error codes → what the sign-in screen tells the user.
  @visibleForTesting
  static AuthFailure failureFor(String code) => switch (code) {
    'invalid-email' => AuthFailure.invalidEmail,
    'invalid-credential' ||
    'wrong-password' ||
    'user-not-found' ||
    'user-disabled' => AuthFailure.wrongCredentials,
    'email-already-in-use' => AuthFailure.emailInUse,
    'weak-password' => AuthFailure.weakPassword,
    'network-request-failed' => AuthFailure.network,
    'too-many-requests' => AuthFailure.tooManyRequests,
    'operation-not-allowed' ||
    'configuration-not-found' => AuthFailure.notEnabled,
    _ => AuthFailure.unknown,
  };
}
