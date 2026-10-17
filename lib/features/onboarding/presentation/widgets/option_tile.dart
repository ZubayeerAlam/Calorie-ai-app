import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A selectable card used by the choice onboarding steps.
/// Shows an [emoji] (or an [icon]) on the left and a check when selected.
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.emoji,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? emoji;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: const BoxConstraints(minHeight: 68),
          padding: const EdgeInsets.fromLTRB(20, 12, 22, 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.card,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              if (emoji != null || icon != null) ...[
                SizedBox(
                  width: 32,
                  child: emoji != null
                      ? Text(
                          emoji!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 28),
                        )
                      : Icon(icon, size: 28, color: AppColors.textDark),
                ),
                const SizedBox(width: 20),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textDark,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textGrey,
                        ),
                      ),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check, size: 24, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
