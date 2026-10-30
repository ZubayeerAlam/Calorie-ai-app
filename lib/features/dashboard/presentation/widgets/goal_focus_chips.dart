import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../profile/data/models/user_profile.dart';
import '../../../profile/presentation/profile_labels.dart';

/// The user's extra goals (Gain muscle, Boost energy, …) as small chips.
class GoalFocusChips extends StatelessWidget {
  const GoalFocusChips({super.key, required this.focuses});

  final List<GoalFocus> focuses;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final focus in focuses)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${focus.emoji} ${focus.label}',
              style: const TextStyle(fontSize: 13, color: AppColors.textDark),
            ),
          ),
      ],
    );
  }
}
