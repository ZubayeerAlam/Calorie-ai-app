import 'dart:convert';

import 'package:cal_ai_app/app.dart';
import 'package:cal_ai_app/core/services/auth_service.dart';
import 'package:cal_ai_app/core/services/health_service.dart';
import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:cal_ai_app/core/theme/app_colors.dart';
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
import 'fake_notification_service.dart';
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
  FakeNotificationService? notifications,
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
      notifications: notifications,
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

  group('Account management', () {
    testWidgets('edit the profile: name, height and goal update Home', (
      tester,
    ) async {
      final storage = await _storage();
      // Recommended targets, so they follow the edited profile.
      await storage.setBool(StorageKeys.goalsCustomized, false);
      await _pumpApp(tester, storage);
      await _tap(tester, find.text('Account'));
      expect(find.text('Sam'), findsOneWidget);
      final before = find.textContaining('Daily calorie goal').evaluate();
      final beforeText = (before.single.widget as Text).data;

      await _tap(tester, find.byKey(const ValueKey('edit-profile')));
      await tester.enterText(find.byKey(const ValueKey('edit-name')), 'Samira');
      await tester.enterText(
        find.byKey(const ValueKey('height-cm-input')),
        '180',
      );
      await _tap(tester, find.text('🔥 Lose weight'));
      await _tap(tester, find.byKey(const ValueKey('save-profile')));

      expect(find.text('Profile saved'), findsOneWidget);
      expect(find.text('Samira'), findsOneWidget);
      expect(find.textContaining('180 cm'), findsOneWidget);
      final afterText =
          (find.textContaining('Daily calorie goal').evaluate().single.widget
                  as Text)
              .data;
      expect(afterText, isNot(beforeText), reason: 'targets recalculated');

      // Saved, and shown on Home.
      final saved = UserProfile.fromJson(
        storage.getJson(StorageKeys.userProfile)!,
      );
      expect(saved.name, 'Samira');
      expect(saved.heightCm, 180);
      expect(saved.goal, GoalType.lose);
      await _tap(tester, find.text('Home'));
      expect(find.textContaining('Samira'), findsWidgets);
    });

    testWidgets('height can be entered in feet and inches', (tester) async {
      final storage = await _storage();
      await _pumpApp(tester, storage);
      await _tap(tester, find.text('Account'));
      await _tap(tester, find.byKey(const ValueKey('edit-profile')));

      await _tap(tester, find.text('lb · ft'));
      // 170 cm is shown as 5 ft 7 in.
      expect(find.text('5'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('height-ft-input')),
        '6',
      );
      await tester.enterText(
        find.byKey(const ValueKey('height-in-input')),
        '0',
      );
      await tester.pump();
      await _tap(tester, find.byKey(const ValueKey('save-profile')));

      final saved = UserProfile.fromJson(
        storage.getJson(StorageKeys.userProfile)!,
      );
      expect(saved.heightCm, 183); // 72 in × 2.54
      expect(saved.useMetric, isFalse);
      expect(find.textContaining('6′0″'), findsOneWidget);
    });

    testWidgets('an impossible height or empty name cannot be saved', (
      tester,
    ) async {
      await _pumpApp(tester, await _storage());
      await _tap(tester, find.text('Account'));
      await _tap(tester, find.byKey(const ValueKey('edit-profile')));
      ElevatedButton save() =>
          tester.widget(find.byKey(const ValueKey('save-profile')));

      await tester.enterText(
        find.byKey(const ValueKey('height-cm-input')),
        '40',
      );
      await tester.pump();
      expect(save().onPressed, isNull);
      expect(find.textContaining('between 100 and 250 cm'), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey('height-cm-input')),
        '165',
      );
      await tester.enterText(find.byKey(const ValueKey('edit-name')), '  ');
      await tester.pump();
      expect(save().onPressed, isNull);
    });

    testWidgets('reset all data starts over, and clears the account too', (
      tester,
    ) async {
      final cloud = FakeCloudStore();
      final storage = await _storage(food: [_food('a', 500, today)]);
      await _pumpApp(tester, storage, auth: FakeAuthService(), cloud: cloud);
      await _tap(tester, find.text('Account'));
      await _tap(tester, find.byKey(const ValueKey('open-sign-in')));
      await _tap(tester, find.byKey(const ValueKey('toggle-sign-in-mode')));
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
      final uid = FakeAuthService.uidFor('sam@x.com');
      expect(cloud.foodOf(uid), isNotEmpty);
      // Let the "signed in" snack bar go; it covers the bottom of the list.
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      await _tap(tester, find.byKey(const ValueKey('reset-data')));
      expect(find.textContaining("You'll stay signed in"), findsOneWidget);
      await _tap(tester, find.byKey(const ValueKey('confirm-reset')));

      expect(find.text("What's your name?"), findsOneWidget);
      expect(storage.getJson(StorageKeys.userProfile), isNull);
      expect(cloud.foodOf(uid), isEmpty);
      expect(cloud.valuesOf(uid), isEmpty);
    });
  });

  group('Reminders', () {
    testWidgets('the bell opens reminders; turning one on schedules it', (
      tester,
    ) async {
      final notifications = FakeNotificationService();
      await _pumpApp(tester, await _storage(), notifications: notifications);

      await _tap(tester, find.byTooltip('Notifications'));
      expect(find.text('Reminders'), findsOneWidget);
      expect(find.textContaining('Turn on a reminder'), findsOneWidget);

      await _tap(tester, find.byKey(const ValueKey('reminder-switch-dinner')));
      expect(notifications.timesFor('dinner'), isNotEmpty);
      // The dinner reminder uses the profile's dinner time (8:30 PM).
      expect(notifications.timesFor('dinner').last.hour, 20);
      expect(find.byKey(const ValueKey('today-dinner')), findsOneWidget);
    });

    testWidgets('refused notifications explain how to allow them', (
      tester,
    ) async {
      await _pumpApp(
        tester,
        await _storage(),
        notifications: FakeNotificationService(granted: false),
      );
      await _tap(tester, find.byTooltip('Notifications'));
      await _tap(tester, find.byKey(const ValueKey('reminder-switch-lunch')));
      expect(
        find.textContaining('Notifications are turned off'),
        findsOneWidget,
      );
    });

    testWidgets('tapping a reminder notification opens Add Food for it', (
      tester,
    ) async {
      final notifications = FakeNotificationService();
      await _pumpApp(tester, await _storage(), notifications: notifications);
      notifications.tapHandler!('lunch');
      await tester.pumpAndSettle();
      expect(find.text('Add Food'), findsWidgets);
    });
  });

  group('Appearance', () {
    Color background(WidgetTester tester) =>
        tester.widget<Scaffold>(find.byType(Scaffold).first).backgroundColor ??
        Theme.of(tester.element(find.byType(Scaffold).first))
            .scaffoldBackgroundColor;

    testWidgets('Dark mode from Account, kept after a restart', (tester) async {
      final storage = await _storage();
      await _pumpApp(tester, storage);
      expect(AppColors.isDark, isFalse);

      await _tap(tester, find.text('Account'));
      await _tap(tester, find.text('Dark'));
      expect(AppColors.isDark, isTrue);
      expect(background(tester), const Color(0xFF121212));
      expect(storage.getString(StorageKeys.themeMode), 'dark');

      // A fresh start uses the saved choice.
      await tester.pumpWidget(const SizedBox());
      await _pumpApp(tester, storage);
      expect(AppColors.isDark, isTrue);

      await _tap(tester, find.text('Account'));
      await _tap(tester, find.text('Light'));
      expect(AppColors.isDark, isFalse);
    });

    testWidgets('System follows the phone', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      await _pumpApp(tester, await _storage());
      expect(AppColors.isDark, isTrue);

      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      await tester.pumpAndSettle();
      expect(AppColors.isDark, isFalse);
    });
  });

  group('Language', () {
    testWidgets('Bangla from Account, back to English, kept after restart', (
      tester,
    ) async {
      final storage = await _storage(food: [_food('a', 500, today)]);
      await _pumpApp(tester, storage);
      expect(find.text('Home'), findsOneWidget);

      await _tap(tester, find.text('Account'));
      await _tap(tester, find.text('বাংলা'));
      expect(storage.getString(StorageKeys.language), 'bn');
      expect(find.text('প্রোফাইল ও লক্ষ্য'), findsOneWidget);
      expect(find.text('হোম'), findsOneWidget);
      expect(find.text('Home'), findsNothing);

      await _tap(tester, find.text('হোম'));
      expect(find.textContaining('আজ, '), findsOneWidget);
      expect(find.text('সকালের নাশতা'), findsOneWidget);

      // A fresh start keeps Bangla.
      await tester.pumpWidget(const SizedBox());
      await _pumpApp(tester, storage);
      expect(find.text('হোম'), findsOneWidget);

      await _tap(tester, find.text('অ্যাকাউন্ট'));
      await _tap(tester, find.text('English'));
      expect(find.text('Profile & Goals'), findsOneWidget);
      expect(storage.getString(StorageKeys.language), 'en');
    });

    testWidgets("System follows the phone's language", (tester) async {
      tester.platformDispatcher.localesTestValue = const [Locale('bn', 'BD')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      await _pumpApp(tester, await _storage());
      expect(find.text('ট্র্যাকার'), findsOneWidget);
    });

    testWidgets('reminder texts are in the language in use', (tester) async {
      final notifications = FakeNotificationService();
      final storage = await _storage();
      await storage.setString(StorageKeys.language, 'bn');
      await _pumpApp(tester, storage, notifications: notifications);
      await _tap(tester, find.byKey(const ValueKey('notifications')));
      await _tap(tester, find.byKey(const ValueKey('reminder-switch-dinner')));
      expect(notifications.scheduled.values.first.title, 'রাতের খাবারের সময়');
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
