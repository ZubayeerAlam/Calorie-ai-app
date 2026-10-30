import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Round green "+" button used across the dashboard.
class AddCircleButton extends StatelessWidget {
  const AddCircleButton({
    super.key,
    required this.onPressed,
    this.size = 38,
    this.tooltip,
  });

  final VoidCallback onPressed;
  final double size;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? 'Add',
      child: Material(
        color: AppColors.primary,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox.square(
            dimension: size,
            child: Icon(Icons.add, size: size * 0.5, color: AppColors.textDark),
          ),
        ),
      ),
    );
  }
}
