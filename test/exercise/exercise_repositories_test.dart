import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:cal_ai_app/features/exercise/data/models/exercise_settings.dart';
import 'package:cal_ai_app/features/exercise/data/models/workout_plan.dart';
import 'package:cal_ai_app/features/exercise/data/models/workout_record.dart';
import 'package:cal_ai_app/features/exercise/data/repositories/exercise_settings_repository.dart';
import 'package:cal_ai_app/features/exercise/data/repositories/workout_log_repository.dart';
import 'package:cal_ai_app/features/exercise/data/repositories/workout_plan_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

WorkoutRecord _record(String id, DateTime startedAt, {double kcal = 10}) =>
    WorkoutRecord(
      id: id,
      startedAt: startedAt,
      planId: 'p1',
      sessionIndex: 0,
      environment: WorkoutEnvironment.home,
      exercises: [
        ExerciseRecord(
          exerciseId: 'squat',
          setsTarget: 3,
          setsDone: 1,
          reps: 12,
          estimatedKcal: kcal,
        ),
      ],
    );

void main() {
  late LocalStorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await LocalStorageService.init();
  });

  group('ExerciseSettingsRepository', () {
    test('null until set up, then saved', () async {
      final repo = ExerciseSettingsRepository(storage);
      expect(repo.read(), isNull);
      const settings = ExerciseSettings(
        environment: WorkoutEnvironment.gym,
        level: FitnessLevel.beginner,
      );
      await repo.save(settings);
      expect(ExerciseSettingsRepository(storage).read(), settings);
    });

    test('unreadable data is dropped instead of crashing', () async {
      await storage.setString(StorageKeys.exerciseSettings, '{"level": 3}');
      expect(ExerciseSettingsRepository(storage).read(), isNull);
      expect(storage.getRaw(StorageKeys.exerciseSettings), isNull);
    });
  });

  test('WorkoutPlanRepository saves, replaces and clears the plan', () async {
    final repo = WorkoutPlanRepository(storage);
    expect(repo.read(), isNull);
    WorkoutPlan plan(String id) => WorkoutPlan(
      id: id,
      environment: WorkoutEnvironment.home,
      createdAt: DateTime(2026, 11, 12),
      source: PlanSource.rules,
      sessions: const [],
    );
    await repo.save(plan('a'));
    await repo.save(plan('b'));
    expect(repo.read()!.id, 'b');
    await repo.clear();
    expect(repo.read(), isNull);
  });

  group('WorkoutLogRepository', () {
    test('saves by id, sorted by start time', () async {
      final repo = WorkoutLogRepository(storage);
      await repo.save(_record('late', DateTime(2026, 11, 12, 19)));
      await repo.save(_record('early', DateTime(2026, 11, 12, 7)));
      expect([for (final r in repo.all()) r.id], ['early', 'late']);

      // Saving again updates instead of adding.
      await repo.save(_record('late', DateTime(2026, 11, 12, 19), kcal: 25));
      expect(repo.all(), hasLength(2));
      expect(repo.byId('late')!.estimatedKcal, 25);
      expect(repo.byId('missing'), isNull);
    });

    test('per-day lists and kcal', () async {
      final repo = WorkoutLogRepository(storage);
      await repo.save(_record('a', DateTime(2026, 11, 12, 7), kcal: 12));
      await repo.save(_record('b', DateTime(2026, 11, 12, 19), kcal: 8.5));
      await repo.save(_record('c', DateTime(2026, 11, 11, 19), kcal: 30));
      expect(repo.on(DateTime(2026, 11, 12)), hasLength(2));
      expect(repo.kcalOn(DateTime(2026, 11, 12)), closeTo(20.5, 0.001));
      expect(repo.kcalOn(DateTime(2026, 11, 10)), 0);

      await repo.remove('a');
      expect(repo.kcalOn(DateTime(2026, 11, 12)), closeTo(8.5, 0.001));
    });

    test('unreadable history gives an empty list', () async {
      await storage.setString(StorageKeys.workoutSessions, '[{"id": 1}]');
      expect(WorkoutLogRepository(storage).all(), isEmpty);
    });
  });
}
