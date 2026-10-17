import 'package:flutter/foundation.dart';

import '../data/models/food_entry.dart';
import '../data/repositories/food_log_repository.dart';

class FoodLogProvider extends ChangeNotifier {
  FoodLogProvider(this._repository) {
    loadToday();
  }

  final FoodLogRepository _repository;

  List<FoodEntry> _entries = [];
  bool _isLoading = false;

  List<FoodEntry> get entries => List.unmodifiable(_entries);
  bool get isLoading => _isLoading;

  int get totalCalories => _entries.fold(0, (sum, e) => sum + e.calories);
  double get totalProtein => _entries.fold(0, (sum, e) => sum + e.protein);
  double get totalCarbs => _entries.fold(0, (sum, e) => sum + e.carbs);
  double get totalFat => _entries.fold(0, (sum, e) => sum + e.fat);

  Future<void> loadToday() async {
    _isLoading = true;
    notifyListeners();
    _entries = await _repository.getEntriesFor(DateTime.now());
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addEntry(FoodEntry entry) async {
    await _repository.add(entry);
    await loadToday();
  }

  Future<void> removeEntry(String id) async {
    await _repository.remove(id);
    await loadToday();
  }
}
