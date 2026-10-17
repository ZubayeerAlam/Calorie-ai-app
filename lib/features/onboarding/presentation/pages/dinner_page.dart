import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/onboarding_provider.dart';
import '../widgets/step_header.dart';
import '../widgets/wheel_picker.dart';

class DinnerPage extends StatelessWidget {
  const DinnerPage({super.key});

  static final List<int> _hours = List.generate(24, (i) => i);
  static final List<int> _minutes = List.generate(60, (i) => i);

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();

    return Column(
      children: [
        const StepHeader(title: 'When do you usually have\ndinner?'),
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: WheelPicker.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: WheelPicker(
                        values: _hours,
                        selected: onboarding.dinnerHour,
                        looping: true,
                        onChanged: onboarding.setDinnerHour,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: WheelPicker(
                        values: _minutes,
                        selected: onboarding.dinnerMinute,
                        looping: true,
                        format: (m) => m.toString().padLeft(2, '0'),
                        suffix: onboarding.dinnerHour >= 12 ? 'PM' : 'AM',
                        onChanged: onboarding.setDinnerMinute,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
