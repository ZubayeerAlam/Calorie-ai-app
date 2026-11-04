import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../add_food_method.dart';
import 'add_food_option_card.dart';
import '../../../../l10n/l10n.dart';

/// Bottom sheet opened by the camera button: pick how to add food.
/// Resolves to the chosen [AddFoodMethod], or null if dismissed.
class AddFoodChooserSheet extends StatelessWidget {
  const AddFoodChooserSheet({super.key});

  static Future<AddFoodMethod?> show(BuildContext context) {
    return showModalBottomSheet<AddFoodMethod>(
      context: context,
      // Sized to its content, which grows with large text and Bangla.
      isScrollControlled: true,
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
            Text(
              l10n.addFood,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.howToAddMeal,
              style: TextStyle(fontSize: 14, color: AppColors.textGrey),
            ),
            const SizedBox(height: 18),
            AddFoodOptionCard(
              key: const ValueKey('add-food-camera'),
              icon: Icons.photo_camera_rounded,
              title: l10n.scanWithCamera,
              subtitle: l10n.scanWithCameraHint,
              onTap: () => context.pop(AddFoodMethod.camera),
            ),
            const SizedBox(height: 12),
            AddFoodOptionCard(
              key: const ValueKey('add-food-manual'),
              icon: Icons.edit_note_rounded,
              title: l10n.addManually,
              subtitle: l10n.addManuallyHint,
              onTap: () => context.pop(AddFoodMethod.manual),
            ),
          ],
        ),
      ),
    );
  }
}
