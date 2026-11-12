import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/empty_state.dart';

/// Exercise tab. For now a placeholder; the setup (Home or Gym) and the
/// AI workout dashboard are added in feature 23, phase 4.
class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabExercise)),
      body: EmptyState(
        icon: Icons.fitness_center_rounded,
        message: l10n.exercisePlaceholder,
      ),
    );
  }
}
