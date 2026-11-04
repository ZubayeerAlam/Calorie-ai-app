import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/number_format.dart';
import '../../data/tracker_stats.dart';
import 'tracker_card.dart';
import '../../../../l10n/l10n.dart';

/// The period's logged days, newest first. Tapping a day opens it on Home.
class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.stats, required this.onOpenDay});

  final TrackerStats stats;
  final ValueChanged<DateTime> onOpenDay;

  @override
  Widget build(BuildContext context) {
    final days = stats.loggedDays.reversed.toList();
    return TrackerCard(
      title: l10n.history,
      subtitle: days.isEmpty ? l10n.nothingInPeriod : l10n.tapDayToOpen,
      child: Column(
        children: [
          for (final day in days)
            _DayRow(
              day: day,
              target: stats.goals.dailyCalories,
              onTarget: stats.isOnTarget(day),
              onTap: () => onOpenDay(day.date),
            ),
        ],
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.day,
    required this.target,
    required this.onTarget,
    required this.onTap,
  });

  final DaySummary day;
  final int target;
  final bool onTarget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ValueKey('history-${AppDates.key(day.date)}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              onTarget
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked,
              size: 20,
              color: onTarget ? AppColors.primary : AppColors.tick,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppDates.dayLabel(day.date),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    l10n.historyMacros(
                      '${day.protein.round()}',
                      '${day.carbs.round()}',
                      '${day.fat.round()}',
                    ),
                    style: TextStyle(fontSize: 12, color: AppColors.textLight),
                  ),
                ],
              ),
            ),
            Text(
              l10n.eatenOfTarget(
                AppNumbers.thousands(day.calories),
                AppNumbers.thousands(target),
              ),
              style: TextStyle(fontSize: 14, color: AppColors.textGrey),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.tick),
          ],
        ),
      ),
    );
  }
}
