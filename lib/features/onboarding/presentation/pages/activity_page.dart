import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../profile/data/models/user_profile.dart';
import '../../../profile/presentation/profile_labels.dart';
import '../../providers/onboarding_provider.dart';
import '../widgets/option_tile.dart';
import '../widgets/step_header.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();
    return ListView(
      children: [
        const StepHeader(title: 'How active are you?'),
        for (final level in ActivityLevel.values)
          OptionTile(
            title: level.label,
            subtitle: level.description,
            icon: level.icon,
            selected: onboarding.activityLevel == level,
            onTap: () => onboarding.setActivityLevel(level),
          ),
      ],
    );
  }
}
