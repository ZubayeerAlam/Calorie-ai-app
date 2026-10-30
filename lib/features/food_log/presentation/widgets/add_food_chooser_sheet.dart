import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../add_food_method.dart';
import 'add_food_option_card.dart';

/// Bottom sheet opened by the camera button: pick how to add food.
/// Resolves to the chosen [AddFoodMethod], or null if dismissed.
class AddFoodChooserSheet extends StatelessWidget {
  const AddFoodChooserSheet({super.key});

  static Future<AddFoodMethod?> show(BuildContext context) {
    return showModalBottomSheet<AddFoodMethod>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddFoodChooserSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Add food',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'How would you like to add your meal?',
              style: TextStyle(fontSize: 14, color: AppColors.textGrey),
            ),
            const SizedBox(height: 18),
            AddFoodOptionCard(
              key: const ValueKey('add-food-camera'),
              icon: Icons.photo_camera_rounded,
              title: 'Scan with camera',
              subtitle: 'Take or choose a photo of your meal',
              onTap: () => context.pop(AddFoodMethod.camera),
            ),
            const SizedBox(height: 12),
            AddFoodOptionCard(
              key: const ValueKey('add-food-manual'),
              icon: Icons.edit_note_rounded,
              title: 'Add manually',
              subtitle: 'Describe your meal and get its nutrition',
              onTap: () => context.pop(AddFoodMethod.manual),
            ),
          ],
        ),
      ),
    );
  }
}
