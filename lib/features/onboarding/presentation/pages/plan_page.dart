import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/onboarding_provider.dart';
import '../onboarding_colors.dart';
import '../widgets/step_header.dart';

/// The plan summary, shown after [PersonalizingPage] marks the plan ready.
class PlanPage extends StatelessWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();
    final goals = onboarding.goals;
    final weekly = onboarding.weeklyChangeKg;

    return ListView(
      children: [
        const StepHeader(title: 'Your plan is ready'),
        Center(
          child: Text(
            '${goals.dailyCalories}',
            style: const TextStyle(
              fontSize: 74,
              fontWeight: FontWeight.w600,
              letterSpacing: -1,
              color: OnboardingColors.primary,
            ),
          ),
        ),
        const Center(
          child: Text(
            'calories per day',
            style: TextStyle(fontSize: 18, color: OnboardingColors.textGrey),
          ),
        ),
        const SizedBox(height: 36),
        _MacroRow(emoji: '🍗', label: 'Protein', grams: goals.protein),
        _MacroRow(emoji: '🍞', label: 'Carbs', grams: goals.carbs),
        _MacroRow(emoji: '🥑', label: 'Fat', grams: goals.fat),
        if (weekly != 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${weekly > 0 ? '+' : ''}${weekly.toStringAsFixed(2)} kg per week',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: OnboardingColors.textGrey,
              ),
            ),
          ),
      ],
    );
  }
}

class _MacroRow extends StatelessWidget {
  const _MacroRow({
    required this.emoji,
    required this.label,
    required this.grams,
  });

  final String emoji;
  final String label;
  final int grams;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: OnboardingColors.card,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              emoji,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 19,
                color: OnboardingColors.textDark,
              ),
            ),
          ),
          Text(
            '$grams g',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: OnboardingColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
