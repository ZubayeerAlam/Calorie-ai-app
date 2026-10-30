import 'package:flutter/foundation.dart';

import '../../../core/services/food_analysis_service.dart';
import '../../food_log/data/models/food_entry.dart';
import '../../food_log/presentation/meal_type_labels.dart';
import '../data/models/analysis_request.dart';
import '../data/models/food_analysis.dart';
import '../data/models/food_description.dart';

enum AnalysisStatus { analyzing, ready, failed }

/// Runs the AI analysis for one photo or typed description, and holds the
/// editable result. Created per screen (see the `/analyze-food` route).
class FoodAnalysisController extends ChangeNotifier {
  FoodAnalysisController({
    required this.service,
    required this.request,
    DateTime? now,
  }) : _meal = MealTypeLabel.suggestedFor(now ?? DateTime.now()) {
    analyze();
  }

  final FoodAnalysisService service;
  final AnalysisRequest request;

  /// The photo being analysed, or null for a typed description.
  String? get imagePath => switch (request) {
    PhotoAnalysisRequest(:final imagePath) => imagePath,
    TextAnalysisRequest() => null,
  };

  /// The typed description, or null for a photo.
  FoodDescription? get description => switch (request) {
    PhotoAnalysisRequest() => null,
    TextAnalysisRequest(:final description) => description,
  };

  AnalysisStatus _status = AnalysisStatus.analyzing;
  FoodAnalysisFailure? _failure;
  List<AnalyzedFoodItem> _items = [];
  // Stable id per item, so edit fields keep their state when another item
  // is removed.
  List<int> _keys = [];
  int _nextKey = 0;
  MealType _meal;
  bool _disposed = false;

  AnalysisStatus get status => _status;
  FoodAnalysisFailure? get failure => _failure;
  List<AnalyzedFoodItem> get items => List.unmodifiable(_items);
  MealType get meal => _meal;
  bool get isDemo => service.isDemo;

  int itemKey(int index) => _keys[index];

  int get totalCalories => _items.fold(0, (sum, i) => sum + i.calories);

  /// Ready, at least one item, and every item has a name.
  bool get canSave =>
      _status == AnalysisStatus.ready &&
      _items.isNotEmpty &&
      _items.every((i) => i.name.trim().isNotEmpty);

  /// Starts (or restarts, after a failure) the analysis.
  Future<void> analyze() async {
    _status = AnalysisStatus.analyzing;
    _failure = null;
    _notify();
    try {
      final result = await switch (request) {
        PhotoAnalysisRequest(:final imagePath) => service.analyzePhoto(
          imagePath,
        ),
        TextAnalysisRequest(:final description) => service.analyzeText(
          description,
        ),
      };
      _items = List.of(result.items);
      _keys = [for (final _ in _items) _nextKey++];
      _status = AnalysisStatus.ready;
    } on FoodAnalysisException catch (e) {
      _failure = e.failure;
      _status = AnalysisStatus.failed;
    } catch (_) {
      _failure = FoodAnalysisFailure.unknown;
      _status = AnalysisStatus.failed;
    }
    _notify();
  }

  void updateItem(int index, AnalyzedFoodItem item) {
    _items[index] = item;
    _notify();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    _keys.removeAt(index);
    _notify();
  }

  void setMeal(MealType meal) {
    _meal = meal;
    _notify();
  }

  /// One food log entry per item, on [day] at the current time of day,
  /// keeping the photo (if any) and marked as an AI estimate.
  List<FoodEntry> toEntries(DateTime day, {DateTime? now}) {
    final at = now ?? DateTime.now();
    final loggedAt = DateTime(
      day.year,
      day.month,
      day.day,
      at.hour,
      at.minute,
      at.second,
    );
    final idBase = at.microsecondsSinceEpoch;
    return [
      for (var i = 0; i < _items.length; i++)
        FoodEntry(
          id: '$idBase-$i',
          name: _items[i].name.trim(),
          portion: _items[i].portion.isEmpty ? null : _items[i].portion,
          calories: _items[i].calories,
          protein: _items[i].protein,
          carbs: _items[i].carbs,
          fat: _items[i].fat,
          mealType: _meal,
          loggedAt: loggedAt,
          imagePath: imagePath,
          aiEstimated: true,
        ),
    ];
  }

  // The screen may close while the AI is still working.
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
