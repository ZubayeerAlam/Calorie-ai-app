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
    this.macrosEstimated = false,
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

  /// True when protein/carbs/fat were estimated from calories because the
  /// user left them blank.
  final bool macrosEstimated;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'mealType': mealType.name,
    'loggedAt': loggedAt.toIso8601String(),
    'imagePath': imagePath,
    'macrosEstimated': macrosEstimated,
  };

  factory FoodEntry.fromJson(Map<String, dynamic> json) => FoodEntry(
    id: json['id'] as String,
    name: json['name'] as String,
    calories: json['calories'] as int,
    protein: (json['protein'] as num).toDouble(),
    carbs: (json['carbs'] as num).toDouble(),
    fat: (json['fat'] as num).toDouble(),
    mealType: MealType.values.byName(json['mealType'] as String),
    loggedAt: DateTime.parse(json['loggedAt'] as String),
    imagePath: json['imagePath'] as String?,
    macrosEstimated: json['macrosEstimated'] as bool? ?? false,
  );
}
