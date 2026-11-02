import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../dashboard/presentation/widgets/dashboard_card.dart';
import '../../providers/account_provider.dart';

/// Account status on the Account tab: sign in to back up, or the signed-in
/// email with Log out. Hidden when accounts aren't available.
class AccountCard extends StatelessWidget {
  const AccountCard({super.key});

  Future<void> _confirmSignOut(
    BuildContext context,
    AccountProvider account,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'Your data stays in your account and is removed from this phone. '
          'Sign in again to get it back.',
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            key: const ValueKey('confirm-log-out'),
            onPressed: () => ctx.pop(true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed == true) await account.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountProvider>();
    if (!account.isAvailable) return const SizedBox.shrink();
    final user = account.user;

    return DashboardCard(
      child: Row(
        children: [
          Icon(
            user == null ? Icons.cloud_off_outlined : Icons.cloud_done_outlined,
            size: 32,
            color: user == null ? AppColors.textLight : AppColors.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user == null
                      ? 'Back up your data'
                      : (user.email ?? 'Signed in'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user == null
                      ? 'Sign in to keep your meals and weight safe and use '
                            'them on another phone.'
                      : 'Backed up and synced to your account',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 8),
                if (user == null)
                  ElevatedButton(
                    key: const ValueKey('open-sign-in'),
                    onPressed: () => context.push(AppRoutes.signIn),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textDark,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Sign in or create account'),
                  )
                else
                  OutlinedButton(
                    key: const ValueKey('log-out'),
                    onPressed: () => _confirmSignOut(context, account),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textDark,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Log out'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
