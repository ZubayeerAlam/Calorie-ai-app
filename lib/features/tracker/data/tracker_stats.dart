import '../../../core/utils/date_utils.dart';
import '../../food_log/data/models/food_entry.dart';
import '../../profile/data/models/user_goals.dart';
import 'models/weight_entry.dart';
import '../../../l10n/l10n.dart';

/// How far back the Tracker looks.
enum TrackerPeriod {
  week(7),
  month(30);

  const TrackerPeriod(this.days);

  final int days;

  String get label => switch (this) {
    week => l10n.periodWeek,
    month => l10n.periodMonth,
  };
}

/// Totals for one day.
class DaySummary {
  const DaySummary({
    required this.date,
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.entries = 0,
    this.burned = 0,
    this.steps = 0,
  });

  final DateTime date;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  /// Number of food entries logged.
  final int entries;
  final int burned;
  final int steps;

  bool get logged => entries > 0;
}

/// Everything the Tracker shows for a period, worked out from the logs.
class TrackerStats {
  const TrackerStats({
    required this.period,
    required this.days,
    required this.goals,
    required this.streak,
    required this.weights,
  });

  /// A day counts as on target within ±10 % of the calorie target.
  static const double onTargetMargin = 0.1;

  final TrackerPeriod period;

  /// One summary per day of the period, oldest first, ending today.
  final List<DaySummary> days;
  final UserGoals goals;

  /// Days in a row with food logged, up to today (or yesterday while
  /// today is still empty).
  final int streak;

  /// Weigh-ins inside the period, oldest first.
  final List<WeightEntry> weights;

  List<DaySummary> get loggedDays => days.where((d) => d.logged).toList();

  bool isOnTarget(DaySummary day) =>
      day.logged &&
      (day.calories - goals.dailyCalories).abs() <=
          goals.dailyCalories * onTargetMargin;

  int get daysOnTarget => days.where(isOnTarget).length;

  /// Averages over the days with food logged (empty days would drag them
  /// down without meaning anything).
  int get averageCalories => _average((d) => d.calories).round();
  double get averageProtein => _average((d) => d.protein);
  double get averageCarbs => _average((d) => d.carbs);
  double get averageFat => _average((d) => d.fat);

  int get totalSteps => days.fold(0, (sum, d) => sum + d.steps);

  /// Average over the days with any steps.
  int get averageSteps {
    final walked = days.where((d) => d.steps > 0).toList();
    if (walked.isEmpty) return 0;
    return (walked.fold(0, (sum, d) => sum + d.steps) / walked.length).round();
  }

  /// Newest minus oldest weigh-in in the period; null with fewer than two.
  double? get weightChange => weights.length < 2
      ? null
      : weights.last.weightKg - weights.first.weightKg;

  double _average(num Function(DaySummary) value) {
    final logged = loggedDays;
    if (logged.isEmpty) return 0;
    return logged.fold<double>(0, (sum, d) => sum + value(d)) / logged.length;
  }

  static TrackerStats build({
    required TrackerPeriod period,
    required DateTime today,
    required List<FoodEntry> entries,
    required int Function(DateTime day) stepsOn,
    required int Function(DateTime day) burnedOn,
    required List<WeightEntry> weights,
    required UserGoals goals,
  }) {
    final end = AppDates.dateOnly(today);
    final start = end.subtract(Duration(days: period.days - 1));

    final byDay = <String, List<FoodEntry>>{};
    for (final entry in entries) {
      byDay.putIfAbsent(AppDates.key(entry.loggedAt), () => []).add(entry);
    }

    final days = [
      for (var i = 0; i < period.days; i++)
        _summarize(
          DateTime(start.year, start.month, start.day + i),
          byDay,
          stepsOn,
          burnedOn,
        ),
    ];

    return TrackerStats(
      period: period,
      days: days,
      goals: goals,
      streak: streakFor(byDay.keys.toSet(), end),
      weights: [
        for (final w in weights)
          if (!w.date.isBefore(start) && !w.date.isAfter(end)) w,
      ],
    );
  }

  static DaySummary _summarize(
    DateTime day,
    Map<String, List<FoodEntry>> byDay,
    int Function(DateTime) stepsOn,
    int Function(DateTime) burnedOn,
  ) {
    final food = byDay[AppDates.key(day)] ?? const <FoodEntry>[];
    return DaySummary(
      date: day,
      calories: food.fold(0, (sum, e) => sum + e.calories),
      protein: food.fold(0, (sum, e) => sum + e.protein),
      carbs: food.fold(0, (sum, e) => sum + e.carbs),
      fat: food.fold(0, (sum, e) => sum + e.fat),
      entries: food.length,
      burned: burnedOn(day),
      steps: stepsOn(day),
    );
  }

  /// Consecutive logged days ending today, or yesterday when nothing is
  /// logged today yet (the streak isn't broken until the day is over).
  static int streakFor(Set<String> loggedDayKeys, DateTime today) {
    var day = AppDates.dateOnly(today);
    if (!loggedDayKeys.contains(AppDates.key(day))) {
      day = DateTime(day.year, day.month, day.day - 1);
    }
    var streak = 0;
    while (loggedDayKeys.contains(AppDates.key(day))) {
      streak++;
      day = DateTime(day.year, day.month, day.day - 1);
    }
    return streak;
  }
}
