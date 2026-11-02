import 'dart:convert';

import 'package:cal_ai_app/app.dart';
import 'package:cal_ai_app/core/services/auth_service.dart';
import 'package:cal_ai_app/core/services/health_service.dart';
import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:cal_ai_app/core/utils/date_utils.dart';
import 'package:cal_ai_app/features/food_log/data/models/food_entry.dart';
import 'package:cal_ai_app/features/profile/data/models/user_goals.dart';
import 'package:cal_ai_app/features/profile/data/models/user_profile.dart';
import 'package:cal_ai_app/features/tracker/presentation/screens/tracker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_auth_service.dart';
import 'fake_cloud_store.dart';
import 'fake_food_analysis_service.dart';
import 'fake_health_service.dart';
import 'fake_image_picker.dart';
import 'fake_step_counter.dart';

UserProfile _profile() => UserProfile(
  name: 'Sam',
  gender: Gender.female,
  birthday: DateTime(1995, 6, 1),
  heightCm: 170,
  weightKg: 70,
  goal: GoalType.maintain,
  activityLevel: ActivityLevel.moderate,
  dietType: DietType.classic,
);

FoodEntry _food(String id, int kcal, DateTime day) => FoodEntry(
  id: id,
  name: 'Food $id',
  calories: kcal,
  protein: 50,
  carbs: 200,
  fat: 60,
  mealType: MealType.lunch,
  loggedAt: DateTime(day.year, day.month, day.day, 13),
);

/// Storage with a saved profile (2000 kcal, hand-set) and [food].
Future<LocalStorageService> _storage({
  bool onboarded = true,
  List<FoodEntry> food = const [],
}) async {
  SharedPreferences.setMockInitialValues({});
  final storage = await LocalStorageService.init();
  if (onboarded) {
    await storage.setJson(StorageKeys.userProfile, _profile().toJson());
    await storage.setJson(StorageKeys.userGoals, const UserGoals().toJson());
    await storage.setBool(StorageKeys.goalsCustomized, true);
  }
  await storage.setJsonList(StorageKeys.foodEntries, [
    for (final f in food) f.toJson(),
  ]);
  return storage;
}

