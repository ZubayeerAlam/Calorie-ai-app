import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/exercise_settings.dart';
import '../exercise_labels.dart';

/// A big tappable card for Home or Gym on the setup screen.
class EnvironmentOptionCard extends StatelessWidget {
  const EnvironmentOptionCard({
    super.key,
    required this.environment,
    required this.selected,
    required this.onTap,
  });

  final WorkoutEnvironment environment;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon => switch (environment) {
    WorkoutEnvironment.home => Icons.home_rounded,
    WorkoutEnvironment.gym => Icons.fitness_center_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected
            ? AppColors.primaryLight.withValues(alpha: 0.45)
            : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected ? AppColors.accent : AppColors.chipBorder,
            width: selected ? 2 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_icon, color: AppColors.onPrimary, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ExerciseLabels.environment(environment),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ExerciseLabels.environmentDescription(environment),
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected ? AppColors.accent : AppColors.textLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
