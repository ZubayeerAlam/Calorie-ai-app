import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/calorie_calculator.dart';
import '../../../profile/data/models/user_goals.dart';
import '../../../profile/presentation/profile_labels.dart';
import 'breakdown_row.dart';
import 'dashboard_card.dart';
import 'section_label.dart';

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

  static String _kcal(int value) => '$value kcal';

  static String _signedKcal(int value) => switch (value) {
    > 0 => '+$value kcal',
    < 0 => '−${value.abs()} kcal',
    _ => '0 kcal',
  };

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Your calorie plan',
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
            label: 'Calories at rest (BMR)',
            value: _kcal(breakdown.bmr),
          ),
          BreakdownRow(
            emoji: '🏃',
            label: 'With activity × ${breakdown.activityMultiplier}',
            detail: breakdown.activityLevel.label,
            value: _kcal(breakdown.tdee),
          ),
          BreakdownRow(
            emoji: breakdown.goal.emoji,
            label: 'Goal adjustment',
            detail: breakdown.goal.label,
            value: _signedKcal(breakdown.goalAdjustment),
          ),
          const Divider(height: 16, color: AppColors.line),
          BreakdownRow(
            emoji: '🎯',
            label: 'Recommended daily target',
            detail: breakdown.hitMinimum
                ? 'Raised to the ${CalorieCalculator.minimumCalories} kcal '
                      'minimum'
                : null,
            value: _kcal(breakdown.targetCalories),
            highlight: !customized,
          ),
          if (customized)
            BreakdownRow(
              emoji: '✏️',
              label: 'Your custom target',
              detail: 'Set on Account',
              value: _kcal(goals.dailyCalories),
              highlight: true,
            ),
          const SizedBox(height: 12),
          const SectionLabel('Macros'),
          const SizedBox(height: 4),
          BreakdownRow(
            emoji: '🍞',
            label: 'Carbs',
            detail: '${_percent(CalorieCalculator.carbsRatio)} · 4 kcal/g',
            value: '${goals.carbs} g',
          ),
          BreakdownRow(
            emoji: '🍗',
            label: 'Protein',
            detail: '${_percent(CalorieCalculator.proteinRatio)} · 4 kcal/g',
            value: '${goals.protein} g',
          ),
          BreakdownRow(
            emoji: '🥑',
            label: 'Fat',
            detail: '${_percent(CalorieCalculator.fatRatio)} · 9 kcal/g',
            value: '${goals.fat} g',
          ),
        ],
      ),
    );
  }

  static String _percent(double ratio) => '${(ratio * 100).round()}%';
}
