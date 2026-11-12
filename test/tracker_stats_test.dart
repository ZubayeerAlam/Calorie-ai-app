import 'package:cal_ai_app/features/food_log/data/models/food_entry.dart';
import 'package:cal_ai_app/features/profile/data/models/user_goals.dart';
import 'package:cal_ai_app/features/tracker/data/models/weight_entry.dart';
import 'package:cal_ai_app/features/tracker/data/tracker_stats.dart';
import 'package:cal_ai_app/features/tracker/presentation/widgets/chart_labels.dart';
import 'package:flutter_test/flutter_test.dart';

final _today = DateTime(2026, 11, 2); // a Monday

FoodEntry _food(int daysAgo, int kcal, {double protein = 0}) => FoodEntry(
  id: '$daysAgo-$kcal',
  name: 'Food',
  calories: kcal,
  protein: protein,
  mealType: MealType.lunch,
  loggedAt: DateTime(_today.year, _today.month, _today.day - daysAgo, 13),
);

TrackerStats _stats(
  List<FoodEntry> food, {
  TrackerPeriod period = TrackerPeriod.week,
  List<WeightEntry> weights = const [],
}) => TrackerStats.build(
  period: period,
  today: _today,
  entries: food,
  stepsOn: (day) => day.day * 100,
  burnedOn: (_) => 0,
  weights: weights,
  goals: const UserGoals(dailyCalories: 2000),
);

void main() {
  test('one summary per day, oldest first, ending today', () {
    final stats = _stats([]);
    expect(stats.days, hasLength(7));
    expect(stats.days.first.date, DateTime(2026, 10, 27));
    expect(stats.days.last.date, _today);
    expect(_stats([], period: TrackerPeriod.month).days, hasLength(30));
  });

  test('daily totals, and averages only over logged days', () {
    final stats = _stats([
      _food(0, 1500, protein: 100),
      _food(0, 500, protein: 20),
      _food(2, 1000, protein: 60),
      _food(9, 3000), // outside the week
    ]);
    expect(stats.days.last.calories, 2000);
    expect(stats.days.last.entries, 2);
    expect(stats.loggedDays, hasLength(2));
    expect(stats.averageCalories, 1500);
    expect(stats.averageProtein, 90);
  });

  test('on target means within 10 % of the calorie target', () {
    final stats = _stats([_food(0, 2150), _food(1, 1700), _food(2, 2300)]);
    expect(stats.isOnTarget(stats.days[6]), isTrue); // 2150
    expect(stats.isOnTarget(stats.days[5]), isFalse); // 1700
    expect(stats.isOnTarget(stats.days[4]), isFalse); // 2300
    expect(stats.daysOnTarget, 1);
  });

  test('streak counts back from today, or yesterday while today is empty', () {
    expect(_stats([_food(0, 1), _food(1, 1), _food(2, 1)]).streak, 3);
    expect(_stats([_food(1, 1), _food(2, 1), _food(4, 1)]).streak, 2);
    expect(_stats([_food(2, 1)]).streak, 0);
    // The streak isn't limited to the period.
    expect(_stats([for (var i = 0; i < 10; i++) _food(i, 1)]).streak, 10);
  });

  test('steps per day and their average over walked days', () {
    final stats = _stats([]);
    expect(stats.days.last.steps, 200); // Nov 2 → 2 × 100
    expect(stats.totalSteps, stats.days.fold(0, (s, d) => s + d.steps));
  });

  test('weights inside the period and their change', () {
    final stats = _stats(
      [],
      weights: [
        WeightEntry(date: DateTime(2026, 10, 1), weightKg: 80),
        WeightEntry(date: DateTime(2026, 10, 28), weightKg: 72),
        WeightEntry(date: DateTime(2026, 11, 2), weightKg: 71.2),
      ],
    );
    expect(stats.weights, hasLength(2));
    expect(stats.weightChange, closeTo(-0.8, 1e-9));
    expect(_stats([]).weightChange, isNull);
  });

  test('bar labels: weekdays for a week, every fifth date for a month', () {
    final week = _stats([]).days.map((d) => d.date).toList();
    expect(ChartLabels.forDays(week), ['T', 'W', 'T', 'F', 'S', 'S', 'M']);
    final month = _stats(
      [],
      period: TrackerPeriod.month,
    ).days.map((d) => d.date).toList();
    final labels = ChartLabels.forDays(month);
    expect(labels.last, '2'); // today
    expect(labels[24], '28'); // five days earlier
    expect(labels.where((l) => l.isNotEmpty), hasLength(6));
  });

  test('workouts: totals and active days over the period', () {
    final stats = TrackerStats.build(
      period: TrackerPeriod.week,
      today: _today,
      entries: const [],
      stepsOn: (_) => 0,
      burnedOn: (_) => 0,
      weights: const [],
      goals: const UserGoals(),
      workoutsOn: (day) => switch (_today.difference(day).inDays) {
        0 => const WorkoutDay(count: 1, minutes: 12, kcal: 45),
        2 => const WorkoutDay(count: 2, minutes: 20, kcal: 70),
        _ => WorkoutDay.none,
      },
    );
    expect(stats.totalWorkouts, 3);
    expect(stats.workoutMinutes, 32);
    expect(stats.workoutKcal, 115);
    expect(stats.workoutDays, 2);
    expect(stats.days.last.workouts.kcal, 45);
    expect(_stats([]).totalWorkouts, 0); // no workouts given
  });
}
