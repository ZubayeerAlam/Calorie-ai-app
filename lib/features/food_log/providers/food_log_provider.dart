import 'package:flutter/foundation.dart';

import '../../../core/utils/date_utils.dart';
import '../data/models/food_entry.dart';
import '../data/repositories/food_log_repository.dart';

class FoodLogProvider extends ChangeNotifier {
  FoodLogProvider(this._repository) {
    load();
  }

  final FoodLogRepository _repository;

  DateTime _selectedDate = AppDates.today();
  List<FoodEntry> _entries = [];
  bool _isLoading = false;

  /// The day the dashboard is showing (time stripped).
  DateTime get selectedDate => _selectedDate;
  bool get isToday => _selectedDate == AppDates.today();
  List<FoodEntry> get entries => List.unmodifiable(_entries);
  bool get isLoading => _isLoading;

  int get totalCalories => _entries.fold(0, (sum, e) => sum + e.calories);
  double get totalProtein => _entries.fold(0, (sum, e) => sum + e.protein);
  double get totalCarbs => _entries.fold(0, (sum, e) => sum + e.carbs);
  double get totalFat => _entries.fold(0, (sum, e) => sum + e.fat);

  List<FoodEntry> entriesFor(MealType meal) =>
      _entries.where((e) => e.mealType == meal).toList();

  int caloriesFor(MealType meal) =>
      entriesFor(meal).fold(0, (sum, e) => sum + e.calories);

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _entries = await _repository.getEntriesFor(_selectedDate);
    _isLoading = false;
    notifyListeners();
  }

  /// Shows [date]; future days are not allowed.
  Future<void> selectDate(DateTime date) async {
    final day = AppDates.dateOnly(date);
    if (day.isAfter(AppDates.today()) || day == _selectedDate) return;
    _selectedDate = day;
    await load();
  }

  Future<void> previousDay() =>
      selectDate(_selectedDate.subtract(const Duration(days: 1)));

  Future<void> nextDay() =>
      selectDate(_selectedDate.add(const Duration(days: 1)));

  Future<void> addEntry(FoodEntry entry) async {
    await _repository.add(entry);
    await load();
  }

  Future<void> removeEntry(String id) async {
    await _repository.remove(id);
    await load();
  }
}
