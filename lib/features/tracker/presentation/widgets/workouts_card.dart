import 'package:flutter/material.dart';

import '../../../../core/utils/number_format.dart';
import '../../../../l10n/l10n.dart';
import '../../../exercise/presentation/widgets/workout_stat.dart';
import '../../data/tracker_stats.dart';
import 'tracker_card.dart';

/// Workouts done in the Exercise tab over the period: how many, active
/// minutes and estimated kcal.
class WorkoutsCard extends StatelessWidget {
  const WorkoutsCard({super.key, required this.stats});

  final TrackerStats stats;

  @override
  Widget build(BuildContext context) {
    return TrackerCard(
      title: l10n.workoutsTitle,
      subtitle: stats.totalWorkouts == 0
          ? l10n.noWorkoutsYet
          : l10n.workoutsSummary(stats.workoutDays),
      child: Row(
        children: [
          Expanded(
            child: WorkoutStat(
              value: AppNumbers.thousands(stats.totalWorkouts),
              label: l10n.statWorkouts,
            ),
          ),
          Expanded(
            child: WorkoutStat(
              value: AppNumbers.thousands(stats.workoutMinutes),
              label: l10n.statActiveMinutes,
            ),
          ),
          Expanded(
            child: WorkoutStat(
              value: '≈ ${AppNumbers.thousands(stats.workoutKcal)}',
              label: l10n.statKcal,
            ),
          ),
        ],
      ),
    );
  }
}
