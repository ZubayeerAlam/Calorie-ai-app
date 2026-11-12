import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../data/models/workout_plan.dart';
import '../exercise_labels.dart';
import 'workout_stat.dart';

/// Sets, reps (or time) and rest for a planned exercise.
class ExerciseStatRow extends StatelessWidget {
  const ExerciseStatRow({super.key, required this.planned});

  final PlannedExercise planned;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: WorkoutStat(value: '${planned.sets}', label: l10n.statSets),
          ),
          Expanded(
            child: WorkoutStat(
              value: planned.durationSeconds == null
                  ? '${planned.reps ?? 0}'
                  : ExerciseLabels.target(planned),
              label: planned.durationSeconds == null
                  ? l10n.statReps
                  : l10n.statHold,
            ),
          ),
          Expanded(
            child: WorkoutStat(
              value: l10n.secondsShort(planned.restSeconds),
              label: l10n.statRest,
            ),
          ),
        ],
      ),
    );
  }
}
