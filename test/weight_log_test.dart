import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:cal_ai_app/core/utils/calorie_calculator.dart';
import 'package:cal_ai_app/core/utils/date_utils.dart';
import 'package:cal_ai_app/features/profile/data/models/user_profile.dart';
import 'package:cal_ai_app/features/profile/providers/profile_provider.dart';
import 'package:cal_ai_app/features/tracker/data/weight_log_repository.dart';
import 'package:cal_ai_app/features/tracker/providers/weight_log_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

UserProfile _profile({double weightKg = 80}) => UserProfile(
  name: 'Sam',
  gender: Gender.male,
  birthday: DateTime(1990, 1, 1),
  heightCm: 180,
  weightKg: weightKg,
  goal: GoalType.lose,
  activityLevel: ActivityLevel.light,
  dietType: DietType.classic,
);

void main() {
  late LocalStorageService storage;
  late ProfileProvider profile;
  late WeightLogProvider weights;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await LocalStorageService.init();
    storage.setJson(StorageKeys.userProfile, _profile().toJson());
    profile = ProfileProvider(storage: storage);
    weights = WeightLogProvider(WeightLogRepository(storage), profile);
  });

  test('the profile weight is the first weigh-in', () {
    expect(weights.entries, hasLength(1));
    expect(weights.latest!.weightKg, 80);
    expect(weights.latest!.date, AppDates.today());
  });

  test("logging today's weight updates the profile and the targets", () async {
    final before = profile.goals.dailyCalories;
    await weights.logWeight(DateTime.now(), 76);

    expect(profile.profile!.weightKg, 76);
    expect(
      profile.goals.dailyCalories,
      CalorieCalculator.calculate(_profile(weightKg: 76)).dailyCalories,
    );
    expect(profile.goals.dailyCalories, lessThan(before));
    // Saved, so a relaunch keeps it.
    expect(ProfileProvider(storage: storage).profile!.weightKg, 76);
  });

  test('an older weigh-in is logged but keeps the current weight', () async {
    await weights.logWeight(
      DateTime.now().subtract(const Duration(days: 3)),
      82,
    );
    expect(weights.entries, hasLength(2));
    expect(weights.entries.first.weightKg, 82); // oldest first
    expect(profile.profile!.weightKg, 80);
  });

  test('removing the newest weigh-in falls back to the one before', () async {
    final today = AppDates.today();
    await weights.logWeight(today.subtract(const Duration(days: 1)), 81);
    await weights.logWeight(today, 79);
    expect(profile.profile!.weightKg, 79);

    await weights.remove(today);
    expect(profile.profile!.weightKg, 81);
  });

  test('custom targets stay when the weight changes', () async {
    profile.updateGoals(CalorieCalculator.macrosFor(2500));
    await weights.logWeight(DateTime.now(), 70);
    expect(profile.profile!.weightKg, 70);
    expect(profile.goals.dailyCalories, 2500);
  });
}
