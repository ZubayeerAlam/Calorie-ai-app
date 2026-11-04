import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/food_description.dart';
import '../../../../l10n/l10n.dart';

/// "You described" card: the typed meal and any optional details.
/// Takes the photo's place when the analysis came from text.
class DescriptionSummary extends StatelessWidget {
  const DescriptionSummary({super.key, required this.description});

  final FoodDescription description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit_note_rounded,
                size: 20,
                color: AppColors.textGrey,
              ),
              SizedBox(width: 6),
              Text(
                l10n.youDescribed,
                style: TextStyle(fontSize: 13, color: AppColors.textGrey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description.text.trim(),
            style: TextStyle(fontSize: 16, color: AppColors.textDark),
          ),
          for (final (label, value) in description.details) ...[
            const SizedBox(height: 6),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: l10n.detailLine(_labelFor(label)),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value),
                ],
              ),
              style: TextStyle(fontSize: 13, color: AppColors.textGrey),
            ),
          ],
        ],
      ),
    );
  }

  /// The detail labels are English in the model (they go to the AI too).
  static String _labelFor(String label) => switch (label) {
    'Portion' => l10n.detailPortion,
    'Cooking' => l10n.detailCooking,
    'Brand' => l10n.detailBrand,
    'Ingredients' => l10n.detailIngredients,
    _ => label,
  };
}
