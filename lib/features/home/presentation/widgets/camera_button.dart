import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Round green camera button that rises above the middle of the bottom bar.
/// It is an action (it opens a screen), not a tab.
class CameraButton extends StatelessWidget {
  const CameraButton({super.key, required this.onPressed});

  static const double size = 64;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Add food with camera',
      child: Container(
        width: size,
        height: size,
        // White ring so it reads as sitting on top of the bar.
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.surface, width: 5),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: AppColors.primary,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: const Icon(
              Icons.photo_camera_rounded,
              size: 28,
              color: AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}
