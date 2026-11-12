import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../providers/exercise_provider.dart';
import '../widgets/exercise_dashboard.dart';
import '../widgets/exercise_setup_view.dart';

/// Exercise tab: the Home/Gym choice the first time, then the plan.
class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  Future<void> _confirmRegenerate(BuildContext context) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.regenerateTitle),
        content: Text(l10n.regenerateBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            key: const ValueKey('confirm-regenerate'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.regeneratePlan),
          ),
        ],
      ),
    );
    if (yes == true && context.mounted) {
      await context.read<ExerciseProvider>().generate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercise = context.watch<ExerciseProvider>();
    final setUp = exercise.isSetUp;
    final busy = exercise.generating;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabExercise),
        actions: [
          if (setUp) ...[
            IconButton(
              key: const ValueKey('regenerate-plan'),
              tooltip: l10n.regeneratePlan,
              onPressed: busy ? null : () => _confirmRegenerate(context),
              icon: const Icon(Icons.refresh_rounded),
            ),
            IconButton(
              key: const ValueKey('workout-setup'),
              tooltip: l10n.workoutSetupTooltip,
              onPressed: busy
                  ? null
                  : () => context.push(AppRoutes.exerciseSetup),
              icon: const Icon(Icons.tune_rounded),
            ),
          ],
        ],
        bottom: setUp && busy
            ? const PreferredSize(
                preferredSize: Size.fromHeight(3),
                child: LinearProgressIndicator(minHeight: 3),
              )
            : null,
      ),
      body: switch ((setUp, busy)) {
        (true, _) => ExerciseDashboard(
          onOpenExercise: (id) =>
              context.push(AppRoutes.exerciseDetailsLocation(id)),
        ),
        (false, true) => const _CreatingPlan(),
        (false, false) => const ExerciseSetupView(),
      },
    );
  }
}

class _CreatingPlan extends StatelessWidget {
  const _CreatingPlan();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            l10n.creatingPlan,
            style: TextStyle(fontSize: 15, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
