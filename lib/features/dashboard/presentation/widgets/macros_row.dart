import 'package:flutter/material.dart';

import '../../../profile/data/models/user_goals.dart';
import 'macro_ring.dart';
import '../../../../l10n/l10n.dart';

/// Carbs, Protein and Fat rings side by side.
class MacrosRow extends StatelessWidget {
  const MacrosRow({
    super.key,
    required this.goals,
    required this.carbs,
    required this.protein,
    required this.fat,
  });

  final UserGoals goals;
  final double carbs;
  final double protein;
  final double fat;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MacroRing(
          label: l10n.carbs,
          eatenGrams: carbs.round(),
          targetGrams: goals.carbs,
        ),
        MacroRing(
          label: l10n.protein,
          eatenGrams: protein.round(),
          targetGrams: goals.protein,
        ),
        MacroRing(
          label: l10n.fat,
          eatenGrams: fat.round(),
          targetGrams: goals.fat,
        ),
      ],
    );
  }
}
