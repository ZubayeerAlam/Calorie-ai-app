enum MealType { breakfast, lunch, dinner, snack }

class FoodEntry {
  const FoodEntry({
    required this.id,
    required this.name,
    required this.calories,
    required this.mealType,
    required this.loggedAt,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.imagePath,
  });

  final String id;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final MealType mealType;
  final DateTime loggedAt;
  final String? imagePath;
}
