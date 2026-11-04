import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/calorie_calculator.dart';
import '../../../profile/data/models/user_profile.dart';
import '../../../profile/presentation/profile_labels.dart';
import 'dashboard_card.dart';
import 'goal_focus_chips.dart';
import 'profile_stat.dart';
import '../../../../l10n/l10n.dart';

/// The user's goal and body stats from onboarding.
class ProfileSummaryCard extends StatelessWidget {
  const ProfileSummaryCard({super.key, required this.profile});

  final UserProfile profile;

  String get _weeklyLabel {
    final kg = CalorieCalculator.weeklyChangeKg(profile.goal);
    if (kg == 0) return l10n.keepWeightSteady;
    final sign = kg > 0 ? '+' : '−';
    return l10n.kgPerWeek('$sign${kg.abs().toStringAsFixed(2)}');
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        children: [
          Row(
            children: [
              Text(profile.goal.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  profile.goal.label,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  _weeklyLabel,
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                ),
              ),
            ],
          ),
          if (profile.focuses.isNotEmpty) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: GoalFocusChips(focuses: profile.focuses),
            ),
          ],
          const SizedBox(height: 16),
          Divider(height: 1, color: AppColors.line),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ProfileStat(
                  value: profile.weightLabel,
                  label: l10n.weight,
                ),
              ),
              Expanded(
                child: ProfileStat(
                  value: profile.heightLabel,
                  label: l10n.height,
                ),
              ),
              Expanded(
                child: ProfileStat(value: '${profile.age}', label: l10n.age),
              ),
              Expanded(
                child: ProfileStat(
                  value: profile.bmi.toStringAsFixed(1),
                  label: l10n.bmi,
                  caption: profile.bmiCategory,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
