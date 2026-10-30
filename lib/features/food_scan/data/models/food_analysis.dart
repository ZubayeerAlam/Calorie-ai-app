import '../../../../core/services/food_analysis_service.dart';

/// One food the AI found in a photo, with its estimated nutrition.
class AnalyzedFoodItem {
  const AnalyzedFoodItem({
    required this.name,
    required this.calories,
    this.portion = '',
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
  });

  final String name;

  /// Free text, e.g. "1 bowl (250 g)". May be empty.
  final String portion;
  final int calories;

  /// Grams.
  final double protein;
  final double carbs;
  final double fat;

  AnalyzedFoodItem copyWith({
    String? name,
    String? portion,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
  }) => AnalyzedFoodItem(
    name: name ?? this.name,
    portion: portion ?? this.portion,
    calories: calories ?? this.calories,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fat: fat ?? this.fat,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'portion': portion,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
  };

  /// Strict: throws [FormatException] if a required field is missing or has
  /// the wrong type, so a bad AI reply never turns into a bad log entry.
  factory AnalyzedFoodItem.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final calories = json['calories'];
    if (name is! String || name.trim().isEmpty) {
      throw const FormatException('Item has no name');
    }
    if (calories is! num || calories < 0) {
      throw FormatException('Item "$name" has no valid calories');
    }
    double grams(String key) {
      final value = json[key] ?? 0;
      if (value is! num || value < 0) {
        throw FormatException('Item "$name" has an invalid $key value');
      }
      return value.toDouble();
    }

    return AnalyzedFoodItem(
      name: name.trim(),
      portion: (json['portion'] as String? ?? '').trim(),
      calories: calories.round(),
      protein: grams('protein'),
      carbs: grams('carbs'),
      fat: grams('fat'),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AnalyzedFoodItem &&
      other.name == name &&
      other.portion == portion &&
      other.calories == calories &&
      other.protein == protein &&
      other.carbs == carbs &&
      other.fat == fat;

  @override
  int get hashCode => Object.hash(name, portion, calories, protein, carbs, fat);
}

/// What the AI found in one photo.
class FoodAnalysis {
  const FoodAnalysis({required this.items});

  final List<AnalyzedFoodItem> items;

  int get totalCalories => items.fold(0, (sum, i) => sum + i.calories);

  /// Parses the AI's JSON reply, shaped like:
  /// `{ "isFood": true, "items": [ { "name", "portion", "calories",
  ///   "protein", "carbs", "fat" } ] }`.
  ///
  /// Throws [FoodAnalysisException] with [FoodAnalysisFailure.notFood] when
  /// the AI says there is no food, and [FoodAnalysisFailure.invalidResponse]
  /// when the reply doesn't have this shape.
  factory FoodAnalysis.fromJson(Map<String, dynamic> json) {
    final items = json['items'];
    if (json['isFood'] == false || (items is List && items.isEmpty)) {
      throw const FoodAnalysisException(FoodAnalysisFailure.notFood);
    }
    if (items is! List) {
      throw const FoodAnalysisException(
        FoodAnalysisFailure.invalidResponse,
        'Reply has no items list',
      );
    }
    try {
      return FoodAnalysis(
        items: [
          for (final item in items)
            AnalyzedFoodItem.fromJson(item as Map<String, dynamic>),
        ],
      );
    } on FormatException catch (e) {
      throw FoodAnalysisException(
        FoodAnalysisFailure.invalidResponse,
        e.message,
      );
    } on TypeError {
      throw const FoodAnalysisException(
        FoodAnalysisFailure.invalidResponse,
        'An item is not an object',
      );
    }
  }
}
