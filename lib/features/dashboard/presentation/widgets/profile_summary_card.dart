import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/calorie_calculator.dart';
import '../../../profile/data/models/user_profile.dart';
import '../../../profile/presentation/profile_labels.dart';
import 'dashboard_card.dart';
import 'goal_focus_chips.dart';
import 'profile_stat.dart';

/// The user's goal and body stats from onboarding.
class ProfileSummaryCard extends StatelessWidget {
  const ProfileSummaryCard({super.key, required this.profile});

  final UserProfile profile;

  String get _weeklyLabel {
    final kg = CalorieCalculator.weeklyChangeKg(profile.goal);
    if (kg == 0) return 'Keep your weight steady';
    final sign = kg > 0 ? '+' : '−';
    return '$sign${kg.abs().toStringAsFixed(2)} kg / week';
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
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Text(
                _weeklyLabel,
                style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
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
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ProfileStat(value: profile.weightLabel, label: 'Weight'),
              ),
              Expanded(
                child: ProfileStat(value: profile.heightLabel, label: 'Height'),
              ),
              Expanded(
                child: ProfileStat(value: '${profile.age}', label: 'Age'),
              ),
              Expanded(
                child: ProfileStat(
                  value: profile.bmi.toStringAsFixed(1),
                  label: 'BMI',
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
