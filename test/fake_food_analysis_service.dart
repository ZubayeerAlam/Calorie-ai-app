import 'dart:async';

import 'package:cal_ai_app/core/services/food_analysis_service.dart';
import 'package:cal_ai_app/features/food_scan/data/models/food_analysis.dart';
import 'package:cal_ai_app/features/food_scan/data/models/food_description.dart';

/// Test double for the AI (photo and text). Returns [items], or throws
/// [failures] in order (one per call) before succeeding. With [hold], each call waits until
/// [release] so tests can see the loading state.
class FakeFoodAnalysisService implements FoodAnalysisService {
  FakeFoodAnalysisService({
    this.items = sampleItems,
    List<FoodAnalysisFailure> failures = const [],
    this.hold = false,
    this.isDemo = false,
  }) : _failures = List.of(failures);

  static const sampleItems = [
    AnalyzedFoodItem(
      name: 'Grilled chicken',
      portion: '150 g',
      calories: 248,
      protein: 46.5,
      carbs: 0,
      fat: 5.4,
    ),
    AnalyzedFoodItem(
      name: 'Steamed rice',
      portion: '1 cup',
      calories: 206,
      protein: 4.3,
      carbs: 44.5,
      fat: 0.4,
    ),
  ];

  final List<AnalyzedFoodItem> items;
  final List<FoodAnalysisFailure> _failures;
  final bool hold;

  @override
  final bool isDemo;

  int calls = 0;

  /// The last description passed to [analyzeText].
  FoodDescription? lastDescription;
  Completer<void>? _gate;

  /// Lets a held call finish.
  void release() => _gate?.complete();

  @override
  Future<FoodAnalysis> analyzePhoto(String imagePath) => _answer();

  @override
  Future<FoodAnalysis> analyzeText(FoodDescription description) {
    lastDescription = description;
    return _answer();
  }

  Future<FoodAnalysis> _answer() async {
    calls++;
    if (hold) {
      _gate = Completer<void>();
      await _gate!.future;
    }
    if (_failures.isNotEmpty) {
      throw FoodAnalysisException(_failures.removeAt(0));
    }
    return FoodAnalysis(items: items);
  }
}
