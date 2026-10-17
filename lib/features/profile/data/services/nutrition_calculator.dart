import '../models/user_goals.dart';
import '../models/user_profile.dart';

/// Derives daily calorie and macro targets from a [UserProfile].
///
/// BMR uses the Mifflin-St Jeor equation, scaled by an activity multiplier
/// and adjusted for the user's goal.
class NutritionCalculator {
  const NutritionCalculator();

  static const int minimumCalories = 1200;

  static const Map<ActivityLevel, double> _activityMultiplier = {
    ActivityLevel.sedentary: 1.2,
    ActivityLevel.light: 1.375,
    ActivityLevel.moderate: 1.55,
    ActivityLevel.active: 1.725,
    ActivityLevel.veryActive: 1.9,
  };

  static const Map<GoalType, int> _goalAdjustment = {
    GoalType.lose: -500,
    GoalType.maintain: 0,
    GoalType.gain: 300,
  };

  // Share of calories from (protein, carbs, fat).
  static const Map<DietType, (double, double, double)> _macroSplit = {
    DietType.classic: (0.30, 0.40, 0.30),
    DietType.vegetarian: (0.25, 0.50, 0.25),
    DietType.vegan: (0.20, 0.55, 0.25),
    DietType.pescatarian: (0.30, 0.40, 0.30),
    DietType.keto: (0.25, 0.05, 0.70),
  };

  double bmr(UserProfile p) {
    final base = 10 * p.weightKg + 6.25 * p.heightCm - 5 * p.age;
    return switch (p.gender) {
      Gender.male => base + 5,
      Gender.female => base - 161,
      Gender.other => base - 78,
    };
  }

  int tdee(UserProfile p) =>
      (bmr(p) * _activityMultiplier[p.activityLevel]!).round();

  UserGoals calculate(UserProfile p) {
    final calories = (tdee(p) + _goalAdjustment[p.goal]!)
        .clamp(minimumCalories, 5000)
        .toInt();
    final (protein, carbs, fat) = _macroSplit[p.dietType]!;
    return UserGoals(
      dailyCalories: calories,
      protein: (calories * protein / 4).round(),
      carbs: (calories * carbs / 4).round(),
      fat: (calories * fat / 9).round(),
    );
  }

  /// Expected weekly weight change in kg (negative = loss).
  double weeklyChangeKg(UserProfile p) => switch (p.goal) {
    GoalType.lose => -0.5,
    GoalType.maintain => 0,
    GoalType.gain => 0.25,
  };
}
