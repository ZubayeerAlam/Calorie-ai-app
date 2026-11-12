import 'package:cal_ai_app/features/exercise/data/models/exercise_settings.dart';
import 'package:cal_ai_app/features/exercise/data/models/workout_plan.dart';
import 'package:cal_ai_app/features/exercise/data/models/workout_record.dart';
import 'package:cal_ai_app/features/profile/data/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

WorkoutPlan plan() => WorkoutPlan(
  id: 'p1',
  environment: WorkoutEnvironment.home,
  createdAt: DateTime(2026, 11, 12, 9),
  source: PlanSource.ai,
  summary: 'Three full-body sessions',
  inputsKey: 'abc',
  sessions: const [
    PlannedSession(
      name: 'Day A',
      focus: 'Upper body',
      exercises: [
        PlannedExercise(
          exerciseId: 'push_up',
          sets: 3,
          reps: 10,
          restSeconds: 60,
          why: 'Builds strength',
        ),
        PlannedExercise(
          exerciseId: 'plank',
          sets: 3,
          durationSeconds: 30,
          restSeconds: 45,
        ),
      ],
    ),
  ],
);

void main() {
  group('ExerciseSettings', () {
    test('defaults: level from activity, 30 minutes, nothing extra', () {
      final s = ExerciseSettings.defaultsFor(
        WorkoutEnvironment.gym,
        ActivityLevel.moderate,
      );
      expect(s.environment, WorkoutEnvironment.gym);
      expect(s.level, FitnessLevel.intermediate);
      expect(s.sessionMinutes, 30);
      expect(s.homeEquipment, isEmpty);
      expect(s.limitations, isEmpty);
      expect(
        ExerciseSettings.levelFor(ActivityLevel.sedentary),
        FitnessLevel.beginner,
      );
      expect(
        ExerciseSettings.levelFor(ActivityLevel.active),
        FitnessLevel.advanced,
      );
    });

    test('sessions per week follow the activity level', () {
      expect(
        [
          for (final a in ActivityLevel.values)
            ExerciseSettings.sessionsPerWeek(a),
        ],
        [2, 3, 4, 5],
      );
    });

    test('round-trips through JSON and compares by value', () {
      const s = ExerciseSettings(
        environment: WorkoutEnvironment.home,
        level: FitnessLevel.advanced,
        sessionMinutes: 45,
        homeEquipment: {HomeEquipment.dumbbells},
        limitations: {BodyLimitation.knees, BodyLimitation.wrists},
      );
      final back = ExerciseSettings.fromJson(s.toJson());
      expect(back, s);
      expect(back.hashCode, s.hashCode);
      expect(back == s.copyWith(sessionMinutes: 20), isFalse);
    });

    test('older or newer saved data still loads', () {
      final s = ExerciseSettings.fromJson({
        'environment': 'home',
        'level': 'beginner',
        'limitations': ['knees', 'elbows'],
      });
      expect(s.sessionMinutes, 30);
      expect(s.homeEquipment, isEmpty);
      expect(s.limitations, {BodyLimitation.knees});
    });
  });

  test('WorkoutPlan round-trips through JSON', () {
    final back = WorkoutPlan.fromJson(plan().toJson());
    expect(back.id, 'p1');
    expect(back.source, PlanSource.ai);
    expect(back.createdAt, DateTime(2026, 11, 12, 9));
    expect(back.inputsKey, 'abc');
    final [session] = back.sessions;
    expect(session.focus, 'Upper body');
    expect(session.exercises[0].reps, 10);
    expect(session.exercises[0].durationSeconds, isNull);
    expect(session.exercises[0].why, 'Builds strength');
    expect(session.exercises[1].durationSeconds, 30);
    expect(session.exercises[1].reps, isNull);
    expect(session.exercises[1].why, '');
  });

  group('WorkoutRecord', () {
    WorkoutRecord record() => WorkoutRecord(
      id: 'w1',
      startedAt: DateTime(2026, 11, 12, 18, 30),
      planId: 'p1',
      sessionIndex: 0,
      environment: WorkoutEnvironment.home,
      exercises: const [
        ExerciseRecord(
          exerciseId: 'push_up',
          setsTarget: 3,
          setsDone: 3,
          reps: 10,
          estimatedKcal: 5.5,
        ),
        ExerciseRecord(
          exerciseId: 'plank',
          setsTarget: 3,
          setsDone: 1,
          durationSeconds: 30,
          estimatedKcal: 1.2,
        ),
        ExerciseRecord(exerciseId: 'squat', setsTarget: 3, reps: 12),
      ],
    );

    test('exercise status comes from the sets done', () {
      expect(
        [for (final e in record().exercises) e.status],
        [
          ExerciseStatus.completed,
          ExerciseStatus.inProgress,
          ExerciseStatus.notStarted,
        ],
      );
    });

    test('totals, day and status', () {
      final r = record();
      expect(r.estimatedKcal, closeTo(6.7, 0.001));
      expect(r.completedExercises, 1);
      expect(r.date, DateTime(2026, 11, 12));
      expect(r.isFinished, isFalse);
      expect(r.copyWith(status: WorkoutStatus.partial).isFinished, isTrue);
    });

    test('round-trips through JSON', () {
      final ended = record().copyWith(
        status: WorkoutStatus.completed,
        endedAt: DateTime(2026, 11, 12, 19),
      );
      final back = WorkoutRecord.fromJson(ended.toJson());
      expect(back.status, WorkoutStatus.completed);
      expect(back.endedAt, DateTime(2026, 11, 12, 19));
      expect(back.exercises[1].durationSeconds, 30);
      expect(back.exercises[2].setsDone, 0);
      expect(back.estimatedKcal, closeTo(6.7, 0.001));
      expect(WorkoutRecord.fromJson(record().toJson()).endedAt, isNull);
    });
  });
}
