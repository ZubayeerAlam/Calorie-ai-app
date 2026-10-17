import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../profile/data/models/user_profile.dart';
import '../../../profile/presentation/profile_labels.dart';
import '../../providers/onboarding_provider.dart';
import '../widgets/option_tile.dart';
import '../widgets/step_header.dart';

class GoalPage extends StatelessWidget {
  const GoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();
    return ListView(
      children: [
        const StepHeader(title: "What's your main goal?"),
        for (final goal in GoalType.values)
          OptionTile(
            title: goal.label,
            emoji: goal.emoji,
            selected: onboarding.goal == goal,
            onTap: () => onboarding.setGoal(goal),
          ),
      ],
    );
  }
}
