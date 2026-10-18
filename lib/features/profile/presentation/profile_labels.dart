import 'package:flutter/material.dart';

import '../data/models/user_profile.dart';

extension GenderLabel on Gender {
  String get label => switch (this) {
    Gender.male => 'Male',
    Gender.female => 'Female',
    Gender.other => 'Other',
  };

  IconData get icon => switch (this) {
    Gender.male => Icons.male,
    Gender.female => Icons.female,
    Gender.other => Icons.transgender,
  };
}

extension GoalTypeLabel on GoalType {
  String get label => switch (this) {
    GoalType.lose => 'Lose weight',
    GoalType.maintain => 'Maintain weight',
    GoalType.gain => 'Gain weight',
  };

  IconData get icon => switch (this) {
    GoalType.lose => Icons.trending_down,
    GoalType.maintain => Icons.trending_flat,
    GoalType.gain => Icons.trending_up,
  };

  String get emoji => switch (this) {
    GoalType.lose => '🔥',
    GoalType.maintain => '⚖️',
    GoalType.gain => '🎈',
  };
}

extension ActivityLevelLabel on ActivityLevel {
  String get label => switch (this) {
    ActivityLevel.sedentary => 'Sedentary',
    ActivityLevel.light => 'Lightly active',
    ActivityLevel.moderate => 'Moderately active',
    ActivityLevel.active => 'Very active',
  };

  String get description => switch (this) {
    ActivityLevel.sedentary => 'Little or no exercise, desk job',
    ActivityLevel.light => 'Light exercise 1–3 days a week',
    ActivityLevel.moderate => 'Moderate exercise 3–5 days a week',
    ActivityLevel.active => 'Hard exercise 6–7 days a week',
  };

  IconData get icon => switch (this) {
    ActivityLevel.sedentary => Icons.weekend_outlined,
    ActivityLevel.light => Icons.directions_walk,
    ActivityLevel.moderate => Icons.directions_bike,
    ActivityLevel.active => Icons.directions_run,
  };
}

extension DietTypeLabel on DietType {
  String get label => switch (this) {
    DietType.classic => 'Classic',
    DietType.vegetarian => 'Vegetarian',
    DietType.vegan => 'Vegan',
    DietType.pescatarian => 'Pescatarian',
    DietType.keto => 'Keto',
  };

  String get description => switch (this) {
    DietType.classic => 'No restrictions',
    DietType.vegetarian => 'No meat or fish',
    DietType.vegan => 'No animal products',
    DietType.pescatarian => 'Fish but no meat',
    DietType.keto => 'High fat, very low carb',
  };

  IconData get icon => switch (this) {
    DietType.classic => Icons.restaurant,
    DietType.vegetarian => Icons.egg_alt_outlined,
    DietType.vegan => Icons.eco_outlined,
    DietType.pescatarian => Icons.set_meal_outlined,
    DietType.keto => Icons.local_fire_department_outlined,
  };
}

/// Display strings for a saved profile, in the user's chosen units.
extension UserProfileDisplay on UserProfile {
  static const double _lbPerKg = 2.20462;
  static const double _cmPerInch = 2.54;

  String get weightLabel => useMetric
      ? '${weightKg.toStringAsFixed(1)} kg'
      : '${(weightKg * _lbPerKg).toStringAsFixed(1)} lb';

  String get heightLabel {
    if (useMetric) return '$heightCm cm';
    final inches = (heightCm / _cmPerInch).round();
    return '${inches ~/ 12}′${inches % 12}″';
  }

  String get bmiCategory => switch (bmi) {
    < 18.5 => 'Underweight',
    < 25 => 'Healthy',
    < 30 => 'Overweight',
    _ => 'Obese',
  };
}
