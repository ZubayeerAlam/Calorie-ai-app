import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'notification_bell.dart';
import 'user_avatar.dart';

/// Avatar, time-of-day greeting with the user's name, and the bell.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.name,
    required this.subtitle,
    required this.onNotificationsPressed,
    this.now,
  });

  final String name;

  /// Short line under the greeting, e.g. the user's goal.
  final String subtitle;
  final VoidCallback onNotificationsPressed;

  /// Overrides the clock (for tests).
  final DateTime? now;

  static String greetingFor(DateTime time) => switch (time.hour) {
    < 12 => 'Good morning',
    < 17 => 'Good afternoon',
    _ => 'Good evening',
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
                  firstName.isEmpty ? greeting : '$greeting, $firstName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textDark.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          NotificationBell(onPressed: onNotificationsPressed, hasUnread: true),
        ],
      ),
    );
  }
}
