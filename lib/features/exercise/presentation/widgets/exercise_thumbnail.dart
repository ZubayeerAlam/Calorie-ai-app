import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/catalog/exercise_catalog.dart';
import '../../data/models/exercise.dart';

/// A picture for an exercise card: an icon for its movement type on a
/// soft background. (Phase 5 replaces it with the demo's first pose.)
class ExerciseThumbnail extends StatelessWidget {
  const ExerciseThumbnail({super.key, required this.exerciseId});

  final String exerciseId;

  IconData get _icon => switch (ExerciseCatalog.byId(exerciseId)?.pattern) {
    MovementPattern.push => Icons.fitness_center_rounded,
    MovementPattern.pull => Icons.rowing_rounded,
    MovementPattern.legs => Icons.directions_walk_rounded,
    MovementPattern.core => Icons.self_improvement_rounded,
    MovementPattern.cardio => Icons.directions_run_rounded,
    null => Icons.sports_gymnastics_rounded,
  };

  @override
  Widget build(BuildContext context) {
    // Decorative: the card says the exercise's name.
    return ExcludeSemantics(
      child: AspectRatio(
        aspectRatio: 1.6,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Icon(_icon, size: 36, color: AppColors.accent)),
        ),
      ),
    );
  }
}
