import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/number_format.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/progress_ring.dart';
import 'workout_stat.dart';

/// The day's progress: a ring with done / total, then exercises, done,
/// left, estimated time and estimated kcal.
class WorkoutProgressHeader extends StatelessWidget {
  const WorkoutProgressHeader({
    super.key,
    required this.title,
    required this.total,
    required this.done,
    required this.minutes,
    required this.kcal,
  });

  final String title;
  final int total;
  final int done;
  final int minutes;
  final int kcal;

  @override
  Widget build(BuildContext context) {
    final left = total - done;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ProgressRing(
                value: total == 0 ? 0 : done / total,
                size: 64,
                strokeWidth: 8,
                child: Text(
                  '$done/$total',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.progressDone(done, total),
                      style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: AppColors.line),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final (value, label) in [
                (AppNumbers.thousands(total), l10n.statExercises),
                (AppNumbers.thousands(done), l10n.statDone),
                (AppNumbers.thousands(left), l10n.statLeft),
                ('≈ $minutes', l10n.statTime),
                ('≈ ${AppNumbers.thousands(kcal)}', l10n.statKcal),
              ])
                Expanded(
                  child: WorkoutStat(value: value, label: label),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
