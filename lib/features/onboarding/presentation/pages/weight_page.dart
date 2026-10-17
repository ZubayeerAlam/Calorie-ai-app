import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/onboarding_provider.dart';
import '../onboarding_colors.dart';
import '../widgets/step_header.dart';
import '../widgets/unit_toggle.dart';
import '../widgets/weight_ruler.dart';

class WeightPage extends StatelessWidget {
  const WeightPage({super.key});

  static const double _lbPerKg = 2.20462;

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();
    final metric = onboarding.useMetric;
    final shown = metric ? onboarding.weightKg : onboarding.weightKg * _lbPerKg;

    return SingleChildScrollView(
      child: Column(
        children: [
          const StepHeader(title: "What's your weight?"),
          const SizedBox(height: 51),
          UnitToggle(
            useMetric: metric,
            onChanged: onboarding.setUseMetric,
            metricLabel: 'kg',
            imperialLabel: 'lb',
          ),
          const SizedBox(height: 52),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                // Balances the unit label so the number stays centered.
                const SizedBox(width: 38),
                Text(
                  shown.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 74,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                    height: 1.15,
                    color: OnboardingColors.textDark,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 28,
                  child: Text(
                    metric ? 'kg' : 'lb',
                    style: const TextStyle(
                      fontSize: 26,
                      color: OnboardingColors.textGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          WeightRuler(
            value: shown,
            min: metric ? 30 : 66,
            max: metric ? 250 : 550,
            onChanged: (value) =>
                onboarding.setWeightKg(metric ? value : value / _lbPerKg),
          ),
        ],
      ),
    );
  }
}
