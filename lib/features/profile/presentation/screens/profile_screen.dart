import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/calorie_calculator.dart';
import '../../providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const double _minKcal = 1000;
  static const double _maxKcal = 4000;

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final goals = profile.goals;
    final recommended = profile.recommendedGoals;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Goals')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Daily calorie goal: ${goals.dailyCalories} kcal',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            profile.goalsCustomized
                ? 'Custom · recommended ${recommended?.dailyCalories ?? '-'} kcal'
                : 'Recommended for your profile',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Slider(
            value: goals.dailyCalories.toDouble().clamp(_minKcal, _maxKcal),
            min: _minKcal,
            max: _maxKcal,
            divisions: 60,
            label: '${goals.dailyCalories}',
            // Macros follow the calories with the standard 50/30/20 split.
            onChanged: (v) =>
                profile.updateGoals(CalorieCalculator.macrosFor(v.round())),
          ),
          if (profile.goalsCustomized && recommended != null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: profile.resetGoalsToRecommended,
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset to recommended'),
              ),
            ),
          const Divider(),
          ListTile(
            title: const Text('Protein'),
            trailing: Text('${goals.protein} g'),
          ),
          ListTile(
            title: const Text('Carbs'),
            trailing: Text('${goals.carbs} g'),
          ),
          ListTile(title: const Text('Fat'), trailing: Text('${goals.fat} g')),
        ],
      ),
    );
  }
}
