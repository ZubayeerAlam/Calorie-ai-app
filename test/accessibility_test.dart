import 'package:cal_ai_app/app.dart';
import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:cal_ai_app/core/services/rule_based_workout_plan_service.dart';
import 'package:cal_ai_app/features/exercise/data/models/exercise_settings.dart';
import 'package:cal_ai_app/features/exercise/data/workout_plan_request.dart';
import 'package:cal_ai_app/features/exercise/presentation/widgets/exercise_card.dart';
import 'package:cal_ai_app/features/food_log/data/models/food_entry.dart';
import 'package:cal_ai_app/features/profile/data/models/user_goals.dart';
import 'package:cal_ai_app/features/profile/data/models/user_profile.dart';
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

/// Flutter's accessibility guidelines on the main screens, in light and
/// dark mode: tap targets of at least 48 × 48 (Android) / 44 × 44 (iOS),
/// a label on everything tappable, and readable text contrast.
Future<void> _pumpApp(
  WidgetTester tester, {
  bool onboarded = true,
  String themeMode = 'light',
  String language = 'en',
  bool exercisePlan = false,
}) async {
  SharedPreferences.setMockInitialValues({});
  final storage = await LocalStorageService.init();
  await storage.setString(StorageKeys.themeMode, themeMode);
  await storage.setString(StorageKeys.language, language);
  if (onboarded) {
    await storage.setJson(
      StorageKeys.userProfile,
      UserProfile(
        name: 'Sam',
        gender: Gender.female,
        birthday: DateTime(1995, 6, 1),
        heightCm: 170,
        weightKg: 70,
        goal: GoalType.maintain,
        activityLevel: ActivityLevel.moderate,
        dietType: DietType.classic,
      ).toJson(),
    );
    await storage.setJson(StorageKeys.userGoals, const UserGoals().toJson());
    await storage.setJsonList(StorageKeys.foodEntries, [
      FoodEntry(
        id: '1',
        name: 'Oatmeal',
        calories: 300,
        protein: 10,
        carbs: 50,
        fat: 6,
        mealType: MealType.breakfast,
        loggedAt: DateTime.now(),
      ).toJson(),
    ]);
  }
  if (exercisePlan) {
    const settings = ExerciseSettings(
      environment: WorkoutEnvironment.home,
      level: FitnessLevel.beginner,
    );
    await storage.setJson(StorageKeys.exerciseSettings, settings.toJson());
    final profile = UserProfile.fromJson(
      storage.getJson(StorageKeys.userProfile)!,
    );
    await storage.setJson(
      StorageKeys.workoutPlan,
      RuleBasedWorkoutPlanService.build(
        WorkoutPlanRequest(profile: profile, settings: settings),
      ).toJson(),
    );
  }
  tester.view.physicalSize = const Size(1290, 2796);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    CalAiApp(
      storage: storage,
      stepCounter: FakeStepCounter(),
      imagePicker: FakeImagePicker(),
      foodAnalysis: FakeFoodAnalysisService(),
      health: FakeHealthService(),
      auth: FakeAuthService(),
      cloudStore: FakeCloudStore(),
      notifications: FakeNotificationService(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _checkGuidelines(WidgetTester tester, String screen) async {
  final handle = tester.ensureSemantics();
  for (final (name, guideline) in [
    ('Android tap targets', androidTapTargetGuideline),
    ('iOS tap targets', iOSTapTargetGuideline),
    ('labelled tap targets', labeledTapTargetGuideline),
    ('text contrast', textContrastGuideline),
  ]) {
    final result = await guideline.evaluate(tester);
    expect(result.passed, isTrue, reason: '$screen – $name:\n${result.reason}');
  }
  handle.dispose();
}

/// "Reduce motion" on: exercise demos show still poses, so screens settle.
void _reduceMotion(WidgetTester tester) {
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
}

Future<void> _open(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  for (final (mode, language) in [
    ('light', 'en'),
    ('dark', 'en'),
    ('light', 'bn'),
  ]) {
    group('$mode mode, $language', () {
      testWidgets('Home', (tester) async {
        await _pumpApp(tester, themeMode: mode, language: language);
        await _checkGuidelines(tester, 'Home');
      });

      testWidgets('Tracker', (tester) async {
        await _pumpApp(tester, themeMode: mode, language: language);
        await _open(tester, find.byIcon(Icons.grid_view_outlined));
        await _checkGuidelines(tester, 'Tracker');
      });

      testWidgets('Exercise', (tester) async {
        await _pumpApp(tester, themeMode: mode, language: language);
        await _open(tester, find.byIcon(Icons.fitness_center_outlined));
        await _checkGuidelines(tester, 'Exercise');
      });

      testWidgets('Exercise plan', (tester) async {
        await _pumpApp(
          tester,
          themeMode: mode,
          language: language,
          exercisePlan: true,
        );
        await _open(tester, find.byIcon(Icons.fitness_center_outlined));
        await _checkGuidelines(tester, 'Exercise plan');
      });

      testWidgets('Exercise details', (tester) async {
        _reduceMotion(tester);
        await _pumpApp(
          tester,
          themeMode: mode,
          language: language,
          exercisePlan: true,
        );
        await _open(tester, find.byIcon(Icons.fitness_center_outlined));
        await _open(tester, find.byType(ExerciseCard).first);
        await _checkGuidelines(tester, 'Exercise details');
      });

      testWidgets('Workout mode', (tester) async {
        _reduceMotion(tester);
        await _pumpApp(
          tester,
          themeMode: mode,
          language: language,
          exercisePlan: true,
        );
        await _open(tester, find.byIcon(Icons.fitness_center_outlined));
        await _open(tester, find.byType(ExerciseCard).first);
        await _checkGuidelines(tester, 'Exercise details (start button)');
        await _open(tester, find.byKey(const ValueKey('start-workout')));
        await _checkGuidelines(tester, 'Workout: ready');
        await _open(tester, find.byKey(const ValueKey('start-sets')));
        await _checkGuidelines(tester, 'Workout: set');
        await _open(tester, find.byKey(const ValueKey('finish-set')));
        await _checkGuidelines(tester, 'Workout: rest');
        await _open(tester, find.byKey(const ValueKey('complete-exercise')));
        await _checkGuidelines(tester, 'Workout: done');
      });

      testWidgets('Workout setup', (tester) async {
        await _pumpApp(
          tester,
          themeMode: mode,
          language: language,
          exercisePlan: true,
        );
        await _open(tester, find.byIcon(Icons.fitness_center_outlined));
        await _open(tester, find.byKey(const ValueKey('workout-setup')));
        await _open(tester, find.byKey(const ValueKey('setup-extras')));
        await _checkGuidelines(tester, 'Workout setup');
      });

      testWidgets('Account', (tester) async {
        await _pumpApp(tester, themeMode: mode, language: language);
        await _open(tester, find.byIcon(Icons.person_outline_rounded));
        await _checkGuidelines(tester, 'Account');
      });

      testWidgets('Edit profile', (tester) async {
        await _pumpApp(tester, themeMode: mode, language: language);
        await _open(tester, find.byIcon(Icons.person_outline_rounded));
        await _open(tester, find.byKey(const ValueKey('edit-profile')));
        await _checkGuidelines(tester, 'Edit profile');
      });

      testWidgets('Sign in', (tester) async {
        await _pumpApp(tester, themeMode: mode, language: language);
        await _open(tester, find.byIcon(Icons.person_outline_rounded));
        await _open(tester, find.byKey(const ValueKey('open-sign-in')));
        await _checkGuidelines(tester, 'Sign in');
      });

      testWidgets('Reminders', (tester) async {
        await _pumpApp(tester, themeMode: mode, language: language);
        await _open(tester, find.byKey(const ValueKey('notifications')));
        await _checkGuidelines(tester, 'Reminders');
      });

      testWidgets('Add manually', (tester) async {
        await _pumpApp(tester, themeMode: mode, language: language);
        await _open(tester, find.byKey(const ValueKey('camera-button')));
        await _open(tester, find.byIcon(Icons.edit_note_rounded));
        await _checkGuidelines(tester, 'Add manually');
      });

      testWidgets('Onboarding', (tester) async {
        await _pumpApp(
          tester,
          onboarded: false,
          themeMode: mode,
          language: language,
        );
        await _checkGuidelines(tester, 'Onboarding');
      });
    });
  }

  // Large text (Settings → Display → Font size) must not break layouts:
  // an overflow fails the test.
  // Text follows the phone up to ×1.3 (AppConstants.maxTextScale).
  for (final (scale, language) in [(1.3, 'en'), (2.0, 'en'), (1.3, 'bn')]) {
    testWidgets(
      'large text ×$scale, $language: Home, Tracker and Account fit',
      (tester) async {
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await _pumpApp(tester, language: language);
        await _open(tester, find.byIcon(Icons.grid_view_outlined));
        await _open(tester, find.byIcon(Icons.person_outline_rounded));
        await _open(tester, find.byIcon(Icons.home_outlined));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('large text ×$scale, $language: other screens fit', (
      tester,
    ) async {
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await _pumpApp(tester, language: language);
      // By type: `pageBack` looks for the English "Back" tooltip.
      Future<void> back() async {
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
      }

      // Each screen is checked as it opens, so a failure names it.
      void fits(String screen) =>
          expect(tester.takeException(), isNull, reason: screen);

      await _open(tester, find.byKey(const ValueKey('notifications')));
      fits('Reminders');
      await back();
      await _open(tester, find.byIcon(Icons.person_outline_rounded));
      await _open(tester, find.byKey(const ValueKey('edit-profile')));
      fits('Edit profile');
      await back();
      await _open(tester, find.byKey(const ValueKey('open-sign-in')));
      fits('Sign in');
      await back();
      await _open(tester, find.byKey(const ValueKey('camera-button')));
      fits('Camera chooser');
      await _open(tester, find.byIcon(Icons.edit_note_rounded));
      fits('Add manually');
    });

    testWidgets('large text ×$scale, $language: Exercise fits', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await _pumpApp(tester, language: language, exercisePlan: true);
      await _open(tester, find.byIcon(Icons.fitness_center_outlined));
      expect(tester.takeException(), isNull, reason: 'Exercise plan');
      await _open(tester, find.byKey(const ValueKey('session-2')));
      expect(tester.takeException(), isNull, reason: 'Another session');
      await _open(tester, find.byKey(const ValueKey('workout-setup')));
      await _open(tester, find.byKey(const ValueKey('setup-extras')));
      expect(tester.takeException(), isNull, reason: 'Workout setup');
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      _reduceMotion(tester);
      await tester.pumpAndSettle();
      await _open(tester, find.byType(ExerciseCard).first);
      expect(tester.takeException(), isNull, reason: 'Exercise details');
      await _open(tester, find.byKey(const ValueKey('start-workout')));
      await _open(tester, find.byKey(const ValueKey('start-sets')));
      expect(tester.takeException(), isNull, reason: 'Workout: set');
      await _open(tester, find.byKey(const ValueKey('finish-set')));
      expect(tester.takeException(), isNull, reason: 'Workout: rest');
      await _open(tester, find.byKey(const ValueKey('complete-exercise')));
      expect(tester.takeException(), isNull, reason: 'Workout: done');
    });

    testWidgets('large text ×$scale, $language: onboarding fits', (
      tester,
    ) async {
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await _pumpApp(tester, onboarded: false, language: language);
      expect(tester.takeException(), isNull);
    });
  }
}
