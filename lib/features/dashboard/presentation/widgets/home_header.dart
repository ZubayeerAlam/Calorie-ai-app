import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'notification_bell.dart';
import 'user_avatar.dart';
import '../../../../l10n/l10n.dart';

/// Avatar, time-of-day greeting with the user's name, and the bell.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.name,
    required this.subtitle,
    required this.onNotificationsPressed,
    this.hasUnread = false,
    this.now,
  });

  final String name;

  /// Short line under the greeting, e.g. the user's goal.
  final String subtitle;
  final VoidCallback onNotificationsPressed;

  /// A meal reminder's time passed without the meal logged.
  final bool hasUnread;

  /// Overrides the clock (for tests).
  final DateTime? now;

  static String greetingFor(DateTime time) => switch (time.hour) {
    < 12 => l10n.goodMorning,
    < 17 => l10n.goodAfternoon,
    _ => l10n.goodEvening,
  };

  @override
  Widget build(BuildContext context) {
    final greeting = greetingFor(now ?? DateTime.now());
    final firstName = name.trim().split(RegExp(r'\s+')).first;

    return SizedBox(
      height: 64,
      child: Row(
        children: [
          UserAvatar(name: name),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstName.isEmpty
                      ? greeting
                      : l10n.greetingName(greeting, firstName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    // On the green header: dark in both modes.
                    color: AppColors.onPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.onPrimary.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          NotificationBell(
            key: const ValueKey('notifications'),
            onPressed: onNotificationsPressed,
            hasUnread: hasUnread,
          ),
        ],
      ),
    );
  }
}
