import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';

/// Outlined round bell button with an optional red unread dot. It sits
/// on the green header, so it is dark in both modes.
class NotificationBell extends StatelessWidget {
  const NotificationBell({
    super.key,
    required this.onPressed,
    this.hasUnread = false,
  });

  final VoidCallback onPressed;
  final bool hasUnread;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: l10n.notifications,
      // A 48 × 48 tap area around the 42 px circle.
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.onPrimary, width: 1.5),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  size: 24,
                  color: AppColors.onPrimary,
                ),
                if (hasUnread)
                  Positioned(
                    top: 8,
                    right: 9,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.badge,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
