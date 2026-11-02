import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/tracker_stats.dart';
import 'tracker_card.dart';

/// Average protein, carbs and fat per logged day against the targets.
class MacroAveragesCard extends StatelessWidget {
  const MacroAveragesCard({super.key, required this.stats});

  final TrackerStats stats;

  @override
  Widget build(BuildContext context) {
    final goals = stats.goals;
    return TrackerCard(
      title: 'Macros',
      subtitle: 'Daily average on logged days',
      child: Column(
        children: [
          _MacroBar(
            label: 'Protein',
            value: stats.averageProtein,
            target: goals.protein,
            color: const Color(0xFFE57373),
          ),
          const SizedBox(height: 14),
          _MacroBar(
            label: 'Carbs',
            value: stats.averageCarbs,
            target: goals.carbs,
            color: const Color(0xFFFFB74D),
          ),
          const SizedBox(height: 14),
          _MacroBar(
            label: 'Fat',
            value: stats.averageFat,
            target: goals.fat,
            color: const Color(0xFF64B5F6),
          ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  const _MacroBar({
    required this.label,
    required this.value,
    required this.target,
    required this.color,
  });

  final String label;
  final double value;
  final int target;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppColors.textDark),
            ),
            const Spacer(),
            Text(
              '${value.round()} / $target g',
              style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: target <= 0 ? 0 : (value / target).clamp(0.0, 1.0),
            minHeight: 8,
            color: color,
            backgroundColor: AppColors.track,
          ),
        ),
      ],
    );
  }
}
