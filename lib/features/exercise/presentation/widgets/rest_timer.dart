import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../providers/workout_run_controller.dart';
import 'countdown_ring.dart';

/// The rest between sets: a countdown, "+15 s" and what's next.
class RestTimer extends StatelessWidget {
  const RestTimer({
    super.key,
    required this.secondsLeft,
    required this.totalSeconds,
    required this.nextSet,
    required this.totalSets,
    required this.onAddTime,
  });

  final int secondsLeft;
  final int totalSeconds;
  final int nextSet;
  final int totalSets;
  final VoidCallback onAddTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CountdownRing(
          secondsLeft: secondsLeft,
          totalSeconds: totalSeconds,
          caption: l10n.restLabel,
        ),
        const SizedBox(height: 8),
        TextButton(
          key: const ValueKey('add-rest'),
          onPressed: onAddTime,
          child: Text(
            l10n.addRestSeconds(WorkoutRunController.extraRestSeconds),
          ),
        ),
        Text(
          l10n.nextSetUp(nextSet, totalSets),
          style: TextStyle(fontSize: 14, color: AppColors.textGrey),
        ),
      ],
    );
  }
}
