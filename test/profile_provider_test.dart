import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:cal_ai_app/core/utils/calorie_calculator.dart';
import 'package:cal_ai_app/features/profile/data/models/user_profile.dart';
import 'package:cal_ai_app/features/profile/providers/profile_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

UserProfile _profile() => UserProfile(
  name: 'Sam',
  gender: Gender.male,
  birthday: DateTime(1990, 1, 1),
  heightCm: 180,
  weightKg: 80,
  goal: GoalType.lose,
  activityLevel: ActivityLevel.light,
  dietType: DietType.classic,
);

void main() {
  late LocalStorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await LocalStorageService.init();
  });

  test(
    'hand edits survive a relaunch; reset brings back the recommendation',
    () {
      final recommended = CalorieCalculator.calculate(_profile());
      ProfileProvider(storage: storage)
          .completeOnboarding(_profile(), recommended);

      // Edit on Account, then relaunch: the custom target is kept.
      ProfileProvider(storage: storage)
          .updateGoals(CalorieCalculator.macrosFor(1700));
      final relaunched = ProfileProvider(storage: storage);
      expect(relaunched.goalsCustomized, isTrue);
      expect(relaunched.goals.dailyCalories, 1700);

      // Reset, then relaunch: back on the calculated target.
      relaunched.resetGoalsToRecommended();
      final again = ProfileProvider(storage: storage);
      expect(again.goalsCustomized, isFalse);
      expect(again.goals.dailyCalories, recommended.dailyCalories);
    },
  );

  test('no saved profile leaves default goals untouched', () {
    final provider = ProfileProvider(storage: storage);
    expect(provider.isOnboarded, isFalse);
    expect(provider.goals.dailyCalories, 2000);
  });
}
