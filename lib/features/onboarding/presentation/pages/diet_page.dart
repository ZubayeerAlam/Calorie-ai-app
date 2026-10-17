import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../profile/data/models/user_profile.dart';
import '../../../profile/presentation/profile_labels.dart';
import '../../providers/onboarding_provider.dart';
import '../widgets/option_tile.dart';
import '../widgets/step_header.dart';

class DietPage extends StatelessWidget {
  const DietPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();
    return ListView(
      children: [
        const StepHeader(title: 'Do you follow a specific diet?'),
        for (final diet in DietType.values)
          OptionTile(
            title: diet.label,
            subtitle: diet.description,
            icon: diet.icon,
            selected: onboarding.dietType == diet,
            onTap: () => onboarding.setDietType(diet),
          ),
      ],
    );
  }
}
