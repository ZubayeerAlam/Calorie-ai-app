import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../dashboard/presentation/widgets/dashboard_card.dart';
import '../../../dashboard/presentation/widgets/user_avatar.dart';
import '../../data/models/user_profile.dart';
import '../profile_labels.dart';

/// The user's name and main details on Account, with Edit.
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Row(
        children: [
          UserAvatar(name: profile.name),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${profile.age} years · ${profile.heightLabel} · '
                  '${profile.weightLabel}\n'
                  '${profile.goal.label} · ${profile.activityLevel.label}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            key: const ValueKey('edit-profile'),
            onPressed: () => context.push(AppRoutes.editProfile),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}
