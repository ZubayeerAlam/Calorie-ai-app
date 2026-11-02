import 'package:flutter/material.dart';

import '../../../../core/utils/number_format.dart';
import '../../data/tracker_stats.dart';
import 'bar_chart.dart';
import 'chart_labels.dart';
import 'tracker_card.dart';

/// Steps per day.
class StepsCard extends StatelessWidget {
  const StepsCard({super.key, required this.stats});

  final TrackerStats stats;

  @override
  Widget build(BuildContext context) {
    final days = stats.days;
    return TrackerCard(
      title: 'Steps',
      subtitle: stats.totalSteps == 0
          ? 'No steps counted yet'
          : 'Avg ${AppNumbers.thousands(stats.averageSteps)} a day · '
                '${AppNumbers.thousands(stats.totalSteps)} total',
      child: BarChart(
        values: [for (final d in days) d.steps],
        labels: ChartLabels.forDays(days.map((d) => d.date).toList()),
        height: 100,
      ),
    );
  }
}
