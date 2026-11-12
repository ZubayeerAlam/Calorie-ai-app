import 'package:cal_ai_app/core/services/health_service.dart';
import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:cal_ai_app/core/utils/date_utils.dart';
import 'package:cal_ai_app/features/activity/data/activity_log_repository.dart';
import 'package:cal_ai_app/features/activity/data/step_log_repository.dart';
import 'package:cal_ai_app/features/activity/providers/activity_log_provider.dart';
import 'package:cal_ai_app/features/exercise/data/models/exercise_settings.dart';
import 'package:cal_ai_app/features/exercise/data/models/workout_record.dart';
import 'package:cal_ai_app/features/exercise/data/repositories/workout_log_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fake_health_service.dart';
import '../fake_step_counter.dart';

final _today = AppDates.today();

DateTime _at(int hour, [int minute = 0]) =>
    DateTime(_today.year, _today.month, _today.day, hour, minute);

WorkoutRecord _workout(
  String id,
  DateTime start, {
  DateTime? end,
  DateTime? updated,
  double kcal = 40,
}) => WorkoutRecord(
  id: id,
  startedAt: start,
  endedAt: end,
  updatedAt: updated ?? end,
  planId: 'p',
  sessionIndex: 0,
  environment: WorkoutEnvironment.home,
  status: end == null ? WorkoutStatus.inProgress : WorkoutStatus.completed,
  exercises: [
    ExerciseRecord(
      exerciseId: 'squat',
      setsTarget: 3,
      setsDone: 3,
      reps: 12,
      estimatedKcal: kcal,
    ),
  ],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStorageService storage;
  late WorkoutLogRepository log;
  late ChangeNotifier changes;
  late FakeHealthService health;
  late ActivityLogProvider activity;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await LocalStorageService.init();
    log = WorkoutLogRepository(storage);
    changes = ChangeNotifier();
    health = FakeHealthService();
    activity = ActivityLogProvider(
      ActivityLogRepository(storage),
      StepLogRepository(storage),
      FakeStepCounter(),
      health: health,
      workouts: log,
      workoutChanges: changes,
    );
  });

  tearDown(() => activity.dispose());

  group('HealthWorkout', () {
    final w = HealthWorkout(start: _at(18), end: _at(18, 30), kcal: 200);

    test('overlaps, with 5 minutes of leeway for clocks', () {
      expect(w.overlaps(_at(18, 10), _at(18, 20)), isTrue);
      expect(w.overlaps(_at(17, 30), _at(18, 2)), isTrue);
      expect(w.overlaps(_at(18, 33), _at(19)), isTrue); // within 5 min
      expect(w.overlaps(_at(18, 40), _at(19)), isFalse);
      expect(w.overlaps(_at(16), _at(17, 50)), isFalse);
    });

    test('round-trips through JSON', () {
      final back = HealthWorkout.fromJson(w.toJson());
      expect((back.start, back.end, back.kcal), (w.start, w.end, 200));
    });
  });

  test('Cal AI workouts count as activity', () async {
    await log.save(_workout('a', _at(7), end: _at(7, 30), kcal: 40.4));
    await log.save(_workout('b', _at(18), end: _at(18, 20), kcal: 25));
    expect(activity.appWorkoutKcalOn(_today), 65);
    await activity.setBurned(_today, 100);
    expect(activity.activityOn(_today), 165);
    expect(activity.appWorkoutKcalOn(_today.add(const Duration(days: 1))), 0);
  });

  test('a workout Health also recorded is counted once, as Health', () async {
    health.workouts[AppDates.key(_today)] = [
      HealthWorkout(start: _at(18, 2), end: _at(18, 25), kcal: 150),
    ];
    await activity.connectHealth();
    await log.save(_workout('same', _at(18), end: _at(18, 20), kcal: 60));
    await log.save(_workout('other', _at(7), end: _at(7, 30), kcal: 30));

    expect(activity.workoutKcalOn(_today), 150);
    expect(activity.appWorkoutKcalOn(_today), 30); // "same" left out
    expect(activity.activityOn(_today), 180);
  });

  test('a workout still going on uses its last saved set', () async {
    health.workouts[AppDates.key(_today)] = [
      HealthWorkout(start: _at(18, 20), end: _at(18, 50), kcal: 150),
    ];
    await activity.connectHealth();
    await log.save(_workout('going', _at(18), updated: _at(18, 10)));
    expect(activity.appWorkoutKcalOn(_today), 40); // ends 18:10: no overlap
    await log.save(_workout('going', _at(18), updated: _at(18, 22)));
    expect(activity.appWorkoutKcalOn(_today), 0);
  });

  test('without Health connected, every Cal AI workout counts', () async {
    await activity.connectHealth();
    health.workouts[AppDates.key(_today)] = [
      HealthWorkout(start: _at(18), end: _at(18, 30), kcal: 150),
    ];
    await activity.syncHealth();
    await log.save(_workout('w', _at(18), end: _at(18, 20)));
    expect(activity.appWorkoutKcalOn(_today), 0);
    await activity.disconnectHealth();
    expect(activity.appWorkoutKcalOn(_today), 40);
    expect(activity.workoutKcalOn(_today), 0);
    expect(storage.getRaw(StorageKeys.healthWorkouts), isNull);
  });

  test('Health workouts are saved with their times', () async {
    health.workouts[AppDates.key(_today)] = [
      HealthWorkout(start: _at(7), end: _at(7, 40), kcal: 120),
      HealthWorkout(start: _at(19), end: _at(19, 30), kcal: 80),
    ];
    await activity.connectHealth();
    final saved = ActivityLogRepository(storage).healthWorkoutsOn(_today);
    expect([for (final w in saved) w.kcal], [120, 80]);
    expect(saved.first.end, _at(7, 40));
    expect(activity.workoutKcalOn(_today), 200);
  });

  test('a change in workouts updates Home', () {
    var updates = 0;
    activity.addListener(() => updates++);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    changes.notifyListeners();
    expect(updates, 1);
  });

  test('active time counts only the sets done', () {
    final r = _workout('a', _at(7), end: _at(7, 30));
    // Squat: 3 sets × 12 reps × 3 s.
    expect(WorkoutLogRepository.activeSeconds(r), 108);
  });
}
