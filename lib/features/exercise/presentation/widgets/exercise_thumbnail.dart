import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/catalog/exercise_demos.dart';
import '../../data/models/exercise_demo.dart';
import 'exercise_demo_view.dart';
import 'exercise_figure_painter.dart';

/// A still picture for an exercise card: the demo's starting pose.
class ExerciseThumbnail extends StatelessWidget {
  const ExerciseThumbnail({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  Widget build(BuildContext context) {
    final demo = ExerciseDemos.of(exerciseId);
    // Decorative: the card says the exercise's name.
    return ExcludeSemantics(
      child: AspectRatio(
        aspectRatio: 1.4,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: demo == null
                ? Icon(
                    Icons.sports_gymnastics_rounded,
                    size: 36,
                    color: AppColors.accent,
                  )
                : CustomPaint(
                    painter: ExerciseFigurePainter(
                      layout: DemoLayout(demo),
                      pose: demo.poses.first,
                      colors: figureColors(),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
