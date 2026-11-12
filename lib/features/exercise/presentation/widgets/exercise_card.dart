import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../data/catalog/exercise_texts.dart';
import '../../data/exercise_estimate.dart';
import '../../data/models/workout_plan.dart';
import '../../data/models/workout_record.dart';
import '../exercise_labels.dart';
import 'exercise_status_badge.dart';
import 'exercise_thumbnail.dart';

/// One exercise of the day: picture, name, sets × reps (or time), the
/// estimated kcal and where it stands. Completed cards turn green.
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.planned,
    required this.status,
    required this.kcal,
    this.onTap,
  });

  final PlannedExercise planned;
  final ExerciseStatus status;

  /// Estimated net kcal when done in full.
  final double kcal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final name = ExerciseTexts.nameOf(planned.exerciseId);
    final detail = ExerciseLabels.setsTimesTarget(planned);
    final kcalText = l10n.aboutKcal(ExerciseEstimate.displayKcal(kcal));
    final done = status == ExerciseStatus.completed;
    return Semantics(
      button: onTap != null,
      label: l10n.exerciseCardLabel(
        name,
        '$detail, $kcalText',
        ExerciseLabels.status(status),
      ),
      excludeSemantics: true,
      child: Material(
        color: done
            ? AppColors.primaryLight.withValues(alpha: 0.45)
            : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: switch (status) {
            ExerciseStatus.inProgress => BorderSide(
              color: AppColors.accent,
              width: 2,
            ),
            ExerciseStatus.completed => BorderSide(color: AppColors.primary),
            ExerciseStatus.notStarted => BorderSide(
              color: AppColors.chipBorder,
            ),
          },
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExerciseThumbnail(exerciseId: planned.exerciseId),
                const SizedBox(height: 8),
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: TextStyle(fontSize: 13, color: AppColors.textDark),
                ),
                Text(
                  kcalText,
                  style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
                const Spacer(),
                const SizedBox(height: 8),
                ExerciseStatusBadge(status: status),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
