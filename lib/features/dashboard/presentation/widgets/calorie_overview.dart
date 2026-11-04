import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/progress_ring.dart';
import 'stat_column.dart';
import '../../../../l10n/l10n.dart';

/// Eaten | big "kcal left" ring | Burned.
///
/// Calories left = target − eaten + burned. The ring fills with the share
/// of the (target + burned) budget that has been eaten.
class CalorieOverview extends StatelessWidget {
  const CalorieOverview({
    super.key,
    required this.target,
    required this.eaten,
    required this.burned,
  });

  final int target;
  final int eaten;
  final int burned;

  @override
  Widget build(BuildContext context) {
    final budget = target + burned;
    final left = budget - eaten;
    final isOver = left < 0;

    return Row(
      children: [
        Expanded(
          child: StatColumn(emoji: '🥗', label: l10n.eaten, value: eaten),
        ),
        ProgressRing(
          value: budget == 0 ? 0 : eaten / budget,
          size: 132,
          strokeWidth: 9,
          color: isOver ? AppColors.badge : AppColors.primary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                child: Text(
                  '${left.abs()}',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Text(
                isOver ? l10n.kcalOver : l10n.kcalLeft,
                style: TextStyle(fontSize: 13, color: AppColors.textGrey),
              ),
            ],
          ),
        ),
        Expanded(
          child: StatColumn(emoji: '🔥', label: l10n.burned, value: burned),
        ),
      ],
    );
  }
}
