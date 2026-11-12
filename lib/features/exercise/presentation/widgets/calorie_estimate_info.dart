import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/number_format.dart';
import '../../../../l10n/l10n.dart';
import '../../data/exercise_estimate.dart';

/// "≈ 6 kcal for this exercise", with a button that explains how the
/// estimate is made and how uncertain it is.
class CalorieEstimateInfo extends StatelessWidget {
  const CalorieEstimateInfo({
    super.key,
    required this.kcal,
    required this.met,
    required this.weightKg,
    required this.activeSeconds,
    this.useMetric = true,
  });

  final double kcal;
  final double met;
  final double weightKg;
  final double activeSeconds;
  final bool useMetric;

  static String durationText(double seconds) {
    final total = seconds.round();
    if (total < 60) return l10n.secondsShort(total);
    final m = total ~/ 60;
    final s = total % 60;
    return s == 0 ? l10n.minutesShort(m) : l10n.durationMinSec(m, s);
  }

  void _explain(BuildContext context) {
    final weight = useMetric
        ? '${AppNumbers.oneDecimal(weightKg)} kg'
        : '${AppNumbers.oneDecimal(weightKg * 2.20462)} lb';
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.kcalInfoTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              for (final text in [
                l10n.kcalInfoMethod(
                  AppNumbers.oneDecimal(met),
                  weight,
                  durationText(activeSeconds),
                ),
                l10n.kcalInfoUncertainty,
                l10n.kcalInfoFat,
              ]) ...[
                Text(
                  text,
                  style: TextStyle(fontSize: 14.5, color: AppColors.textDark),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.local_fire_department_rounded, color: AppColors.accent),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            l10n.kcalForExercise(ExerciseEstimate.displayKcal(kcal)),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
        IconButton(
          key: const ValueKey('kcal-info'),
          tooltip: l10n.kcalInfoTooltip,
          onPressed: () => _explain(context),
          icon: Icon(Icons.info_outline_rounded, color: AppColors.textGrey),
        ),
      ],
    );
  }
}
