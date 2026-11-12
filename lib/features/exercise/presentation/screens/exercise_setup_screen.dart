import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/l10n.dart';
import '../widgets/exercise_setup_view.dart';

/// "Workout setup", opened from the Exercise dashboard to change Home/Gym
/// or the extras; saving makes a new plan and returns to the dashboard.
class ExerciseSetupScreen extends StatelessWidget {
  const ExerciseSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.exerciseSetupTitle)),
      body: ExerciseSetupView(
        onDone: () {
          if (context.mounted) context.pop();
        },
      ),
    );
  }
}
