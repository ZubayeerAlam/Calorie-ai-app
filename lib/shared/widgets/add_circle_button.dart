import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/l10n.dart';

/// Round green "+" button used across the dashboard. The visible circle is
/// [size]; taps land anywhere in a square of at least 48 × 48 around it.
class AddCircleButton extends StatelessWidget {
  const AddCircleButton({
    super.key,
    required this.onPressed,
    this.size = 38,
    this.tooltip,
  });

  static const double minTapSize = 48;

  final VoidCallback onPressed;
  final double size;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final tapSize = size < minTapSize ? minTapSize : size;
    return Tooltip(
      message: tooltip ?? l10n.add,
      child: InkResponse(
        onTap: onPressed,
        radius: size / 2,
        child: SizedBox.square(
          dimension: tapSize,
          child: Center(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: size * 0.5,
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
