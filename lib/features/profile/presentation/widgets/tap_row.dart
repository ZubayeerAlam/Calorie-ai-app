import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A white row showing a value, opening a picker when tapped (read-only
/// without [onTap]).
class TapRow extends StatelessWidget {
  const TapRow({
    super.key,
    required this.icon,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textGrey),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: AppColors.textLight,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