Future<void> _pumpApp(
  WidgetTester tester,
  LocalStorageService storage, {
  AuthService? auth,
  FakeCloudStore? cloud,
  HealthService? health,
}) async {
  tester.view.physicalSize = const Size(1290, 2796);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    CalAiApp(
      storage: storage,
      stepCounter: FakeStepCounter(),
      imagePicker: FakeImagePicker(),
      foodAnalysis: FakeFoodAnalysisService(),
      auth: auth,
      cloudStore: cloud,
      health: health,
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Scrolls the Tracker's list until [finder] is built and visible.
/// A negative [delta] scrolls back up.
Future<void> _scrollTo(
  WidgetTester tester,
  Finder finder, {
  double delta = 300,
}) async {
  await tester.scrollUntilVisible(
    finder,
    delta,
    scrollable: find
        .descendant(
          of: find.byType(TrackerScreen),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await tester.pumpAndSettle();
}

void main() {
  final today = AppDates.today();
  final yesterday = today.subtract(const Duration(days: 1));

  group('Tracker', () {
    testWidgets('summarises the week: streak, average, history', (
      tester,
    ) async {
      await _pumpApp(
        tester,
        await _storage(
          food: [_food('a', 2050, today), _food('b', 1500, yesterday)],
        ),
      );
      await _tap(tester, find.text('Tracker'));

      expect(
        find.descendant(
          of: find.byKey(const ValueKey('streak-tile')),
          matching: find.text('🔥 2'),
        ),
        findsOneWidget,
      );
      expect(find.text('1,775'), findsOneWidget); // (2050 + 1500) / 2
      expect(find.text('1/7'), findsOneWidget); // only 2050 is on target
      await _scrollTo(tester, find.text('50 / 150 g')); // average protein
      expect(find.text('50 / 150 g'), findsOneWidget);
      await _scrollTo(tester, find.text('2,050 / 2,000 kcal'));
      expect(find.text('2,050 / 2,000 kcal'), findsOneWidget);
      expect(find.text('1,500 / 2,000 kcal'), findsOneWidget);

      await _scrollTo(tester, find.text('Month'), delta: -300);
      await _tap(tester, find.text('Month'));
      expect(find.text('1/30'), findsOneWidget);
    });

    testWidgets('logging a weight updates the current weight and Home', (
      tester,
    ) async {
      await _pumpApp(tester, await _storage());
      await _tap(tester, find.text('Tracker'));
      expect(find.text('70 kg'), findsOneWidget);
      expect(find.text('Log your weight to see the trend'), findsOneWidget);

      await _tap(tester, find.byKey(const ValueKey('log-weight')));
      await tester.enterText(find.byKey(const ValueKey('weight-input')), '5');
      await tester.pump();
      expect(find.text('Enter a realistic weight'), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey('weight-input')),
        '68.5',
      );
      await _tap(tester, find.byKey(const ValueKey('save-weight')));

      expect(find.text('68.5 kg'), findsOneWidget);

      // The profile on Home follows.
      await _tap(tester, find.text('Home'));
      expect(find.textContaining('68.5'), findsWidgets);
    });

    testWidgets('a history day opens on Home', (tester) async {
      await _pumpApp(
        tester,
        await _storage(food: [_food('b', 1500, yesterday)]),
      );
      await _tap(tester, find.text('Tracker'));
      final day = find.byKey(ValueKey('history-${AppDates.key(yesterday)}'));
      await _scrollTo(tester, day);
      await _tap(tester, day);

      expect(find.textContaining('Yesterday, '), findsOneWidget);
    });
  });

  group('Account', () {
    testWidgets('sign-in is hidden when accounts are unavailable', (
      tester,
    ) async {
      await _pumpApp(tester, await _storage());
      await _tap(tester, find.text('Account'));
      expect(find.text('Back up your data'), findsNothing);
    });

    testWidgets('create an account, then log out back to onboarding', (
      tester,
    ) async {
      final auth = FakeAuthService();
      final cloud = FakeCloudStore();
      await _pumpApp(
        tester,
        await _storage(food: [_food('a', 500, today)]),
        auth: auth,
        cloud: cloud,
      );
      await _tap(tester, find.text('Account'));
      expect(find.text('Back up your data'), findsOneWidget);

      await _tap(tester, find.byKey(const ValueKey('open-sign-in')));
      await _tap(tester, find.byKey(const ValueKey('toggle-sign-in-mode')));
      expect(find.text('At least 6 characters'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('email-field')),
        'sam@x.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password-field')),
        'secret1',
      );
      await tester.pump();
      await _tap(tester, find.byKey(const ValueKey('submit-sign-in')));

      // Back on Account, signed in, and this phone's data is in the cloud.
      expect(find.text('sam@x.com'), findsOneWidget);
      expect(find.text('Backed up and synced to your account'), findsOneWidget);
      final uid = FakeAuthService.uidFor('sam@x.com');
      expect(cloud.foodOf(uid).keys, ['a']);
      expect(cloud.valuesOf(uid), contains(StorageKeys.userProfile));

      await _tap(tester, find.byKey(const ValueKey('log-out')));
      await _tap(tester, find.byKey(const ValueKey('confirm-log-out')));

      expect(find.text("What's your name?"), findsOneWidget);
      expect(auth.currentUser, isNull);
    });

    testWidgets('wrong password shows an error and stays on sign-in', (
      tester,
    ) async {
      await _pumpApp(
        tester,
        await _storage(),
        auth: FakeAuthService(accounts: {'sam@x.com': 'secret1'}),
        cloud: FakeCloudStore(),
      );
      await _tap(tester, find.text('Account'));
      await _tap(tester, find.byKey(const ValueKey('open-sign-in')));
      await tester.enterText(
        find.byKey(const ValueKey('email-field')),
        'sam@x.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password-field')),
        'wrong-pw',
      );
      await tester.pump();
      await _tap(tester, find.byKey(const ValueKey('submit-sign-in')));

      expect(find.text('Wrong email or password.'), findsOneWidget);
      expect(find.byKey(const ValueKey('submit-sign-in')), findsOneWidget);
    });

    testWidgets('a new phone restores the account from onboarding', (
      tester,
    ) async {
      final cloud = FakeCloudStore();
      final uid = FakeAuthService.uidFor('sam@x.com');
      cloud.valuesOf(uid)[StorageKeys.userProfile] = jsonEncode(
        _profile().toJson(),
      );
      cloud.foodOf(uid)['a'] = _food('a', 420, today).toJson();

      await _pumpApp(
        tester,
        await _storage(onboarded: false),
        auth: FakeAuthService(accounts: {'sam@x.com': 'secret1'}),
        cloud: cloud,
      );
      expect(find.text("What's your name?"), findsOneWidget);

      await _tap(tester, find.byKey(const ValueKey('onboarding-sign-in')));
      await tester.enterText(
        find.byKey(const ValueKey('email-field')),
        'sam@x.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password-field')),
        'secret1',
      );
      await tester.pump();
      await _tap(tester, find.byKey(const ValueKey('submit-sign-in')));

      // Onboarding is skipped: the restored profile and meal are on Home.
      expect(find.text("What's your name?"), findsNothing);
      expect(find.textContaining('Sam'), findsWidgets);
      expect(find.textContaining('420 / '), findsOneWidget);
    });
  });

  group('Health', () {
    testWidgets('connecting imports steps and workouts for Home', (
      tester,
    ) async {
      final health = FakeHealthService(
        steps: {AppDates.key(today): 4000},
        workoutKcal: {AppDates.key(today): 250},
      );
      await _pumpApp(tester, await _storage(), health: health);
      await _tap(tester, find.text('Account'));
      expect(find.text('Health Connect'), findsOneWidget);

      await _tap(tester, find.byKey(const ValueKey('connect-health')));
      expect(find.text('Health Connect connected'), findsOneWidget);

      await _tap(tester, find.text('Home'));
      expect(find.text('4,000 steps'), findsOneWidget);
      expect(find.text('250'), findsWidgets); // workout kcal under Activity
    });

    testWidgets('the Health card is hidden without a health platform', (
      tester,
    ) async {
      await _pumpApp(
        tester,
        await _storage(),
        health: FakeHealthService(
          availabilityResult: HealthAvailability.unsupported,
        ),
      );
      await _tap(tester, find.text('Account'));
      expect(find.byKey(const ValueKey('connect-health')), findsNothing);
    });
  });
}
