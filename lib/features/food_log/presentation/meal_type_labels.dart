import '../data/models/food_entry.dart';
import '../../../l10n/l10n.dart';

extension MealTypeLabel on MealType {
  String get label => switch (this) {
    MealType.breakfast => l10n.breakfast,
    MealType.lunch => l10n.lunch,
    MealType.dinner => l10n.dinner,
    MealType.snack => l10n.snacks,
  };

  /// Share of the daily calorie target for this meal (sums to 1).
  double get calorieShare => switch (this) {
    MealType.breakfast => 0.3,
    MealType.lunch => 0.3,
    MealType.dinner => 0.3,
    MealType.snack => 0.1,
  };

  int targetCalories(int dailyCalories) =>
      (dailyCalories * calorieShare).round();

  /// The meal you are most likely logging at [time]:
  /// before 10:00 breakfast, before 15:00 lunch, before 17:00 snacks,
  /// before 22:00 dinner, otherwise snacks.
  static MealType suggestedFor(DateTime time) => switch (time.hour) {
    < 10 => MealType.breakfast,
    < 15 => MealType.lunch,
    < 17 => MealType.snack,
    < 22 => MealType.dinner,
    _ => MealType.snack,
  };
}
