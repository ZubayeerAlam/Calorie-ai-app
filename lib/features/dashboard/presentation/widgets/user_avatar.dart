import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Round avatar showing the user's initials.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.name, this.size = 42});

  final String name;
  final double size;

  static String initialsOf(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final initials = initialsOf(name);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
      ),
      child: initials.isEmpty
          ? Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: size * 0.6,
            )
          : Text(
              initials,
              style: TextStyle(
                fontSize: size * 0.4,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
    );
  }
}
