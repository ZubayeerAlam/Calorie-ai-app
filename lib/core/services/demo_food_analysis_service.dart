import '../../features/food_scan/data/models/food_analysis.dart';
import '../../features/food_scan/data/models/food_description.dart';
import '../utils/calorie_calculator.dart';
import 'food_analysis_service.dart';

/// Stand-in for the real AI until Firebase is set up. [isDemo] is true, so
/// the app labels these results as samples.
///
/// - Photos: it does not look at the photo. It returns one of a few sample
///   meals (picked from the file path, so the same photo gives the same
///   result).
/// - Text: it splits the description into foods ("eggs, toast and tea" →
///   3 items) and gives each sample numbers, not real nutrition.
class DemoFoodAnalysisService implements FoodAnalysisService {
  const DemoFoodAnalysisService({
    this.delay = const Duration(milliseconds: 1500),
  });

  final Duration delay;

  static const List<List<AnalyzedFoodItem>> sampleMeals = [
    [
      AnalyzedFoodItem(
        name: 'Grilled chicken breast',
        portion: '150 g',
        calories: 248,
        protein: 46.5,
        carbs: 0,
        fat: 5.4,
      ),
      AnalyzedFoodItem(
        name: 'Steamed rice',
        portion: '1 cup (160 g)',
        calories: 206,
        protein: 4.3,
        carbs: 44.5,
        fat: 0.4,
      ),
    ],
    [
      AnalyzedFoodItem(
        name: 'Mixed green salad',
        portion: '1 bowl (200 g)',
        calories: 120,
        protein: 3,
        carbs: 10,
        fat: 8,
      ),
    ],
    [
      AnalyzedFoodItem(
        name: 'Scrambled eggs',
        portion: '2 eggs',
        calories: 182,
        protein: 12.2,
        carbs: 2,
        fat: 13.6,
      ),
      AnalyzedFoodItem(
        name: 'Whole-wheat toast',
        portion: '1 slice',
        calories: 80,
        protein: 4,
        carbs: 14,
        fat: 1,
      ),
    ],
  ];

  @override
  bool get isDemo => true;

  @override
  Future<FoodAnalysis> analyzePhoto(String imagePath) async {
    await Future<void>.delayed(delay);
    final index = imagePath.hashCode.abs() % sampleMeals.length;
    return FoodAnalysis(items: sampleMeals[index]);
  }

  /// Splits on commas, new lines, "+", "&", ";" and the word "and".
  static final RegExp _separators = RegExp(
    r'[,\n+&;]|\band\b',
    caseSensitive: false,
  );

  static const int _maxItems = 6;

  @override
  Future<FoodAnalysis> analyzeText(FoodDescription description) async {
    await Future<void>.delayed(delay);
    final names = description.text
        .split(_separators)
        .map((part) => part.trim())
        .where((part) => part.length > 1)
        .take(_maxItems)
        .toList();
    if (names.isEmpty) {
      throw const FoodAnalysisException(FoodAnalysisFailure.notFood);
    }
    return FoodAnalysis(
      items: [
        for (final name in names)
          _sampleItem(
            name,
            portion: names.length == 1 ? description.portion.trim() : '',
          ),
      ],
    );
  }

  /// Sample numbers (80–400 kcal, same name → same value), split 50/30/20.
  static AnalyzedFoodItem _sampleItem(String name, {required String portion}) {
    final calories = 80 + (name.toLowerCase().hashCode.abs() % 33) * 10;
    final macros = CalorieCalculator.estimateMacroGrams(calories);
    return AnalyzedFoodItem(
      name: name[0].toUpperCase() + name.substring(1),
      portion: portion,
      calories: calories,
      protein: macros.protein,
      carbs: macros.carbs,
      fat: macros.fat,
    );
  }
}
