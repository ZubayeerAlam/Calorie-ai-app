import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../profile/data/models/user_profile.dart';
import '../../../profile/presentation/profile_labels.dart';
import '../../providers/onboarding_provider.dart';
import '../widgets/option_tile.dart';
import '../widgets/step_header.dart';

class GenderPage extends StatelessWidget {
  const GenderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();
    return ListView(
      children: [
        const StepHeader(title: 'Choose your gender'),
        for (final gender in Gender.values)
          OptionTile(
            title: gender.label,
            icon: gender.icon,
            selected: onboarding.gender == gender,
            onTap: () => onboarding.setGender(gender),
          ),
      ],
    );
  }
}
