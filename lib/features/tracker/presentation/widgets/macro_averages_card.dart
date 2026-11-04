import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/tracker_stats.dart';
import 'tracker_card.dart';
import '../../../../l10n/l10n.dart';

/// Average protein, carbs and fat per logged day against the targets.
class MacroAveragesCard extends StatelessWidget {
  const MacroAveragesCard({super.key, required this.stats});

  final TrackerStats stats;

  @override
  Widget build(BuildContext context) {
    final goals = stats.goals;
    return TrackerCard(
      title: l10n.macros,
      subtitle: l10n.dailyAverageLogged,
      child: Column(
        children: [
          _MacroBar(
            label: l10n.protein,
            value: stats.averageProtein,
            target: goals.protein,
            color: const Color(0xFFE57373),
          ),
          const SizedBox(height: 14),
          _MacroBar(
            label: l10n.carbs,
            value: stats.averageCarbs,
            target: goals.carbs,
            color: const Color(0xFFFFB74D),
          ),
          const SizedBox(height: 14),
          _MacroBar(
            label: l10n.fat,
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
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, color: AppColors.textDark),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              l10n.gramsOfTarget('${value.round()}', '$target'),
              style: TextStyle(fontSize: 14, color: AppColors.textGrey),
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
