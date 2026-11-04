import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/onboarding_provider.dart';
import '../widgets/step_header.dart';
import '../../../../l10n/l10n.dart';

class BirthdayPage extends StatelessWidget {
  const BirthdayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();
    final theme = Theme.of(context);
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StepHeader(title: l10n.whenBorn),
        SizedBox(
          height: 220,
          child: CupertinoTheme(
            data: CupertinoThemeData(brightness: theme.brightness),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: onboarding.birthday,
              minimumDate: DateTime(now.year - OnboardingProvider.maxAge - 1),
              maximumDate: now,
              onDateTimeChanged: onboarding.setBirthday,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (!onboarding.canContinue)
          Text(
            l10n.ageRange(
              '${OnboardingProvider.minAge}',
              '${OnboardingProvider.maxAge}',
            ),
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.error),
          ),
      ],
    );
  }
}
