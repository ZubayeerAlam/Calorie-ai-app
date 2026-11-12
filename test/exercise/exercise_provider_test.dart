import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:cal_ai_app/core/services/rule_based_workout_plan_service.dart';
import 'package:cal_ai_app/core/services/workout_plan_service.dart';
import 'package:cal_ai_app/features/exercise/data/models/exercise_settings.dart';
import 'package:cal_ai_app/features/exercise/data/models/workout_plan.dart';
import 'package:cal_ai_app/features/exercise/data/models/workout_record.dart';
import 'package:cal_ai_app/features/exercise/data/repositories/exercise_settings_repository.dart';
import 'package:cal_ai_app/features/exercise/data/repositories/workout_log_repository.dart';
import 'package:cal_ai_app/features/exercise/data/repositories/workout_plan_repository.dart';
import 'package:cal_ai_app/features/exercise/providers/exercise_provider.dart';
import 'package:cal_ai_app/features/profile/data/models/user_goals.dart';
import 'package:cal_ai_app/features/profile/providers/profile_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fake_workout_plan_service.dart';
import 'plan_test_data.dart';

const _home = ExerciseSettings(
  environment: WorkoutEnvironment.home,
  level: FitnessLevel.beginner,
);

void main() {
  late LocalStorageService storage;
  late ProfileProvider profile;
  late FakeWorkoutPlanService ai;
  late WorkoutLogRepository log;
  var now = DateTime(2026, 11, 12, 9);

  ExerciseProvider provider({WorkoutPlanService? planner}) => ExerciseProvider(
    settingsRepo: ExerciseSettingsRepository(storage),
    planRepo: WorkoutPlanRepository(storage),
    log: log,
    planner: planner ?? ai,
    profile: profile,
    clock: () => now,
  );

  /// A workout of [session] on [day]: [setsDone] for each exercise (the
  /// rest none), or every set when not given.
  Future<void> addWorkout(
    WorkoutPlan plan,
    int session,
    DateTime day, {
    List<int>? setsDone,
    bool finished = true,
  }) async {
    final exercises = plan.sessions[session].exercises;
    await log.save(
      WorkoutRecord(
        id: 'w-$session-${day.toIso8601String()}',
        startedAt: day,
        planId: plan.id,
        sessionIndex: session,
        environment: plan.environment,
        status: finished ? WorkoutStatus.completed : WorkoutStatus.inProgress,
        exercises: [
          for (final (i, e) in exercises.indexed)
            ExerciseRecord(
              exerciseId: e.exerciseId,
              setsTarget: e.sets,
              setsDone: setsDone == null
                  ? e.sets
                  : setsDone.elementAtOrNull(i) ?? 0,
              reps: e.reps,
              durationSeconds: e.durationSeconds,
            ),
        ],
      ),
    );
  }

  setUp(() async {
    now = DateTime(2026, 11, 12, 9);
    SharedPreferences.setMockInitialValues({});
    storage = await LocalStorageService.init();
    await storage.setJson(StorageKeys.userProfile, testProfile().toJson());
    await storage.setJson(StorageKeys.userGoals, const UserGoals().toJson());
    profile = ProfileProvider(storage: storage);
    ai = FakeWorkoutPlanService();
    log = WorkoutLogRepository(storage);
  });

  test('not set up until Home or Gym is picked', () {
    final p = provider();
    expect(p.isSetUp, isFalse);
    expect(p.settings, isNull);
    expect(p.plan, isNull);
    expect(p.selectedSession, isNull);
    expect(p.totalExercises, 0);
  });

  test('setting up saves the choice and makes an AI plan', () async {
    ai.hold = true;
    final p = provider();
    final done = p.setUp(_home);
    await Future<void>.delayed(Duration.zero);
    expect(p.generating, isTrue);
    expect(p.isSetUp, isFalse);
    ai.release();
    await done;

    expect(p.generating, isFalse);
    expect(p.isSetUp, isTrue);
    expect(p.plan!.source, PlanSource.ai);
    expect(p.madeWithoutAi, isFalse);
    expect(p.aiFailure, isNull);
    expect(ai.lastRequest!.settings, _home);
    // Saved: a new provider (app restart) has the same.
    final again = provider();
    expect(again.settings, _home);
    expect(again.plan!.id, p.plan!.id);
    expect(ai.calls, 1);
  });

  test('when the AI fails, the rules make the plan and say so', () async {
    ai.failure = WorkoutPlanFailure.network;
    final p = provider();
    await p.setUp(_home);
    expect(p.isSetUp, isTrue);
    expect(p.plan!.source, PlanSource.rules);
    expect(p.madeWithoutAi, isTrue);
    expect(p.aiFailure, WorkoutPlanFailure.network);

    // Trying again once the AI works.
    ai.failure = null;
    await p.generate();
    expect(p.plan!.source, PlanSource.ai);
    expect(p.madeWithoutAi, isFalse);
    expect(p.aiFailure, isNull);
  });

  test('without AI in the app, a rules plan is not a problem', () async {
    final p = provider(planner: const RuleBasedWorkoutPlanService());
    await p.setUp(_home);
    expect(p.plan!.source, PlanSource.rules);
    expect(p.madeWithoutAi, isFalse);
  });

  test('the plan is outdated after a real profile or setup change', () async {
    final p = provider();
    await p.setUp(_home);
    expect(p.planOutdated, isFalse);

    profile.updateWeight(72.2); // under a kilo: no
    expect(p.planOutdated, isFalse);
    profile.updateWeight(75);
    expect(p.planOutdated, isTrue);

    await p.generate();
    expect(p.planOutdated, isFalse);
  });

  test('today\'s session follows the last workout', () async {
    final p = provider();
    await p.setUp(_home); // light activity: 3 sessions
    final plan = p.plan!;
    expect(p.todaySessionIndex, 0);

    await addWorkout(plan, 0, DateTime(2026, 11, 10, 18));
    expect(p.todaySessionIndex, 1);

    // A workout started today stays today's session, done or not.
    await addWorkout(plan, 1, DateTime(2026, 11, 12, 8), finished: false);
    expect(p.todaySessionIndex, 1);

    // Tomorrow, after finishing session 2 (the last), it wraps round.
    await addWorkout(plan, 2, DateTime(2026, 11, 12, 8, 30));
    now = DateTime(2026, 11, 13, 9);
    expect(p.todaySessionIndex, 0);
  });

  test('workouts of an older plan don\'t count', () async {
    final p = provider();
    await p.setUp(_home);
    final old = p.plan!;
    await addWorkout(old, 0, DateTime(2026, 11, 11, 18));
    await p.generate();
    expect(p.plan!.id, isNot(old.id));
    expect(p.todaySessionIndex, 0);
  });

  test('card status and progress come from today\'s workout', () async {
    final p = provider();
    await p.setUp(_home);
    final plan = p.plan!;
    final exercises = plan.sessions[0].exercises;
    expect(p.totalExercises, exercises.length);
    expect(p.completedExercises, 0);
    expect(p.statusOf(exercises[0].exerciseId), ExerciseStatus.notStarted);

    await addWorkout(
      plan,
      0,
      DateTime(2026, 11, 12, 8),
      setsDone: [exercises[0].sets, 1, 0],
      finished: false,
    );
    expect(p.statusOf(exercises[0].exerciseId), ExerciseStatus.completed);
    expect(p.statusOf(exercises[1].exerciseId), ExerciseStatus.inProgress);
    expect(p.statusOf(exercises[2].exerciseId), ExerciseStatus.notStarted);
    expect(p.completedExercises, 1);
    expect(p.remainingExercises, exercises.length - 1);

    // Another session shows its own (empty) progress.
    p.selectSession(1);
    expect(p.selectedSessionIndex, 1);
    expect(p.completedExercises, 0);
  });

  test('time and kcal estimates for the shown session', () async {
    final p = provider();
    await p.setUp(_home);
    expect(p.estimatedMinutes, inInclusiveRange(5, 45));
    expect(p.estimatedKcal, greaterThan(0));
    final first = p.selectedSession!.exercises.first;
    expect(p.plannedKcal(first), greaterThan(0));
  });

  test(
    'picking another session, then a new plan, goes back to today',
    () async {
      final p = provider();
      await p.setUp(_home);
      p.selectSession(2);
      expect(p.selectedSessionIndex, 2);
      await p.generate();
      expect(p.selectedSessionIndex, 0);
    },
  );

  test('Reset all data clears the exercise setup', () async {
    final p = provider();
    await p.setUp(_home);
    await storage.clear();
    profile.reload();
    expect(p.isSetUp, isFalse);
    expect(p.settings, isNull);
  });

  test('reload picks up data downloaded at sign-in', () async {
    final p = provider();
    expect(p.isSetUp, isFalse);
    final other = provider();
    await other.setUp(_home);
    p.reload();
    expect(p.isSetUp, isTrue);
  });
}
