import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final goals = profile.goals;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Goals')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Daily calorie goal: ${goals.dailyCalories} kcal',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Slider(
            value: goals.dailyCalories.toDouble(),
            min: 1000,
            max: 4000,
            divisions: 60,
            label: '${goals.dailyCalories}',
            onChanged: (v) =>
                profile.updateGoals(goals.copyWith(dailyCalories: v.round())),
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
