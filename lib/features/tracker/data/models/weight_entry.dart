/// One weigh-in: the body weight logged for a day.
class WeightEntry {
  const WeightEntry({required this.date, required this.weightKg});

  /// The day (time stripped).
  final DateTime date;
  final double weightKg;
}
