import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/add_circle_button.dart';

/// One meal row: picture, name, mini progress bar, "eaten / target kcal"
/// and a + button.
///
/// [image] is an emoji, or an asset path (ending in .png/.jpg/.webp) once
/// meal illustrations are added.
class MealTile extends StatelessWidget {
  const MealTile({
    super.key,
    required this.image,
    required this.title,
    required this.eaten,
    required this.target,
    required this.onAdd,
    this.onTap,
    this.addButtonKey,
  });

  final String image;
  final String title;
  final int eaten;
  final int target;
  final VoidCallback onAdd;
  final VoidCallback? onTap;
  final Key? addButtonKey;

  bool get _isAsset => RegExp(r'\.(png|jpe?g|webp)$').hasMatch(image);

  @override
  Widget build(BuildContext context) {
    final progress = target == 0 ? 0.0 : (eaten / target).clamp(0.0, 1.0);

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 80,
        child: Row(
          children: [
            SizedBox.square(
              dimension: 52,
              child: Center(
                child: _isAsset
                    ? Image.asset(image, fit: BoxFit.contain)
                    : Text(image, style: const TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 36,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 5,
                            backgroundColor: AppColors.ringTrack,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$eaten / $target kcal',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AddCircleButton(
              key: addButtonKey,
              tooltip: 'Add to $title',
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}
