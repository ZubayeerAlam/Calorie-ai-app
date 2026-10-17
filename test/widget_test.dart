import 'package:cal_ai_app/app.dart';
import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:cal_ai_app/features/food_log/data/models/food_entry.dart';
import 'package:cal_ai_app/features/profile/data/models/user_goals.dart';
import 'package:cal_ai_app/features/profile/data/models/user_profile.dart';
import 'package:cal_ai_app/features/profile/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

ProfileProvider _onboardedProfile() => ProfileProvider(profile: _profile());

/// Pumps the app on a phone-sized screen.
Future<void> _pumpApp(
  WidgetTester tester,
  LocalStorageService storage, {
  ProfileProvider? profile,
}) async {
  tester.view.physicalSize = const Size(1290, 2796);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(CalAiApp(storage: storage, profileProvider: profile));
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
}
