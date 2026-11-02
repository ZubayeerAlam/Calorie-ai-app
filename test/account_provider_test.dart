import 'package:cal_ai_app/core/services/auth_service.dart';
import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:cal_ai_app/features/account/data/sync_service.dart';
import 'package:cal_ai_app/features/account/providers/account_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_auth_service.dart';
import 'fake_cloud_store.dart';

void main() {
  late LocalStorageService storage;
  late FakeAuthService auth;
  late FakeCloudStore cloud;
  late int reloads;

  AccountProvider account() => AccountProvider(
    auth: auth,
    sync: SyncService(storage: storage, cloud: cloud),
    storage: storage,
    onDataChanged: () => reloads++,
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await LocalStorageService.init();
    auth = FakeAuthService(accounts: {'sam@x.com': 'secret1'});
    cloud = FakeCloudStore();
    reloads = 0;
  });

  test('signing in links the account and reloads the screens', () async {
    cloud.valuesOf(
      FakeAuthService.uidFor('sam@x.com'),
    )[StorageKeys.userProfile] = '{"name":"Sam"}';
    final provider = account();

    await provider.signIn(' sam@x.com ', 'secret1');

    expect(provider.isSignedIn, isTrue);
    expect(provider.user!.email, 'sam@x.com');
    expect(storage.getJson(StorageKeys.userProfile), {'name': 'Sam'});
    expect(reloads, 1);
    expect(provider.busy, isFalse);
  });

  test('creating an account uploads this phone', () async {
    await storage.setJson(StorageKeys.userGoals, {'dailyCalories': 1800});
    final provider = account();

    await provider.createAccount('new@x.com', 'secret2');
    await pumpEventQueue();

    expect(provider.isSignedIn, isTrue);
    expect(
      cloud.valuesOf(
        FakeAuthService.uidFor('new@x.com'),
      )[StorageKeys.userGoals],
      '{"dailyCalories":1800}',
    );
  });

  test('wrong password: an AuthException and still signed out', () async {
    final provider = account();
    await expectLater(
      provider.signIn('sam@x.com', 'nope'),
      throwsA(
        isA<AuthException>().having(
          (e) => e.failure,
          'failure',
          AuthFailure.wrongCredentials,
        ),
      ),
    );
    expect(provider.isSignedIn, isFalse);
    expect(provider.busy, isFalse);
  });

  test('an unreachable backup signs out again', () async {
    cloud.failReads = true;
    final provider = account();
    await expectLater(
      provider.signIn('sam@x.com', 'secret1'),
      throwsA(isA<SyncException>()),
    );
    expect(provider.isSignedIn, isFalse);
    expect(auth.currentUser, isNull);
  });

  test('logging out clears this phone but not the account', () async {
    final provider = account();
    await provider.signIn('sam@x.com', 'secret1');
    await storage.setJson(StorageKeys.userProfile, {'name': 'Sam'});
    await pumpEventQueue();

    await provider.signOut();

    expect(provider.isSignedIn, isFalse);
    expect(storage.getJson(StorageKeys.userProfile), isNull);
    expect(
      cloud.valuesOf(
        FakeAuthService.uidFor('sam@x.com'),
      )[StorageKeys.userProfile],
      '{"name":"Sam"}',
    );
    expect(reloads, 2);
  });

  test('a user still signed in syncs again at start', () async {
    auth = FakeAuthService(
      signedIn: const AppUser(uid: 'uid-1', email: 'a@x.com'),
    );
    cloud.foodOf('uid-1')['f'] = {
      'id': 'f',
      'name': 'Toast',
      'calories': 80,
      'protein': 3,
      'carbs': 14,
      'fat': 1,
      'mealType': 'breakfast',
      'loggedAt': '2026-11-02T08:00:00.000',
    };
    final provider = account();

    await provider.start();

    expect(provider.isSignedIn, isTrue);
    expect(storage.getJsonList(StorageKeys.foodEntries), hasLength(1));
    expect(reloads, 1);
  });

  test('Firebase error codes map to friendly failures', () {
    AuthFailure f(String code) => FirebaseAuthService.failureFor(code);
    expect(f('invalid-credential'), AuthFailure.wrongCredentials);
    expect(f('user-not-found'), AuthFailure.wrongCredentials);
    expect(f('email-already-in-use'), AuthFailure.emailInUse);
    expect(f('weak-password'), AuthFailure.weakPassword);
    expect(f('network-request-failed'), AuthFailure.network);
    expect(f('operation-not-allowed'), AuthFailure.notEnabled);
    expect(f('something-new'), AuthFailure.unknown);
  });
}
