import 'package:cal_ai_app/core/utils/calorie_calculator.dart';
import 'package:cal_ai_app/features/profile/data/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BMR (Mifflin-St Jeor)', () {
    test('men: 10w + 6.25h - 5a + 5', () {
      // 700 + 1093.75 - 150 + 5
      expect(
        CalorieCalculator.bmr(
          gender: Gender.male,
          weightKg: 70,
          heightCm: 175,
          age: 30,
        ),
        1648.75,
      );
    });

    test('women: 10w + 6.25h - 5a - 161', () {
      // 700 + 1093.75 - 150 - 161
      expect(
        CalorieCalculator.bmr(
          gender: Gender.female,
          weightKg: 70,
          heightCm: 175,
          age: 30,
        ),
        1482.75,
      );
    });
  });

  test('TDEE multipliers', () {
    expect(CalorieCalculator.tdee(1000, ActivityLevel.sedentary), 1200);
    expect(CalorieCalculator.tdee(1000, ActivityLevel.light), 1375);
    expect(CalorieCalculator.tdee(1000, ActivityLevel.moderate), 1550);
    expect(CalorieCalculator.tdee(1000, ActivityLevel.active), 1725);
  });

  test('goal adjustments', () {
    expect(CalorieCalculator.targetCalories(2500, GoalType.lose), 2000);
    expect(CalorieCalculator.targetCalories(2500, GoalType.maintain), 2500);
    expect(CalorieCalculator.targetCalories(2500, GoalType.gain), 3000);
  });

  test('target never drops below the safety floor', () {
    expect(CalorieCalculator.targetCalories(900, GoalType.lose), 1200);
  });

  test('macros: 50% carbs, 30% protein at 4 kcal/g; 20% fat at 9 kcal/g', () {
    final goals = CalorieCalculator.macrosFor(2000);
    expect(goals.dailyCalories, 2000);
    expect(goals.carbs, 250); // 1000 kcal / 4
    expect(goals.protein, 150); // 600 kcal / 4
    expect(goals.fat, 44); // 400 kcal / 9 = 44.4
  });

  test('full pipeline from a profile', () {
    final now = DateTime.now();
    final profile = UserProfile(
      name: 'Sam',
      gender: Gender.male,
      birthday: DateTime(now.year - 30, 1, 1),
      heightCm: 175,
      weightKg: 70,
      goal: GoalType.lose,
      activityLevel: ActivityLevel.moderate,
      dietType: DietType.classic,
    );

    // 1648.75 × 1.55 = 2555.56; − 500 = 2055.56 → 2056
    final goals = CalorieCalculator.calculate(profile);
    expect(goals.dailyCalories, 2056);
    expect(goals.carbs, 257);
    expect(goals.protein, 154);
    expect(goals.fat, 46);
  });

  test('breakdown exposes each step for display', () {
    final now = DateTime.now();
    final b = CalorieCalculator.breakdown(
      UserProfile(
        name: 'Sam',
        gender: Gender.male,
        birthday: DateTime(now.year - 30, 1, 1),
        heightCm: 175,
        weightKg: 70,
        goal: GoalType.lose,
        activityLevel: ActivityLevel.moderate,
        dietType: DietType.classic,
      ),
    );
    expect(b.bmr, 1649); // 1648.75
    expect(b.activityMultiplier, 1.55);
    expect(b.tdee, 2556); // 2555.56
    expect(b.goalAdjustment, -500);
    expect(b.targetCalories, 2056);
    expect(b.hitMinimum, isFalse);
  });

  test('breakdown flags when the 1200 kcal floor applies', () {
    final now = DateTime.now();
    final b = CalorieCalculator.breakdown(
      UserProfile(
        name: 'Ann',
        gender: Gender.female,
        birthday: DateTime(now.year - 80, 1, 1),
        heightCm: 150,
        weightKg: 40,
        goal: GoalType.lose,
        activityLevel: ActivityLevel.sedentary,
        dietType: DietType.classic,
      ),
    );
    expect(b.targetCalories, CalorieCalculator.minimumCalories);
    expect(b.hitMinimum, isTrue);
  });

  test('walking kcal ≈ 0.0005 × kg per step', () {
    expect(CalorieCalculator.walkingKcal(1000, 70), 35);
    expect(CalorieCalculator.walkingKcal(0, 70), 0);
  });

  test('estimates macro grams from calories with the 50/30/20 split', () {
    final m = CalorieCalculator.estimateMacroGrams(400);
    expect(m.carbs, 50.0); // 200 kcal / 4
    expect(m.protein, 30.0); // 120 kcal / 4
    expect(m.fat, 8.9); // 80 kcal / 9
  });
}
