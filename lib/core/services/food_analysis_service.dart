import '../../features/food_scan/data/models/food_analysis.dart';
import '../../features/food_scan/data/models/food_description.dart';

/// Why an analysis didn't produce a result.
enum FoodAnalysisFailure {
  /// The photo doesn't seem to show food, or the description doesn't
  /// mention any.
  notFood,

  /// No connection, or the service couldn't be reached.
  network,

  /// The AI replied, but not in the expected shape.
  invalidResponse,

  /// Anything else.
  unknown,
}

class FoodAnalysisException implements Exception {
  const FoodAnalysisException(this.failure, [this.message]);

  final FoodAnalysisFailure failure;
  final String? message;

  @override
  String toString() =>
      'FoodAnalysisException(${failure.name}${message == null ? '' : ': $message'})';
}

/// Turns a food photo, or a typed description, into estimated nutrition.
///
/// The real implementation will call an AI model through Firebase, so the
/// AI key never ships inside the app (see cal-ai-build/plan.md, feature 15).
/// Until then the app uses [DemoFoodAnalysisService].
abstract class FoodAnalysisService {
  /// True for the stand-in service: screens show a "demo" notice so sample
  /// results are never mistaken for a real analysis.
  bool get isDemo;

  /// Analyses the photo at [imagePath].
  /// Throws [FoodAnalysisException] when there is no usable result.
  Future<FoodAnalysis> analyzePhoto(String imagePath);

  /// Analyses what the user typed on the "Add manually" screen.
  /// Throws [FoodAnalysisException] when there is no usable result.
  Future<FoodAnalysis> analyzeText(FoodDescription description);
}
