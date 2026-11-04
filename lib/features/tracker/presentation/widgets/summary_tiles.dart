import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/number_format.dart';
import '../../data/tracker_stats.dart';
import '../../../../l10n/l10n.dart';

/// Streak, average calories and days on target, side by side.
class SummaryTiles extends StatelessWidget {
  const SummaryTiles({super.key, required this.stats});

  final TrackerStats stats;

  @override
  Widget build(BuildContext context) {
    final logged = stats.loggedDays.isNotEmpty;
    return Row(
      children: [
        _Tile(
          key: const ValueKey('streak-tile'),
          value: '🔥 ${stats.streak}',
          label: l10n.dayStreak,
        ),
        const SizedBox(width: 10),
        _Tile(
          value: logged ? AppNumbers.thousands(stats.averageCalories) : '–',
          label: l10n.avgKcalDay,
        ),
        const SizedBox(width: 10),
        _Tile(
          value: '${stats.daysOnTarget}/${stats.period.days}',
          label: l10n.daysOnTarget,
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }
}
