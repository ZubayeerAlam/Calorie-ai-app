import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../food_log/data/models/food_entry.dart';
import '../../../food_log/presentation/meal_type_labels.dart';
import '../../../../shared/widgets/meal_illustration.dart';

/// Row of chips to choose which meal the food is logged to.
class MealPicker extends StatelessWidget {
  const MealPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final MealType selected;
  final ValueChanged<MealType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final meal in MealType.values)
          ChoiceChip(
            avatar: MealIllustration(meal: meal, size: 22),
            label: Text(meal.label),
            selected: meal == selected,
            onSelected: (_) => onChanged(meal),
            showCheckmark: false,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.card,
            side: BorderSide(
              color: meal == selected ? AppColors.primary : AppColors.line,
            ),
            labelStyle: TextStyle(
              fontSize: 14,
              color: meal == selected
                  ? AppColors.onPrimary
                  : AppColors.textDark,
            ),
          ),
      ],
    );
  }
}
