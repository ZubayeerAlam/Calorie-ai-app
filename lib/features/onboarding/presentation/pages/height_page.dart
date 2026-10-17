import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/onboarding_provider.dart';
import '../widgets/step_header.dart';
import '../widgets/unit_toggle.dart';
import '../widgets/wheel_picker.dart';

class HeightPage extends StatelessWidget {
  const HeightPage({super.key});

  static const double _cmPerInch = 2.54;
  static final List<int> _cmValues = List.generate(151, (i) => 100 + i);
  static final List<int> _feetValues = List.generate(6, (i) => 3 + i);
  static final List<int> _inchValues = List.generate(12, (i) => i);

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();
    final totalInches = (onboarding.heightCm / _cmPerInch).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;

    void setImperial(int ft, int inch) =>
        onboarding.setHeightCm(((ft * 12 + inch) * _cmPerInch).round());

    return Column(
      children: [
        const StepHeader(title: 'How tall are you?'),
        UnitToggle(
          useMetric: onboarding.useMetric,
          onChanged: onboarding.setUseMetric,
          metricLabel: 'cm',
          imperialLabel: 'ft / in',
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: onboarding.useMetric
                ? WheelPicker(
                    key: const ValueKey('height-cm'),
                    values: _cmValues,
                    selected: onboarding.heightCm,
                    suffix: 'cm',
                    onChanged: onboarding.setHeightCm,
                  )
                : Row(
                    children: [
                      Expanded(
                        child: WheelPicker(
                          key: const ValueKey('height-ft'),
                          values: _feetValues,
                          selected: feet,
                          suffix: 'ft',
                          onChanged: (ft) => setImperial(ft, inches),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: WheelPicker(
                          key: const ValueKey('height-in'),
                          values: _inchValues,
                          selected: inches,
                          suffix: 'in',
                          onChanged: (inch) => setImperial(feet, inch),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
