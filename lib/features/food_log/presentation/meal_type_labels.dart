import '../data/models/food_entry.dart';

extension MealTypeLabel on MealType {
  String get label => switch (this) {
    MealType.breakfast => 'Breakfast',
    MealType.lunch => 'Lunch',
    MealType.dinner => 'Dinner',
    MealType.snack => 'Snacks',
  };

  /// Placeholder art; swap for an asset path when illustrations exist.
  String get emoji => switch (this) {
    MealType.breakfast => '🥪',
    MealType.lunch => '🍚',
    MealType.dinner => '🥗',
    MealType.snack => '🍡',
  };

  /// Share of the daily calorie target for this meal (sums to 1).
  double get calorieShare => switch (this) {
    MealType.breakfast => 0.3,
    MealType.lunch => 0.3,
    MealType.dinner => 0.3,
    MealType.snack => 0.1,
  };

  int targetCalories(int dailyCalories) =>
      (dailyCalories * calorieShare).round();
}
