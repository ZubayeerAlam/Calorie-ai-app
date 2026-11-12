import 'package:cal_ai_app/app.dart';
import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:cal_ai_app/core/services/rule_based_workout_plan_service.dart';
import 'package:cal_ai_app/core/services/workout_plan_service.dart';
import 'package:cal_ai_app/features/exercise/data/models/exercise_settings.dart';
import 'package:cal_ai_app/features/exercise/data/models/workout_plan.dart';
import 'package:cal_ai_app/features/exercise/data/models/workout_record.dart';
import 'package:cal_ai_app/features/exercise/data/workout_plan_request.dart';
import 'package:cal_ai_app/features/profile/data/models/user_goals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fake_food_analysis_service.dart';
import '../fake_image_picker.dart';
import '../fake_step_counter.dart';
import '../fake_workout_plan_service.dart';
import 'plan_test_data.dart';

const _home = ExerciseSettings(
  environment: WorkoutEnvironment.home,
  level: FitnessLevel.beginner,
);

/// Storage with a profile; with [settings], also a saved plan for them
/// (its fingerprint set to [inputsKey] when given) and [records].
Future<(LocalStorageService, WorkoutPlan?)> _storage({
  ExerciseSettings? settings,
  String? inputsKey,
  String? language,
  List<WorkoutRecord> Function(WorkoutPlan plan)? records,
}) async {
  SharedPreferences.setMockInitialValues({});
  final storage = await LocalStorageService.init();
  final profile = testProfile();
  await storage.setJson(StorageKeys.userProfile, profile.toJson());
  await storage.setJson(StorageKeys.userGoals, const UserGoals().toJson());
  if (language != null) await storage.setString(StorageKeys.language, language);
  WorkoutPlan? plan;
  if (settings != null) {
    await storage.setJson(StorageKeys.exerciseSettings, settings.toJson());
    plan = RuleBasedWorkoutPlanService.build(
      WorkoutPlanRequest(profile: profile, settings: settings),
    );
    final json = plan.toJson()
      ..['source'] = PlanSource.ai.name
      ..['summary'] = 'Saved AI plan';
    if (inputsKey != null) json['inputsKey'] = inputsKey;
    plan = WorkoutPlan.fromJson(json);
    await storage.setJson(StorageKeys.workoutPlan, plan.toJson());
    await storage.setJsonList(StorageKeys.workoutSessions, [
      for (final r in records?.call(plan) ?? const <WorkoutRecord>[])
        r.toJson(),
    ]);
  }
  return (storage, plan);
}

Future<void> _pumpApp(
  WidgetTester tester,
  LocalStorageService storage, {
  WorkoutPlanService? planner,
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
      workoutPlans: planner ?? FakeWorkoutPlanService(),
    ),
  );
  await tester.pumpAndSettle();
}

