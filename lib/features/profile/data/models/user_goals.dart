import '../../../../core/constants/app_constants.dart';

class UserGoals {
  const UserGoals({
    this.dailyCalories = AppConstants.defaultDailyCalorieGoal,
    this.protein = AppConstants.defaultProteinGoal,
    this.carbs = AppConstants.defaultCarbsGoal,
    this.fat = AppConstants.defaultFatGoal,
  });

  final int dailyCalories;
  final int protein;
  final int carbs;
  final int fat;

  UserGoals copyWith({int? dailyCalories, int? protein, int? carbs, int? fat}) {
    return UserGoals(
      dailyCalories: dailyCalories ?? this.dailyCalories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
    );
  }
}
