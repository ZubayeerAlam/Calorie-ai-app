import 'package:cal_ai_app/app.dart';
import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:cal_ai_app/core/utils/calorie_calculator.dart';
import 'package:cal_ai_app/features/food_log/data/models/food_entry.dart';
import 'package:cal_ai_app/features/profile/data/models/user_goals.dart';
import 'package:cal_ai_app/features/profile/data/models/user_profile.dart';
import 'package:cal_ai_app/features/profile/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_step_counter.dart';

/// Fresh in-memory shared_preferences for each test.
Future<LocalStorageService> _storage() {
  SharedPreferences.setMockInitialValues({});
  return LocalStorageService.init();
}

/// An already-onboarded profile, so the router starts on the dashboard.
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

/// Fixed default goals (2000 kcal…) so expected numbers stay simple.
ProfileProvider _onboardedProfile() =>
    ProfileProvider(profile: _profile(), goals: const UserGoals());

/// Pumps the app on a phone-sized screen.
Future<void> _pumpApp(
  WidgetTester tester,
  LocalStorageService storage, {
  ProfileProvider? profile,
  FakeStepCounter? steps,
}) async {
  tester.view.physicalSize = const Size(1290, 2796);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    CalAiApp(
      storage: storage,
      profileProvider: profile,
      stepCounter: steps ?? FakeStepCounter(),
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

void main() {
  testWidgets('Home shows calorie, macro and meal targets from goals', (
    tester,
  ) async {
    // Default goals: 2000 kcal, 200 g carbs, 150 g protein, 65 g fat.
    await _pumpApp(tester, await _storage(), profile: _onboardedProfile());

    expect(find.textContaining('Today, '), findsOneWidget);
    expect(find.text('2000'), findsOneWidget);
    expect(find.text('kcal left'), findsOneWidget);
    expect(find.text('/ 200 g'), findsOneWidget);
    expect(find.text('/ 150 g'), findsOneWidget);
    expect(find.text('/ 65 g'), findsOneWidget);
    // Meals split 30 / 30 / 30 / 10.
    expect(find.text('0 / 600 kcal'), findsNWidgets(3));
    expect(find.text('0 / 200 kcal'), findsOneWidget);
    expect(find.text('Snacks'), findsOneWidget);
  });

  testWidgets('Home greets the user and shows their saved profile', (
    tester,
  ) async {
    await _pumpApp(tester, await _storage(), profile: _onboardedProfile());

    // Header: initials avatar, greeting with first name, goal line.
    expect(find.text('S'), findsOneWidget);
    expect(find.textContaining(', Sam'), findsOneWidget);
    expect(find.text('Maintain weight · 2000 kcal a day'), findsOneWidget);

    // Profile card: 70 kg / 170 cm → BMI 24.2.
    await tester.ensureVisible(find.text('BMI'));
    await tester.pumpAndSettle();
    expect(find.text('Keep your weight steady'), findsOneWidget);
    expect(find.text('70.0 kg'), findsOneWidget);
    expect(find.text('170 cm'), findsOneWidget);
    expect(find.text('${_profile().age}'), findsOneWidget);
    expect(find.text('24.2'), findsOneWidget);
    expect(find.text('Healthy'), findsOneWidget);
  });

  testWidgets('Profile card uses imperial units when chosen', (tester) async {
    final imperial = UserProfile.fromJson({
      ..._profile().toJson(),
      'useMetric': false,
      'goal': 'lose',
    });
    await _pumpApp(
      tester,
      await _storage(),
      profile: ProfileProvider(profile: imperial),
    );

    await tester.ensureVisible(find.text('BMI'));
    await tester.pumpAndSettle();
    expect(find.text('154.3 lb'), findsOneWidget);
    expect(find.text('5′7″'), findsOneWidget);
    expect(find.text('−0.45 kg / week'), findsOneWidget);
  });

  testWidgets('Bottom navigation has five tabs', (tester) async {
    await _pumpApp(tester, await _storage(), profile: _onboardedProfile());

    for (final label in [
      'Home',
      'Tracker',
      'Insights',
      'Articles',
      'Account',
    ]) {
      expect(find.text(label), findsOneWidget);
    }

    await tester.tap(find.text('Tracker'));
    await tester.pumpAndSettle();
    expect(find.text('Tracker is coming soon'), findsOneWidget);

    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    expect(find.text('Profile & Goals'), findsOneWidget);
  });

  testWidgets("A meal's + opens Add Food for that meal and logs to it", (
    tester,
  ) async {
    await _pumpApp(tester, await _storage(), profile: _onboardedProfile());

    await _tap(tester, find.byKey(const ValueKey('add-meal-lunch')));
    expect(find.text('Add Food'), findsOneWidget);
    expect(find.text('Lunch'), findsOneWidget); // preselected in the dropdown

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Food name'),
      'Rice bowl',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Calories (kcal)'),
      '450',
    );
    await _tap(tester, find.text('Save'));

    expect(find.text('450 / 600 kcal'), findsOneWidget);
    expect(find.text('1550'), findsOneWidget); // kcal left
  });

  testWidgets('Logging activity adds to burned and kcal left', (tester) async {
    final storage = await _storage();
    await _pumpApp(tester, storage, profile: _onboardedProfile());

    await _tap(tester, find.byKey(const ValueKey('add-activity')));
    await tester.enterText(find.byType(TextField), '300');
    await _tap(tester, find.text('Save'));

    expect(find.text('300'), findsNWidgets(2)); // Burned + Activity
    expect(find.text('2300'), findsOneWidget); // 2000 − 0 + 300
    expect(storage.getJson(StorageKeys.activityKcal)?.values, [300]);
  });

  testWidgets('Date arrows switch the day being shown', (tester) async {
    final storage = await _storage();
    await storage.setJsonList(StorageKeys.foodEntries, [
      FoodEntry(
        id: '1',
        name: 'Oatmeal',
        calories: 300,
        mealType: MealType.breakfast,
        loggedAt: DateTime.now().subtract(const Duration(days: 1)),
      ).toJson(),
    ]);
    await _pumpApp(tester, storage, profile: _onboardedProfile());

    expect(find.text('0 / 600 kcal'), findsNWidgets(3));

    await _tap(tester, find.byTooltip('Previous day'));
    expect(find.textContaining('Yesterday, '), findsOneWidget);
    expect(find.text('300 / 600 kcal'), findsOneWidget);

    await _tap(tester, find.byTooltip('Next day'));
    expect(find.textContaining('Today, '), findsOneWidget);
    expect(find.text('300 / 600 kcal'), findsNothing);
  });

  testWidgets('Add Food can open Scan and come back', (tester) async {
    await _pumpApp(tester, await _storage(), profile: _onboardedProfile());

    await _tap(tester, find.byKey(const ValueKey('add-meal-breakfast')));
    await _tap(tester, find.text('Scan a photo'));
    expect(find.text('Scan Food'), findsOneWidget);

    await _tap(tester, find.byType(BackButton));
    expect(find.text('Add Food'), findsOneWidget);
  });

  testWidgets('A new user is redirected to onboarding', (tester) async {
    await _pumpApp(tester, await _storage());

    expect(find.text("What's your name?"), findsOneWidget);
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('Unreadable saved profile falls back to onboarding', (
    tester,
  ) async {
    final storage = await _storage();
    await storage.setString(StorageKeys.userProfile, '{"name": 42}');

    await _pumpApp(tester, storage);

    expect(find.text("What's your name?"), findsOneWidget);
    expect(storage.getString(StorageKeys.userProfile), isNull);
  });

  testWidgets('Saved profile skips onboarding and loads saved meals', (
    tester,
  ) async {
    final storage = await _storage();
    await storage.setJson(StorageKeys.userProfile, _profile().toJson());
    await storage.setJson(
      StorageKeys.userGoals,
      const UserGoals(dailyCalories: 1800).toJson(),
    );
    // Hand-edited on Account, so it is kept rather than recalculated.
    await storage.setBool(StorageKeys.goalsCustomized, true);
    await storage.setJsonList(StorageKeys.foodEntries, [
      FoodEntry(
        id: '1',
        name: 'Oatmeal',
        calories: 300,
        mealType: MealType.breakfast,
        loggedAt: DateTime.now(),
      ).toJson(),
    ]);

    await _pumpApp(tester, storage);

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('1500'), findsOneWidget); // 1800 − 300 kcal left
    expect(find.text('300 / 540 kcal'), findsOneWidget);

    // Tapping the meal lists what was logged.
    await _tap(tester, find.text('Breakfast'));
    expect(find.text('Oatmeal'), findsOneWidget);
  });

  testWidgets('Targets are recalculated from the saved profile on launch', (
    tester,
  ) async {
    final storage = await _storage();
    await storage.setJson(StorageKeys.userProfile, _profile().toJson());
    // Stale targets from an older version, not hand-edited.
    await storage.setJson(
      StorageKeys.userGoals,
      const UserGoals(dailyCalories: 1800).toJson(),
    );

    await _pumpApp(tester, storage);

    final expected = CalorieCalculator.calculate(_profile());
    expect(find.text('${expected.dailyCalories}'), findsOneWidget);
    expect(find.text('/ ${expected.carbs} g'), findsOneWidget);
    expect(
      storage.getJson(StorageKeys.userGoals)?['dailyCalories'],
      expected.dailyCalories,
    );
  });

  testWidgets('Account shows reset for custom goals and restores them', (
    tester,
  ) async {
    final storage = await _storage();
    await storage.setJson(StorageKeys.userProfile, _profile().toJson());
    await storage.setJson(
      StorageKeys.userGoals,
      const UserGoals(dailyCalories: 1800).toJson(),
    );
    await storage.setBool(StorageKeys.goalsCustomized, true);

    await _pumpApp(tester, storage);
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();

    final expected = CalorieCalculator.calculate(_profile());
    expect(find.text('Daily calorie goal: 1800 kcal'), findsOneWidget);
    expect(
      find.text('Custom · recommended ${expected.dailyCalories} kcal'),
      findsOneWidget,
    );

    await tester.tap(find.text('Reset to recommended'));
    await tester.pumpAndSettle();

    expect(
      find.text('Daily calorie goal: ${expected.dailyCalories} kcal'),
      findsOneWidget,
    );
    expect(find.text('Reset to recommended'), findsNothing);
    expect(storage.getBool(StorageKeys.goalsCustomized), isFalse);
  });

  testWidgets('Home shows the calorie plan calculated from storage', (
    tester,
  ) async {
    final storage = await _storage();
    await storage.setJson(StorageKeys.userProfile, _profile().toJson());

    await _pumpApp(tester, storage);
    await tester.ensureVisible(find.text('Your calorie plan'));
    await tester.pumpAndSettle();

    final b = CalorieCalculator.breakdown(_profile());
    final goals = CalorieCalculator.calculate(_profile());
    expect(find.text('Calories at rest (BMR)'), findsOneWidget);
    expect(find.text('${b.bmr} kcal'), findsOneWidget);
    expect(find.text('With activity × 1.55'), findsOneWidget);
    expect(find.text('0 kcal'), findsOneWidget); // maintain: no adjustment
    // So the target equals TDEE: both rows show the same number.
    expect(b.targetCalories, b.tdee);
    expect(find.text('${b.tdee} kcal'), findsNWidgets(2));
    expect(find.text('${goals.carbs} g'), findsOneWidget);
    expect(find.text('Your custom target'), findsNothing);
  });

  testWidgets('Calorie plan also shows a custom target from Account', (
    tester,
  ) async {
    final storage = await _storage();
    await storage.setJson(StorageKeys.userProfile, _profile().toJson());
    await storage.setJson(
      StorageKeys.userGoals,
      CalorieCalculator.macrosFor(1800).toJson(),
    );
    await storage.setBool(StorageKeys.goalsCustomized, true);

    await _pumpApp(tester, storage);
    await tester.ensureVisible(find.text('Your custom target'));
    await tester.pumpAndSettle();

    final b = CalorieCalculator.breakdown(_profile());
    expect(
      find.text('${b.targetCalories} kcal'),
      findsNWidgets(2),
    ); // TDEE + target
    expect(find.text('1800 kcal'), findsOneWidget);
    expect(find.text('225 g'), findsOneWidget); // 1800 × 50% / 4
  });

  testWidgets('Steps from the pedometer show as Walking kcal and burned', (
    tester,
  ) async {
    final steps = FakeStepCounter();
    await _pumpApp(
      tester,
      await _storage(),
      profile: _onboardedProfile(),
      steps: steps,
    );

    steps.emit(50000); // first reading of the day = baseline
    steps.emit(52000); // +2000 steps
    await tester.pumpAndSettle();

    // 2000 × 0.0005 × 70 kg = 70 kcal, counted in Burned and kcal left.
    expect(find.text('2,000 steps'), findsOneWidget);
    expect(find.text('70'), findsNWidgets(2)); // Burned + Walking
    expect(find.text('2070'), findsOneWidget);
  });

  testWidgets('Walking explains when step access is refused', (tester) async {
    await _pumpApp(
      tester,
      await _storage(),
      profile: _onboardedProfile(),
      steps: FakeStepCounter(granted: false),
    );
    expect(find.text('Allow step access'), findsOneWidget);
  });

  testWidgets('Calories-only food gets estimated macros; hint goes away', (
    tester,
  ) async {
    await _pumpApp(tester, await _storage(), profile: _onboardedProfile());
    expect(find.textContaining('Nothing logged yet today'), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('add-meal-dinner')));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Food name'),
      'Pasta',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Calories (kcal)'),
      '400',
    );
    await _tap(tester, find.text('Save'));

    expect(find.textContaining('Nothing logged yet today'), findsNothing);
    // Rings: carbs 50 g, protein 30 g, fat 9 g (8.9 rounded).
    expect(find.text('50'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);

    await _tap(tester, find.text('Dinner'));
    expect(find.textContaining('(est.)'), findsOneWidget);
  });
}
