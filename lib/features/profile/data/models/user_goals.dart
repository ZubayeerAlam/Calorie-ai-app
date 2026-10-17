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

  Map<String, dynamic> toJson() => {
    'dailyCalories': dailyCalories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
  };

  factory UserGoals.fromJson(Map<String, dynamic> json) => UserGoals(
    dailyCalories: json['dailyCalories'] as int,
    protein: json['protein'] as int,
    carbs: json['carbs'] as int,
    fat: json['fat'] as int,
  );
}
