import 'dart:convert';

import '../../profile/data/models/user_profile.dart';
import 'catalog/exercise_catalog.dart';
import 'models/exercise.dart';
import 'models/exercise_settings.dart';

/// Everything a plan is made from: the profile and the Exercise settings.
class WorkoutPlanRequest {
  WorkoutPlanRequest({
    required this.profile,
    required this.settings,
    DateTime? now,
  }) : now = now ?? DateTime.now();

  final UserProfile profile;
  final ExerciseSettings settings;
  final DateTime now;

  /// Exercises the plan may use.
  late final List<Exercise> allowed = ExerciseCatalog.allowedFor(settings);

  late final Set<String> allowedIds = {for (final e in allowed) e.id};

  /// Workout days in a week.
  int get sessionsPerWeek =>
      ExerciseSettings.sessionsPerWeek(profile.activityLevel);

  int get age => profile.ageOn(now);

  /// Strength work aims for muscle gain (a weight-gain goal or the "Gain
  /// muscle" focus).
  bool get buildsMuscle =>
      profile.goal == GoalType.gain ||
      profile.focuses.contains(GoalFocus.gainMuscle);

  /// The inputs that shape a plan, as text. Saved with the plan, so a
  /// change (new weight, other goal, new settings) can be noticed.
  /// Weight is rounded to whole kg so small weigh-in changes don't count.
  String get inputsKey => jsonEncode({
    'gender': profile.gender.name,
    'age': age,
    'heightCm': profile.heightCm,
    'weightKg': profile.weightKg.round(),
    'goal': profile.goal.name,
    'focuses': [for (final f in profile.focuses) f.name]..sort(),
    'activity': profile.activityLevel.name,
    'settings': settings.toJson()
      ..update('homeEquipment', (v) => (v as List)..sort())
      ..update('limitations', (v) => (v as List)..sort()),
  });
}
