import 'package:flutter/material.dart';

import '../onboarding_colors.dart';

class StepHeader extends StatelessWidget {
  const StepHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 36),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: OnboardingColors.textDark,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: OnboardingColors.textGrey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
