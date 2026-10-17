import 'package:cal_ai_app/app.dart';
import 'package:cal_ai_app/features/profile/data/models/user_profile.dart';
import 'package:cal_ai_app/features/profile/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// An already-onboarded profile, so the router starts on the dashboard.
ProfileProvider _onboardedProfile() => ProfileProvider(
  profile: UserProfile(
    name: 'Sam',
    gender: Gender.female,
    birthday: DateTime(1995, 6, 1),
    heightCm: 170,
    weightKg: 70,
    goal: GoalType.maintain,
    activityLevel: ActivityLevel.moderate,
    dietType: DietType.classic,
  ),
);

void main() {
  testWidgets('Dashboard shows calorie summary and empty log', (tester) async {
    await tester.pumpWidget(CalAiApp(profileProvider: _onboardedProfile()));
    await tester.pumpAndSettle();

    expect(find.text('2000 kcal left'), findsOneWidget);
    expect(find.text('No meals logged today'), findsOneWidget);
  });

  testWidgets('Bottom navigation switches to Scan tab', (tester) async {
    await tester.pumpWidget(CalAiApp(profileProvider: _onboardedProfile()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Scan'));
    await tester.pumpAndSettle();

    expect(find.text('Scan Food'), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
  });

  testWidgets('Add button pushes Add Food and back returns', (tester) async {
    await tester.pumpWidget(CalAiApp(profileProvider: _onboardedProfile()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Add Food'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('No meals logged today'), findsOneWidget);
  });

  testWidgets('A new user is redirected to onboarding', (tester) async {
    await tester.pumpWidget(const CalAiApp());
    await tester.pumpAndSettle();

    expect(find.text("What's your name?"), findsOneWidget);
    expect(find.text('Home'), findsNothing);
  });
}
