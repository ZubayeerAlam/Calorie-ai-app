import 'package:flutter/material.dart';

import '../../../core/utils/date_utils.dart';

import '../data/models/user_profile.dart';
import '../../../l10n/l10n.dart';

extension GenderLabel on Gender {
  String get label => switch (this) {
    Gender.male => l10n.genderMale,
    Gender.female => l10n.genderFemale,
    Gender.other => l10n.genderOther,
  };

  IconData get icon => switch (this) {
    Gender.male => Icons.male,
    Gender.female => Icons.female,
    Gender.other => Icons.transgender,
  };
}

extension GoalTypeLabel on GoalType {
  String get label => switch (this) {
    GoalType.lose => l10n.goalLose,
    GoalType.maintain => l10n.goalMaintain,
    GoalType.gain => l10n.goalGain,
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

extension GoalFocusLabel on GoalFocus {
  String get label => switch (this) {
    GoalFocus.gainMuscle => l10n.focusGainMuscle,
    GoalFocus.boostEnergy => l10n.focusBoostEnergy,
    GoalFocus.improveNutrition => l10n.focusImproveNutrition,
  };

  String get emoji => switch (this) {
    GoalFocus.gainMuscle => '💪',
    GoalFocus.boostEnergy => '⚡',
    GoalFocus.improveNutrition => '🥗',
  };
}

extension ActivityLevelLabel on ActivityLevel {
  String get label => switch (this) {
    ActivityLevel.sedentary => l10n.activitySedentary,
    ActivityLevel.light => l10n.activityLight,
    ActivityLevel.moderate => l10n.activityModerate,
    ActivityLevel.active => l10n.activityActive,
  };

  String get description => switch (this) {
    ActivityLevel.sedentary => l10n.activitySedentaryDesc,
    ActivityLevel.light => l10n.activityLightDesc,
    ActivityLevel.moderate => l10n.activityModerateDesc,
    ActivityLevel.active => l10n.activityActiveDesc,
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
    DietType.classic => l10n.dietClassic,
    DietType.vegetarian => l10n.dietVegetarian,
    DietType.vegan => l10n.dietVegan,
    DietType.pescatarian => l10n.dietPescatarian,
    DietType.keto => l10n.dietKeto,
  };

  String get description => switch (this) {
    DietType.classic => l10n.dietClassicDesc,
    DietType.vegetarian => l10n.dietVegetarianDesc,
    DietType.vegan => l10n.dietVeganDesc,
    DietType.pescatarian => l10n.dietPescatarianDesc,
    DietType.keto => l10n.dietKetoDesc,
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
      ? l10n.kgValue(weightKg.toStringAsFixed(1))
      : l10n.lbValue((weightKg * _lbPerKg).toStringAsFixed(1));

  String get heightLabel {
    if (useMetric) return l10n.cmValue('$heightCm');
    final inches = (heightCm / _cmPerInch).round();
    return '${inches ~/ 12}′${inches % 12}″';
  }

  /// Dinner time as "8:30 PM".
  String get dinnerLabel => AppDates.timeLabel(dinnerHour, dinnerMinute);

  String get bmiCategory => switch (bmi) {
    < 18.5 => l10n.bmiUnderweight,
    < 25 => l10n.bmiHealthy,
    < 30 => l10n.bmiOverweight,
    _ => l10n.bmiObese,
  };
}
