import 'dart:math' as math;

import 'models/exercise.dart';
import 'models/workout_plan.dart';

/// Time and calorie estimates for exercises.
///
/// Calories use the MET method, counting only the calories **above
/// resting** (net = (MET − 1) × body weight in kg × active hours). The
/// daily calorie target already includes resting burn, so this avoids
/// counting it twice. Only active time counts: rest between sets is left
/// out. Age and gender are not part of the MET method.
///
/// These are rough estimates (often ±30 % or more): real burn depends on
/// effort, pace, fitness and body composition.
class ExerciseEstimate {
  ExerciseEstimate._();

  /// Seconds of work in one set.
  static double setSeconds(Exercise exercise, {int? reps, int? duration}) =>
      exercise.isTimed
      ? (duration ?? 0).toDouble()
      : (reps ?? 0) * exercise.secondsPerRep;

  /// Net kcal for [sets] sets.
  static double netKcal(
    Exercise exercise, {
    required int sets,
    int? reps,
    int? duration,
    required double weightKg,
  }) {
    final hours =
        sets * setSeconds(exercise, reps: reps, duration: duration) / 3600;
    return math.max(0, exercise.met - 1) * weightKg * hours;
  }

  /// Net kcal for a planned exercise done in full.
  static double plannedKcal(
    Exercise exercise,
    PlannedExercise planned, {
    required double weightKg,
  }) => netKcal(
    exercise,
    sets: planned.sets,
    reps: planned.reps,
    duration: planned.durationSeconds,
    weightKg: weightKg,
  );

  /// Seconds for a planned exercise: all sets plus the rests between them.
  static double plannedSeconds(Exercise exercise, PlannedExercise planned) =>
      planned.sets *
          setSeconds(
            exercise,
            reps: planned.reps,
            duration: planned.durationSeconds,
          ) +
      math.max(0, planned.sets - 1) * planned.restSeconds;

  /// A kcal estimate as shown: whole kcal below 10, then to the nearest 5
  /// (so it doesn't look more precise than it is).
  static int displayKcal(double kcal) {
    if (kcal < 10) return kcal.round();
    return (kcal / 5).round() * 5;
  }
}
