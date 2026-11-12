import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';

/// Round green camera button in the middle of the bottom bar. It sits in
/// the bar (it doesn't rise above it) and is an action that opens the
/// Add food chooser, not a tab.
class CameraButton extends StatelessWidget {
  const CameraButton({super.key, required this.onPressed});

  static const double size = 52;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: l10n.addFoodWithCamera,
      child: SizedBox.square(
        dimension: size,
        child: Material(
          color: AppColors.primary,
          shape: const CircleBorder(),
          elevation: 2,
          shadowColor: AppColors.primary.withValues(alpha: 0.5),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Icon(
              Icons.photo_camera_rounded,
              size: 26,
              color: AppColors.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
