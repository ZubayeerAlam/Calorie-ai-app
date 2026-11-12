import 'package:cal_ai_app/features/exercise/data/catalog/exercise_catalog.dart';
import 'package:cal_ai_app/features/exercise/data/exercise_estimate.dart';
import 'package:cal_ai_app/features/exercise/data/models/workout_plan.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final pushUp = ExerciseCatalog.byId('push_up')!; // MET 3.8, 3 s per rep
  final plank = ExerciseCatalog.byId('plank')!; // MET 3.0, timed

  test('a set lasts reps × seconds per rep, or its duration', () {
    expect(ExerciseEstimate.setSeconds(pushUp, reps: 12), 36);
    expect(ExerciseEstimate.setSeconds(plank, duration: 30), 30);
  });

  test('kcal are net of resting: (MET − 1) × kg × hours', () {
    // 3 × 12 push-ups = 108 s; 2.8 × 72 kg × 0.03 h.
    expect(
      ExerciseEstimate.netKcal(pushUp, sets: 3, reps: 12, weightKg: 72),
      closeTo(6.048, 0.001),
    );
    // 3 × 30 s plank = 90 s; 2.0 × 72 kg × 0.025 h.
    expect(
      ExerciseEstimate.netKcal(plank, sets: 3, duration: 30, weightKg: 72),
      closeTo(3.6, 0.001),
    );
    // Heavier people burn more for the same work; no sets, no kcal.
    expect(
      ExerciseEstimate.netKcal(pushUp, sets: 3, reps: 12, weightKg: 90),
      greaterThan(
        ExerciseEstimate.netKcal(pushUp, sets: 3, reps: 12, weightKg: 72),
      ),
    );
    expect(
      ExerciseEstimate.netKcal(pushUp, sets: 0, reps: 12, weightKg: 72),
      0,
    );
  });

  test('a planned exercise takes its sets plus the rests between them', () {
    const planned = PlannedExercise(
      exerciseId: 'push_up',
      sets: 3,
      reps: 12,
      restSeconds: 60,
    );
    expect(ExerciseEstimate.plannedSeconds(pushUp, planned), 3 * 36 + 2 * 60);
    expect(
      ExerciseEstimate.plannedKcal(pushUp, planned, weightKg: 72),
      closeTo(6.048, 0.001),
    );
  });

  test('shown kcal: whole numbers below 10, then to the nearest 5', () {
    expect(ExerciseEstimate.displayKcal(0), 0);
    expect(ExerciseEstimate.displayKcal(6.048), 6);
    expect(ExerciseEstimate.displayKcal(12.4), 10);
    expect(ExerciseEstimate.displayKcal(13), 15);
    expect(ExerciseEstimate.displayKcal(118), 120);
  });
}
