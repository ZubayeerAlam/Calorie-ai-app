import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/add_circle_button.dart';
import '../../../../l10n/l10n.dart';

/// One meal row: picture, name, mini progress bar, "eaten / target kcal"
/// and a + button.
class MealTile extends StatelessWidget {
  const MealTile({
    super.key,
    required this.picture,
    required this.title,
    required this.eaten,
    required this.target,
    required this.onAdd,
    this.onTap,
    this.addButtonKey,
  });

  /// Shown at 52 × 52, e.g. a `MealIllustration`.
  final Widget picture;
  final String title;
  final int eaten;
  final int target;
  final VoidCallback onAdd;
  final VoidCallback? onTap;
  final Key? addButtonKey;

  @override
  Widget build(BuildContext context) {
    final progress = target == 0 ? 0.0 : (eaten / target).clamp(0.0, 1.0);

    return InkWell(
      onTap: onTap,
      // At least 80 tall; taller when large text or Bangla needs it.
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 80),
        child: Row(
          children: [
            SizedBox.square(dimension: 52, child: picture),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
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
                      Flexible(
                        child: Text(
                          l10n.eatenOfTarget('$eaten', '$target'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AddCircleButton(
              key: addButtonKey,
              tooltip: l10n.addToMeal(title),
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}
