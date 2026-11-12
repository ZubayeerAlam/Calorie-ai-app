import 'package:cal_ai_app/core/services/rule_based_workout_plan_service.dart';
import 'package:cal_ai_app/features/exercise/data/catalog/exercise_catalog.dart';
import 'package:cal_ai_app/features/exercise/data/models/exercise.dart';
import 'package:cal_ai_app/features/exercise/data/models/exercise_settings.dart';
import 'package:cal_ai_app/features/exercise/data/models/workout_plan.dart';
import 'package:cal_ai_app/features/exercise/data/workout_plan_request.dart';
import 'package:cal_ai_app/features/profile/data/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

import 'plan_test_data.dart';

Future<WorkoutPlan> _plan(WorkoutPlanRequest request) =>
    const RuleBasedWorkoutPlanService().generatePlan(request);

void main() {
  test('is not AI', () {
    expect(const RuleBasedWorkoutPlanService().usesAi, isFalse);
  });

  test('a plan for every setup: right days, allowed, no repeats', () async {
    for (final environment in WorkoutEnvironment.values) {
      for (final activity in ActivityLevel.values) {
        for (final level in FitnessLevel.values) {
          for (final minutes in ExerciseSettings.sessionMinuteOptions) {
            for (final limitations in [
              <BodyLimitation>{},
              BodyLimitation.values.toSet(),
            ]) {
              final request = testRequest(
                profile: testProfile(activity: activity),
                environment: environment,
                level: level,
                minutes: minutes,
                limitations: limitations,
              );
              final plan = await _plan(request);
              final where =
                  '$environment $activity $level $minutes '
                  '$limitations';
              expect(plan.source, PlanSource.rules, reason: where);
              expect(
                plan.sessions,
                hasLength(request.sessionsPerWeek),
                reason: where,
              );
              for (final s in plan.sessions) {
                final ids = [for (final e in s.exercises) e.exerciseId];
                expect(ids.toSet(), hasLength(ids.length), reason: where);
                expect(request.allowedIds, containsAll(ids), reason: where);
                expect(ids.length, inInclusiveRange(3, 7), reason: where);
              }
            }
          }
        }
      }
    }
  });

  test('2–3 days are full body; 4 alternate upper and lower', () async {
    final three = await _plan(testRequest());
    expect(
      [for (final s in three.sessions) s.name],
      ['Full body A', 'Full body B', 'Full body C'],
    );
    // Different picks on different days.
    expect(
      three.sessions[0].exercises.map((e) => e.exerciseId).toList(),
      isNot(three.sessions[1].exercises.map((e) => e.exerciseId).toList()),
    );

    final four = await _plan(
      testRequest(profile: testProfile(activity: ActivityLevel.moderate)),
    );
    expect(
      [for (final s in four.sessions) s.name],
      ['Upper body A', 'Lower body A', 'Upper body B', 'Lower body B'],
    );
    final lower = four.sessions[1].exercises
        .map((e) => ExerciseCatalog.byId(e.exerciseId)!.pattern)
        .toSet();
    expect(lower, isNot(contains(MovementPattern.push)));
    expect(four.summary, contains('4 workouts a week'));
  });

  test('more minutes, more exercises', () async {
    int count(int minutes) => RuleBasedWorkoutPlanService.exercisesFor(minutes);
    expect(
      [
        for (final m in [15, 20, 30, 45, 60]) count(m),
      ],
      [4, 4, 5, 6, 7],
    );
    final short = await _plan(testRequest(minutes: 15));
    final long = await _plan(testRequest(minutes: 60));
    expect(
      long.sessions.first.exercises.length,
      greaterThan(short.sessions.first.exercises.length),
    );
  });

  test('sets by level; reps by goal', () async {
    PlannedExercise firstReps(WorkoutPlan plan) =>
        plan.sessions.first.exercises.firstWhere((e) => e.reps != null);

    final beginnerLose = await _plan(testRequest());
    expect(firstReps(beginnerLose).sets, 2);
    expect(firstReps(beginnerLose).reps, 12);

    final advancedLose = await _plan(testRequest(level: FitnessLevel.advanced));
    expect(firstReps(advancedLose).sets, 4);
    expect(firstReps(advancedLose).reps, 15);

    final muscle = await _plan(
      testRequest(
        profile: testProfile(
          goal: GoalType.maintain,
          focuses: [GoalFocus.gainMuscle],
        ),
        level: FitnessLevel.intermediate,
      ),
    );
    expect(firstReps(muscle).sets, 3);
    expect(firstReps(muscle).reps, 10);

    final maintain = await _plan(
      testRequest(profile: testProfile(goal: GoalType.maintain)),
    );
    expect(firstReps(maintain).reps, 12);
  });

  test('cardio machines are one longer set', () async {
    final plan = await _plan(
      testRequest(environment: WorkoutEnvironment.gym, minutes: 60),
    );
    final cardio = [
      for (final s in plan.sessions)
        for (final e in s.exercises)
          if (ExerciseCatalog.byId(e.exerciseId)! case final x
              when x.pattern == MovementPattern.cardio &&
                  x.equipment == Equipment.gym)
            e,
    ];
    expect(cardio, isNotEmpty);
    for (final e in cardio) {
      expect(e.sets, 1);
      expect(e.durationSeconds, 300);
    }
  });

  test('home equipment is used when there is some', () async {
    final plan = await _plan(
      testRequest(equipment: {HomeEquipment.dumbbells}, minutes: 60),
    );
    final equipment = {
      for (final s in plan.sessions)
        for (final e in s.exercises)
          ExerciseCatalog.byId(e.exerciseId)!.equipment,
    };
    expect(equipment, contains(Equipment.dumbbells));
  });
}
