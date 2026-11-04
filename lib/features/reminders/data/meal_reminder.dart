import '../../food_log/data/models/food_entry.dart';

/// One meal reminder's settings. The dinner reminder's time is the
/// profile's dinner time, so only breakfast and lunch keep their own.
class MealReminder {
  const MealReminder({
    required this.meal,
    this.enabled = false,
    required this.hour,
    required this.minute,
  });

  /// The meals that have reminders, with their default times.
  static const List<MealReminder> defaults = [
    MealReminder(meal: MealType.breakfast, hour: 8, minute: 0),
    MealReminder(meal: MealType.lunch, hour: 13, minute: 0),
    MealReminder(meal: MealType.dinner, hour: 20, minute: 30),
  ];

  final MealType meal;
  final bool enabled;
  final int hour;
  final int minute;

  MealReminder copyWith({bool? enabled, int? hour, int? minute}) =>
      MealReminder(
        meal: meal,
        enabled: enabled ?? this.enabled,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
      );

  Map<String, dynamic> toJson() => {'on': enabled, 'h': hour, 'm': minute};

  factory MealReminder.fromJson(MealType meal, Map<String, dynamic> json) =>
      MealReminder(
        meal: meal,
        enabled: json['on'] as bool? ?? false,
        hour: json['h'] as int,
        minute: json['m'] as int,
      );
}

/// How a reminder stands today.
enum ReminderStatus {
  /// The meal is logged; no reminder today.
  done,

  /// Its time hasn't come yet.
  upcoming,

  /// Its time has passed and the meal isn't logged.
  missed,
}
