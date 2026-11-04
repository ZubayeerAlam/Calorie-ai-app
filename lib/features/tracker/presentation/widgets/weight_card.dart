import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/weight_entry.dart';
import 'line_chart.dart';
import 'tracker_card.dart';
import 'weight_units.dart';
import '../../../../l10n/l10n.dart';

/// Current weight, its change over the period, and the trend line.
class WeightCard extends StatelessWidget {
  const WeightCard({
    super.key,
    required this.currentKg,
    required this.weights,
    required this.change,
    required this.units,
    required this.onLogWeight,
  });

  final double currentKg;

  /// Weigh-ins inside the period, oldest first.
  final List<WeightEntry> weights;
  final double? change;
  final WeightUnits units;
  final VoidCallback onLogWeight;

  @override
  Widget build(BuildContext context) {
    return TrackerCard(
      title: l10n.weight,
      subtitle: change == null
          ? l10n.logWeightTrend
          : l10n.changeInPeriod(units.formatChange(change!)),
      trailing: TextButton.icon(
        key: const ValueKey('log-weight'),
        onPressed: onLogWeight,
        icon: const Icon(Icons.add_rounded, size: 18),
        label: Text(l10n.log),
        style: TextButton.styleFrom(foregroundColor: AppColors.textDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            units.format(currentKg),
            key: const ValueKey('current-weight'),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          if (weights.length >= 2) ...[
            const SizedBox(height: 12),
            LineChart(
              points: [
                for (final w in weights)
                  (date: w.date, value: units.fromKg(w.weightKg)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
