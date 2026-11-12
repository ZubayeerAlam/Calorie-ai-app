import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import 'primary_button.dart';

/// Shown when every set is done: what was done and where to go next.
class WorkoutDoneView extends StatelessWidget {
  const WorkoutDoneView({
    super.key,
    required this.sets,
    required this.kcal,
    required this.workoutComplete,
    required this.onNext,
    required this.onBack,
  });

  final int sets;
  final int kcal;

  /// Every exercise of the day is done.
  final bool workoutComplete;

  /// Opens the next exercise; null when there is none.
  final VoidCallback? onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          workoutComplete
              ? Icons.emoji_events_rounded
              : Icons.check_circle_rounded,
          size: 64,
          color: AppColors.accent,
        ),
        const SizedBox(height: 12),
        Text(
          workoutComplete
              ? l10n.workoutCompleteTitle
              : l10n.exerciseCompleteTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.exerciseCompleteBody(sets, kcal),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: AppColors.textGrey),
        ),
        const SizedBox(height: 24),
        if (onNext != null) ...[
          PrimaryButton(
            key: const ValueKey('next-exercise'),
            label: l10n.nextExercise,
            onPressed: onNext,
          ),
          const SizedBox(height: 8),
        ],
        TextButton(
          key: const ValueKey('back-to-plan'),
          onPressed: onBack,
          child: Text(l10n.backToPlan),
        ),
      ],
    );
  }
}
