import '../../features/profile/data/models/user_goals.dart';
import '../../features/profile/data/models/user_profile.dart';

/// Daily calorie and macro targets from onboarding data.
///
/// 1. BMR (Mifflin-St Jeor):
///    men   = 10 × weight(kg) + 6.25 × height(cm) − 5 × age + 5
///    women = 10 × weight(kg) + 6.25 × height(cm) − 5 × age − 161
/// 2. TDEE = BMR × activity multiplier.
/// 3. Target = TDEE + goal adjustment (−500 / 0 / +500 kcal).
/// 4. Macros: carbs 50%, protein 30%, fat 20% of the target calories,
///    at 4 / 4 / 9 kcal per gram.
class CalorieCalculator {
  CalorieCalculator._();

  /// Safety floor so a large deficit never produces an unsafe target.
  static const int minimumCalories = 1200;

  static const Map<ActivityLevel, double> activityMultipliers = {
    ActivityLevel.sedentary: 1.2,
    ActivityLevel.light: 1.375,
    ActivityLevel.moderate: 1.55,
    ActivityLevel.active: 1.725,
  };

  static const Map<GoalType, int> goalAdjustments = {
    GoalType.lose: -500,
    GoalType.maintain: 0,
    GoalType.gain: 500,
  };

  static const double carbsRatio = 0.50;
  static const double proteinRatio = 0.30;
  static const double fatRatio = 0.20;

  static const int kcalPerGramCarbs = 4;
  static const int kcalPerGramProtein = 4;
  static const int kcalPerGramFat = 9;

  /// Basal metabolic rate in kcal/day.
  static double bmr({
    required Gender gender,
    required double weightKg,
    required int heightCm,
    required int age,
  }) {
    final base = 10 * weightKg + 6.25 * heightCm - 5 * age;
    return switch (gender) {
      Gender.male => base + 5,
      Gender.female => base - 161,
      // Not in the formula; use the midpoint of the male/female offsets.
      Gender.other => base - 78,
    };
  }

  /// Total daily energy expenditure: BMR scaled by activity.
  static double tdee(double bmr, ActivityLevel activity) =>
      bmr * activityMultipliers[activity]!;

  /// Target daily calories: TDEE adjusted for the goal.
  static int targetCalories(double tdee, GoalType goal) =>
      (tdee + goalAdjustments[goal]!).round().clamp(minimumCalories, 10000);

  /// Calories split into grams of protein, carbs and fat.
  static UserGoals macrosFor(int calories) => UserGoals(
    dailyCalories: calories,
    carbs: (calories * carbsRatio / kcalPerGramCarbs).round(),
    protein: (calories * proteinRatio / kcalPerGramProtein).round(),
    fat: (calories * fatRatio / kcalPerGramFat).round(),
  );

  /// Every step of the calculation for [profile], for display.
  static CalorieBreakdown breakdown(UserProfile profile) {
    final base = bmr(
      gender: profile.gender,
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
      age: profile.age,
    );
    final expenditure = tdee(base, profile.activityLevel);
    return CalorieBreakdown(
      bmr: base.round(),
      activityLevel: profile.activityLevel,
      activityMultiplier: activityMultipliers[profile.activityLevel]!,
      tdee: expenditure.round(),
      goal: profile.goal,
      goalAdjustment: goalAdjustments[profile.goal]!,
      targetCalories: targetCalories(expenditure, profile.goal),
    );
  }

  /// Estimated grams for a food when only its calories are known,
  /// using the same 50/30/20 split as the daily plan (1 decimal place).
  static ({double carbs, double protein, double fat}) estimateMacroGrams(
    int calories,
  ) {
    double grams(double ratio, int kcalPerGram) =>
        (calories * ratio / kcalPerGram * 10).roundToDouble() / 10;
    return (
      carbs: grams(carbsRatio, kcalPerGramCarbs),
      protein: grams(proteinRatio, kcalPerGramProtein),
      fat: grams(fatRatio, kcalPerGramFat),
    );
  }

  /// Approximate walking calories: about 0.0005 kcal per step per kg of
  /// body weight (≈35 kcal per 1000 steps at 70 kg).
  static const double kcalPerStepPerKg = 0.0005;

  static int walkingKcal(int steps, double weightKg) =>
      (steps * kcalPerStepPerKg * weightKg).round();

  /// Full pipeline for a profile: BMR → TDEE → target → macros.
  static UserGoals calculate(UserProfile profile) =>
      macrosFor(breakdown(profile).targetCalories);

  /// Expected weekly weight change in kg (≈7700 kcal per kg of body weight).
  static double weeklyChangeKg(GoalType goal) =>
      goalAdjustments[goal]! * 7 / 7700;
}

/// The intermediate results of [CalorieCalculator.breakdown].
class CalorieBreakdown {
  const CalorieBreakdown({
    required this.bmr,
    required this.activityLevel,
    required this.activityMultiplier,
    required this.tdee,
    required this.goal,
    required this.goalAdjustment,
    required this.targetCalories,
  });

  /// Calories burned at rest.
  final int bmr;
  final ActivityLevel activityLevel;
  final double activityMultiplier;

  /// BMR × activity multiplier: calories burned in a normal day.
  final int tdee;
  final GoalType goal;

  /// −500 / 0 / +500 kcal.
  final int goalAdjustment;

  /// TDEE + adjustment, never below [CalorieCalculator.minimumCalories].
  final int targetCalories;

  /// True when the safety floor raised the target.
  bool get hitMinimum => tdee + goalAdjustment < targetCalories;
}
