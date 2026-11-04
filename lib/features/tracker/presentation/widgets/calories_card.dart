import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/number_format.dart';
import '../../data/tracker_stats.dart';
import 'bar_chart.dart';
import 'chart_labels.dart';
import 'tracker_card.dart';
import '../../../../l10n/l10n.dart';

/// Calories eaten per day against the target line.
class CaloriesCard extends StatelessWidget {
  const CaloriesCard({super.key, required this.stats});

  static const Color over = Color(0xFFF2994A);

  final TrackerStats stats;

  Color _colorFor(DaySummary day) {
    if (stats.isOnTarget(day)) return AppColors.primary;
    return day.calories > stats.goals.dailyCalories
        ? over
        : AppColors.primaryLight;
  }

  @override
  Widget build(BuildContext context) {
    final days = stats.days;
    return TrackerCard(
      title: l10n.calories,
      subtitle: l10n.targetDashedLine(
        AppNumbers.thousands(stats.goals.dailyCalories),
      ),
      child: Column(
        children: [
          BarChart(
            values: [for (final d in days) d.calories],
            labels: ChartLabels.forDays(days.map((d) => d.date).toList()),
            target: stats.goals.dailyCalories,
            colorFor: (i) => _colorFor(days[i]),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 6,
            children: [
              _Legend(color: AppColors.primary, label: l10n.onTarget),
              _Legend(color: AppColors.primaryLight, label: l10n.under),
              _Legend(color: over, label: l10n.over),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
      ],
    );
  }
}
