import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:cal_ai_app/core/utils/date_utils.dart';
import 'package:cal_ai_app/features/activity/data/activity_log_repository.dart';
import 'package:cal_ai_app/features/activity/data/step_log_repository.dart';
import 'package:cal_ai_app/features/activity/providers/activity_log_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_health_service.dart';
import 'fake_step_counter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStorageService storage;
  late FakeHealthService health;
  late ActivityLogProvider activity;
  final today = AppDates.today();
  final yesterday = today.subtract(const Duration(days: 1));

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await LocalStorageService.init();
    health = FakeHealthService(
      steps: {AppDates.key(today): 6000, AppDates.key(yesterday): 9000},
      workoutKcal: {AppDates.key(yesterday): 350},
    );
    activity = ActivityLogProvider(
      ActivityLogRepository(storage),
      StepLogRepository(storage),
      FakeStepCounter(),
      health: health,
    );
  });

  tearDown(() => activity.dispose());

  test('nothing is imported until Health is connected', () async {
    await activity.syncHealth();
    expect(activity.healthConnected, isFalse);
    expect(activity.stepsOn(today), 0);
  });

  test('connecting imports steps and workout calories', () async {
    expect(await activity.connectHealth(), isTrue);
    expect(activity.healthConnected, isTrue);
    expect(activity.stepsOn(today), 6000);
    expect(activity.stepsOn(yesterday), 9000);
    expect(activity.workoutKcalOn(yesterday), 350);
    // Workouts count as activity, next to what was logged by hand.
    await activity.setBurned(yesterday, 100);
    expect(activity.activityOn(yesterday), 450);
    expect(
      activity.totalBurnedOn(yesterday, weightKg: 70),
      450 + activity.walkingOn(yesterday, weightKg: 70),
    );
  });

  test("a day's steps are the higher of the phone sensor and Health", () async {
    await StepLogRepository(storage).record(1000, DateTime.now());
    await StepLogRepository(storage).record(8000, DateTime.now()); // 7000
    await activity.connectHealth();
    expect(activity.stepsOn(today), 7000);
  });

  test('refused access leaves Health off', () async {
    health.granted = false;
    expect(await activity.connectHealth(), isFalse);
    expect(activity.healthConnected, isFalse);
    expect(activity.stepsOn(today), 0);
  });

  test('disconnecting removes the imported numbers', () async {
    await activity.connectHealth();
    await activity.disconnectHealth();
    expect(activity.healthConnected, isFalse);
    expect(activity.stepsOn(yesterday), 0);
    expect(activity.workoutKcalOn(yesterday), 0);
  });

  test('later syncs pick up new Health data', () async {
    await activity.connectHealth();
    health.steps[AppDates.key(today)] = 7500;
    await activity.syncHealth();
    expect(activity.stepsOn(today), 7500);
  });
}
