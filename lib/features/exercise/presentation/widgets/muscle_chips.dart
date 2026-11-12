import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/catalog/exercise_texts.dart';
import '../../data/models/exercise.dart';

/// The muscles an exercise works, main ones first.
class MuscleChips extends StatelessWidget {
  const MuscleChips({super.key, required this.muscles});

  final List<MuscleGroup> muscles;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final (i, muscle) in muscles.indexed)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: i == 0 ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: i == 0 ? AppColors.primary : AppColors.chipBorder,
              ),
            ),
            child: Text(
              ExerciseTexts.muscle(muscle),
              style: TextStyle(
                fontSize: 13,
                fontWeight: i == 0 ? FontWeight.w600 : FontWeight.w400,
                color: i == 0 ? AppColors.onPrimary : AppColors.textDark,
              ),
            ),
          ),
      ],
    );
  }
}
