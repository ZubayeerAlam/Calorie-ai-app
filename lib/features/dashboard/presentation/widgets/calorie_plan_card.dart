import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/calorie_calculator.dart';
import '../../../profile/data/models/user_goals.dart';
import '../../../profile/presentation/profile_labels.dart';
import 'breakdown_row.dart';
import 'dashboard_card.dart';
import 'section_label.dart';
import '../../../../l10n/l10n.dart';

/// How the daily target was calculated from the saved profile
/// (BMR → activity → goal → target) and how it splits into macros.
class CaloriePlanCard extends StatelessWidget {
  const CaloriePlanCard({
    super.key,
    required this.breakdown,
    required this.goals,
    required this.customized,
  });

  final CalorieBreakdown breakdown;

  /// The targets in use (equal to the calculated ones unless [customized]).
  final UserGoals goals;
  final bool customized;

  static String _kcal(int value) => l10n.kcalValue('$value');

  static String _signedKcal(int value) => switch (value) {
    > 0 => l10n.kcalValue('+$value'),
    < 0 => l10n.kcalValue('−${value.abs()}'),
    _ => l10n.kcalValue('0'),
  };

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.yourCaloriePlan,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Text(
                'Mifflin-St Jeor',
                style: TextStyle(fontSize: 12, color: AppColors.textLight),
              ),
            ],
          ),
          const SizedBox(height: 8),
          BreakdownRow(
            emoji: '🛌',
            label: l10n.caloriesAtRest,
            value: _kcal(breakdown.bmr),
          ),
          BreakdownRow(
            emoji: '🏃',
            label: l10n.withActivity('${breakdown.activityMultiplier}'),
            detail: breakdown.activityLevel.label,
            value: _kcal(breakdown.tdee),
          ),
          BreakdownRow(
            emoji: breakdown.goal.emoji,
            label: l10n.goalAdjustment,
            detail: breakdown.goal.label,
            value: _signedKcal(breakdown.goalAdjustment),
          ),
          Divider(height: 16, color: AppColors.line),
          BreakdownRow(
            emoji: '🎯',
            label: l10n.recommendedDailyTarget,
            detail: breakdown.hitMinimum
                ? l10n.raisedToMinimum('${CalorieCalculator.minimumCalories}')
                : null,
            value: _kcal(breakdown.targetCalories),
            highlight: !customized,
          ),
          if (customized)
            BreakdownRow(
              emoji: '✏️',
              label: l10n.yourCustomTarget,
              detail: l10n.setOnAccount,
              value: _kcal(goals.dailyCalories),
              highlight: true,
            ),
          const SizedBox(height: 12),
          SectionLabel(l10n.macros),
          const SizedBox(height: 4),
          BreakdownRow(
            emoji: '🍞',
            label: l10n.carbs,
            detail: l10n.macroShare(
              _percent(CalorieCalculator.carbsRatio),
              '4',
            ),
            value: l10n.gramsValue('${goals.carbs}'),
          ),
          BreakdownRow(
            emoji: '🍗',
            label: l10n.protein,
            detail: l10n.macroShare(
              _percent(CalorieCalculator.proteinRatio),
              '4',
            ),
            value: l10n.gramsValue('${goals.protein}'),
          ),
          BreakdownRow(
            emoji: '🥑',
            label: l10n.fat,
            detail: l10n.macroShare(_percent(CalorieCalculator.fatRatio), '9'),
            value: l10n.gramsValue('${goals.fat}'),
          ),
        ],
      ),
    );
  }

  static String _percent(double ratio) => '${(ratio * 100).round()}%';
}
