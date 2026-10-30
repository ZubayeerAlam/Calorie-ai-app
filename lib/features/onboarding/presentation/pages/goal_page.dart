import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../profile/data/models/user_profile.dart';
import '../../../profile/presentation/profile_labels.dart';
import '../../providers/onboarding_provider.dart';
import '../widgets/option_tile.dart';
import '../widgets/step_header.dart';

/// One row on the goal step: either a weight goal (only one can be
/// selected) or a focus goal (any number can be selected).
class _GoalOption {
  const _GoalOption({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  factory _GoalOption.weight(GoalType goal) => _GoalOption(
    label: goal.label,
    emoji: goal.emoji,
    isSelected: (o) => o.goal == goal,
    onTap: (o) => o.setGoal(goal),
  );

  factory _GoalOption.focus(GoalFocus focus) => _GoalOption(
    label: focus.label,
    emoji: focus.emoji,
    isSelected: (o) => o.focuses.contains(focus),
    onTap: (o) => o.toggleFocus(focus),
  );

  final String label;
  final String emoji;
  final bool Function(OnboardingProvider) isSelected;
  final void Function(OnboardingProvider) onTap;
}

class GoalPage extends StatelessWidget {
  const GoalPage({super.key});

  // Same order as the design.
  static final List<_GoalOption> _options = [
    _GoalOption.weight(GoalType.lose),
    _GoalOption.focus(GoalFocus.gainMuscle),
    _GoalOption.weight(GoalType.maintain),
    _GoalOption.focus(GoalFocus.boostEnergy),
    _GoalOption.focus(GoalFocus.improveNutrition),
    _GoalOption.weight(GoalType.gain),
  ];

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();
    return ListView(
      children: [
        const StepHeader(title: "What's your main goal?"),
        for (final option in _options)
          OptionTile(
            title: option.label,
            emoji: option.emoji,
            selected: option.isSelected(onboarding),
            onTap: () => option.onTap(onboarding),
          ),
      ],
    );
  }
}
