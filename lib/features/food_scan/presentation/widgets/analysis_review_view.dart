import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/meal_photo.dart';
import '../../../food_log/presentation/meal_type_labels.dart';
import '../../providers/food_analysis_controller.dart';
import 'analyzed_item_card.dart';
import 'demo_notice.dart';
import 'description_summary.dart';
import 'meal_picker.dart';

/// The AI result for review: photo, editable items, meal choice, and a
/// save button with the total.
class AnalysisReviewView extends StatelessWidget {
  const AnalysisReviewView({
    super.key,
    required this.controller,
    required this.onSave,
  });

  final FoodAnalysisController controller;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final items = controller.items;
    final count = items.length;
    final imagePath = controller.imagePath;
    final description = controller.description;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            children: [
              if (imagePath != null)
                MealPhoto(path: imagePath, height: 180)
              else if (description != null)
                DescriptionSummary(description: description),
              if (controller.isDemo) ...[
                const SizedBox(height: 12),
                DemoNotice(forPhoto: imagePath != null),
              ],
              const SizedBox(height: 20),
              Text(
                count == 0
                    ? 'All items removed'
                    : 'We found $count ${count == 1 ? 'item' : 'items'}',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                count == 0
                    ? (imagePath != null
                          ? 'Go back to try another photo.'
                          : 'Go back to edit your description.')
                    : 'AI estimate · check and edit before saving',
                style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
              ),
              for (var i = 0; i < count; i++) ...[
                const SizedBox(height: 12),
                AnalyzedItemCard(
                  key: ValueKey(controller.itemKey(i)),
                  item: items[i],
                  onChanged: (item) => controller.updateItem(i, item),
                  onRemove: () => controller.removeItem(i),
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'Add to',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              MealPicker(
                selected: controller.meal,
                onChanged: controller.setMeal,
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.divider),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                key: const ValueKey('save-analysis'),
                onPressed: controller.canSave ? onSave : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textDark,
                  disabledBackgroundColor: AppColors.primary.withValues(
                    alpha: 0.4,
                  ),
                  elevation: 0,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  'Add to ${controller.meal.label} · '
                  '${controller.totalCalories} kcal',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
