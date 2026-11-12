import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/workout_record.dart';
import '../exercise_labels.dart';

/// "Not started", "In progress" or "Done", each with its own look.
class ExerciseStatusBadge extends StatelessWidget {
  const ExerciseStatusBadge({super.key, required this.status});

  final ExerciseStatus status;

  @override
  Widget build(BuildContext context) {
    final (icon, background, foreground) = switch (status) {
      ExerciseStatus.notStarted => (
        Icons.radio_button_unchecked_rounded,
        AppColors.track,
        AppColors.textGrey,
      ),
      ExerciseStatus.inProgress => (
        Icons.timelapse_rounded,
        AppColors.surface,
        AppColors.accent,
      ),
      ExerciseStatus.completed => (
        Icons.check_circle_rounded,
        AppColors.primary,
        AppColors.onPrimary,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: status == ExerciseStatus.inProgress
            ? Border.all(color: AppColors.accent)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              ExerciseLabels.status(status),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
