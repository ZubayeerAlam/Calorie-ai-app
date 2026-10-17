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

void main() {
  testWidgets('Dashboard shows calorie summary and empty log', (tester) async {
    final storage = await _storage();
    await tester.pumpWidget(
      CalAiApp(storage: storage, profileProvider: _onboardedProfile()),
    );
    await tester.pumpAndSettle();

    expect(find.text('2000 kcal left'), findsOneWidget);
    expect(find.text('No meals logged today'), findsOneWidget);
  });

  testWidgets('Bottom navigation switches to Scan tab', (tester) async {
    final storage = await _storage();
    await tester.pumpWidget(
      CalAiApp(storage: storage, profileProvider: _onboardedProfile()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Scan'));
    await tester.pumpAndSettle();

    expect(find.text('Scan Food'), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
  });

  testWidgets('Add button pushes Add Food and back returns', (tester) async {
    final storage = await _storage();
    await tester.pumpWidget(
      CalAiApp(storage: storage, profileProvider: _onboardedProfile()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Add Food'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('No meals logged today'), findsOneWidget);
  });

  testWidgets('A new user is redirected to onboarding', (tester) async {
    await tester.pumpWidget(CalAiApp(storage: await _storage()));
    await tester.pumpAndSettle();

    expect(find.text("What's your name?"), findsOneWidget);
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('Unreadable saved profile falls back to onboarding', (
    tester,
  ) async {
    final storage = await _storage();
    await storage.setString(StorageKeys.userProfile, '{"name": 42}');

    await tester.pumpWidget(CalAiApp(storage: storage));
    await tester.pumpAndSettle();

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

    await tester.pumpWidget(CalAiApp(storage: storage));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('1500 kcal left'), findsOneWidget);
    expect(find.text('Oatmeal'), findsOneWidget);
  });
}
