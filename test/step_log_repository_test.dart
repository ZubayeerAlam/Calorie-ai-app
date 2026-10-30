import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:cal_ai_app/features/activity/data/step_log_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late StepLogRepository repo;
  final day1 = DateTime(2026, 10, 18, 9);
  final day2 = DateTime(2026, 10, 19, 9);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repo = StepLogRepository(await LocalStorageService.init());
  });

  test('counts from the first reading of the day', () async {
    expect(await repo.record(50000, day1), 0);
    expect(await repo.record(52500, day1), 2500);
    expect(repo.stepsOn(day1), 2500);
  });

  test('a new day starts again from zero and keeps yesterday', () async {
    await repo.record(50000, day1);
    await repo.record(51000, day1);
    expect(await repo.record(51200, day2), 0);
    expect(await repo.record(51700, day2), 500);
    expect(repo.stepsOn(day1), 1000);
  });

  test('a phone restart (total resets) keeps today\'s count', () async {
    await repo.record(50000, day1);
    await repo.record(53000, day1); // 3000 today
    expect(await repo.record(100, day1), 3000); // rebooted
    expect(await repo.record(600, day1), 3500);
  });
}
