import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/calorie_calculator.dart';
import '../../../account/presentation/widgets/account_card.dart';
import '../../../activity/presentation/widgets/health_card.dart';
import '../../providers/profile_provider.dart';
import '../widgets/appearance_card.dart';
import '../widgets/language_card.dart';
import '../widgets/profile_card.dart';
import '../widgets/reset_data_button.dart';
import '../../../../l10n/l10n.dart';

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
      appBar: AppBar(title: Text(l10n.profileAndGoals)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          if (profile.profile case final user?) ...[
            ProfileCard(profile: user),
            const SizedBox(height: 12),
          ],
          const AccountCard(),
          const SizedBox(height: 12),
          const HealthCard(),
          const SizedBox(height: 12),
          const AppearanceCard(),
          const SizedBox(height: 12),
          const LanguageCard(),
          const SizedBox(height: 16),
          Text(
            l10n.dailyCalorieGoal('${goals.dailyCalories}'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            profile.goalsCustomized
                ? l10n.customRecommended('${recommended?.dailyCalories ?? '-'}')
                : l10n.recommendedForProfile,
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
                label: Text(l10n.resetToRecommended),
              ),
            ),
          const Divider(),
          ListTile(
            title: Text(l10n.protein),
            trailing: Text(l10n.gramsValue('${goals.protein}')),
          ),
          ListTile(
            title: Text(l10n.carbs),
            trailing: Text(l10n.gramsValue('${goals.carbs}')),
          ),
          ListTile(
            title: Text(l10n.fat),
            trailing: Text(l10n.gramsValue('${goals.fat}')),
          ),
          const SizedBox(height: 24),
          const ResetDataButton(),
        ],
      ),
    );
  }
}