/// Scrolls [finder] into view (lists build lazily), then taps it.
Future<void> _tap(
  WidgetTester tester,
  Finder finder, {
  bool settle = true,
}) async {
  await tester.scrollUntilVisible(
    finder,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.tap(finder);
  settle ? await tester.pumpAndSettle() : await tester.pump();
}

/// Lists keep their scroll position; go back up to see the top.
Future<void> _scrollToTop(WidgetTester tester) async {
  await tester.drag(find.byType(Scrollable).first, const Offset(0, 2000));
  await tester.pumpAndSettle();
}

Future<void> _tapNav(WidgetTester tester, String label) async {
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Future<void> _openExercise(WidgetTester tester) => _tapNav(tester, 'Exercise');

Finder _cards() => find.byWidgetPredicate(
  (w) =>
      w.key is ValueKey<String> &&
      (w.key! as ValueKey<String>).value.startsWith('exercise-'),
);

void main() {
  testWidgets('first visit: pick Home, customise, and get a plan', (
    tester,
  ) async {
    final ai = FakeWorkoutPlanService(hold: true);
    final (storage, _) = await _storage();
    await _pumpApp(tester, storage, planner: ai);
    await _openExercise(tester);

    expect(find.text('Where do you work out?'), findsOneWidget);
    expect(find.text('Home workout'), findsOneWidget);
    expect(find.text('Gym workout'), findsOneWidget);
    expect(find.textContaining('not medical advice'), findsOneWidget);
    // Nothing picked yet: the button is off.
    final create = find.byKey(const ValueKey('create-plan'));
    expect(tester.widget<ElevatedButton>(create).onPressed, isNull);

    await _tap(tester, find.byKey(const ValueKey('env-home')));
    await _tap(tester, find.text('Customise (optional)'));
    expect(find.text('Beginner'), findsOneWidget); // from light activity
    await _tap(tester, find.text('45 min'));
    await _tap(tester, find.text('Dumbbells'));
    await _tap(tester, find.text('Knees'));

    await _tap(tester, create, settle: false);
    await tester.pump();
    expect(find.text('Creating your plan…'), findsOneWidget);
    ai.release();
    await tester.pumpAndSettle();

    final settings = ai.lastRequest!.settings;
    expect(settings.environment, WorkoutEnvironment.home);
    expect(settings.sessionMinutes, 45);
    expect(settings.homeEquipment, {HomeEquipment.dumbbells});
    expect(settings.limitations, {BodyLimitation.knees});

    expect(find.text("Today's workout"), findsOneWidget);
    expect(find.text('AI plan'), findsOneWidget);
    final session = RuleBasedWorkoutPlanService.build(ai.lastRequest!)
        .sessions
        .first;
    expect(
      find.textContaining('0 of ${session.exercises.length} done'),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.byKey(ValueKey('exercise-${session.exercises.last.exerciseId}')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(_cards(), findsNWidgets(session.exercises.length));
    expect(find.text('Not started'), findsWidgets);
  });

  testWidgets('the gym hides home equipment', (tester) async {
    final (storage, _) = await _storage();
    await _pumpApp(tester, storage);
    await _openExercise(tester);
    await _tap(tester, find.byKey(const ValueKey('env-gym')));
    await _tap(tester, find.text('Customise (optional)'));
    expect(find.text('Dumbbells'), findsNothing);
    await _tap(tester, find.byKey(const ValueKey('create-plan')));
    expect(find.text("Today's workout"), findsOneWidget);
  });

  testWidgets('without the AI: a plan anyway, and a way to retry', (
    tester,
  ) async {
    final ai = FakeWorkoutPlanService(failure: WorkoutPlanFailure.network);
    final (storage, _) = await _storage();
    await _pumpApp(tester, storage, planner: ai);
    await _openExercise(tester);
    await _tap(tester, find.byKey(const ValueKey('env-home')));
    await _tap(tester, find.byKey(const ValueKey('create-plan')));

    expect(find.byKey(const ValueKey('notice-offline')), findsOneWidget);
    expect(find.textContaining('made on your phone'), findsOneWidget);
    expect(_cards(), findsWidgets);

    ai.failure = null;
    await _tap(tester, find.text('Try AI again'));
    expect(find.byKey(const ValueKey('notice-offline')), findsNothing);
    await _scrollToTop(tester);
    expect(find.text('AI plan'), findsOneWidget);
  });

  testWidgets('returning users see their plan and each card\'s status', (
    tester,
  ) async {
    final (storage, plan) = await _storage(
      settings: _home,
      records: (plan) {
        final exercises = plan.sessions[0].exercises;
        return [
          WorkoutRecord(
            id: 'w1',
            startedAt: DateTime.now(),
            planId: plan.id,
            sessionIndex: 0,
            environment: WorkoutEnvironment.home,
            exercises: [
              for (final (i, e) in exercises.indexed)
                ExerciseRecord(
                  exerciseId: e.exerciseId,
                  setsTarget: e.sets,
                  setsDone: switch (i) {
                    0 => e.sets,
                    1 => 1,
                    _ => 0,
                  },
                  reps: e.reps,
                  durationSeconds: e.durationSeconds,
                ),
            ],
          ),
        ];
      },
    );
    await _pumpApp(tester, storage);
    await _openExercise(tester);

    final total = plan!.sessions[0].exercises.length;
    expect(find.text('Where do you work out?'), findsNothing);
    expect(find.text('Saved AI plan'), findsOneWidget);
    expect(find.textContaining('1 of $total done'), findsOneWidget);
    expect(find.text('Done'), findsWidgets); // stat label and badge
    expect(find.text('In progress'), findsOneWidget);
    // One label per card, read as a whole.
    Finder labelled(String end) => find.byWidgetPredicate(
      (w) =>
          w is Semantics &&
          (w.properties.label?.endsWith(end) ?? false) &&
          w.properties.label!.contains('kcal'),
    );
    expect(labelled(', Done'), findsOneWidget);
    expect(labelled(', In progress'), findsOneWidget);
    expect(labelled(', Not started'), findsWidgets);
  });

  testWidgets('switching sessions shows another day\'s exercises', (
    tester,
  ) async {
    final (storage, plan) = await _storage(settings: _home);
    await _pumpApp(tester, storage);
    await _openExercise(tester);
    expect(find.text('Full body A · Today'), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('session-1')));
    expect(find.text("Today's workout"), findsNothing);
    expect(find.text('Full body B'), findsWidgets);
    final second = plan!.sessions[1].exercises.first.exerciseId;
    expect(find.byKey(ValueKey('exercise-$second')), findsOneWidget);
  });

  testWidgets('a changed profile offers to update the plan', (tester) async {
    final ai = FakeWorkoutPlanService();
    final (storage, _) = await _storage(settings: _home, inputsKey: 'old');
    await _pumpApp(tester, storage, planner: ai);
    await _openExercise(tester);
    expect(find.byKey(const ValueKey('notice-outdated')), findsOneWidget);

    await _tap(tester, find.text('Update plan'));
    expect(ai.calls, 1);
    expect(find.byKey(const ValueKey('notice-outdated')), findsNothing);
  });

  testWidgets('Make a new plan asks first', (tester) async {
    final ai = FakeWorkoutPlanService();
    final (storage, _) = await _storage(settings: _home);
    await _pumpApp(tester, storage, planner: ai);
    await _openExercise(tester);

    await _tap(tester, find.byKey(const ValueKey('regenerate-plan')));
    expect(find.text('Make a new plan?'), findsOneWidget);
    await _tap(tester, find.text('Cancel'));
    expect(ai.calls, 0);

    await _tap(tester, find.byKey(const ValueKey('regenerate-plan')));
    await _tap(tester, find.byKey(const ValueKey('confirm-regenerate')));
    expect(ai.calls, 1);
    expect(find.text('AI plan'), findsOneWidget);
  });

  testWidgets('Workout setup switches Home to Gym', (tester) async {
    final ai = FakeWorkoutPlanService();
    final (storage, _) = await _storage(settings: _home);
    await _pumpApp(tester, storage, planner: ai);
    await _openExercise(tester);

    await _tap(tester, find.byKey(const ValueKey('workout-setup')));
    expect(find.text('Workout setup'), findsOneWidget);
    expect(find.text('Update my plan'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('env-gym')));
    await _tap(tester, find.byKey(const ValueKey('create-plan')));

    expect(find.text('Workout setup'), findsNothing);
    expect(ai.lastRequest!.settings.environment, WorkoutEnvironment.gym);
    expect(find.text('AI plan'), findsOneWidget);
  });

  testWidgets('Bangla', (tester) async {
    final (storage, _) = await _storage(language: 'bn');
    await _pumpApp(tester, storage);
    await _tapNav(tester, 'ব্যায়াম');
    expect(find.text('আপনি কোথায় ব্যায়াম করেন?'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('env-home')));
    await _tap(tester, find.byKey(const ValueKey('create-plan')));
    expect(find.text('আজকের ওয়ার্কআউট'), findsOneWidget);
    expect(find.text('পুরো শরীর A · আজ'), findsOneWidget);
  });
}
