import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../dashboard/presentation/widgets/dashboard_card.dart';
import '../../providers/account_provider.dart';
import '../../../../l10n/l10n.dart';

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
        title: Text(l10n.logOutTitle),
        content: Text(l10n.logOutBody),
        actions: [
          TextButton(onPressed: () => ctx.pop(false), child: Text(l10n.cancel)),
          TextButton(
            key: const ValueKey('confirm-log-out'),
            onPressed: () => ctx.pop(true),
            child: Text(l10n.logOut),
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
                      ? l10n.backUpYourData
                      : (user.email ?? l10n.signedIn),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user == null ? l10n.backUpPitch : l10n.backedUpSynced,
                  style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                ),
                const SizedBox(height: 8),
                if (user == null)
                  // Full width, and the label shrinks rather than overflowing
                  // when a language makes it long.
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      key: const ValueKey('open-sign-in'),
                      onPressed: () => context.push(AppRoutes.signIn),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(l10n.signInOrCreate),
                      ),
                    ),
                  )
                else
                  OutlinedButton(
                    key: const ValueKey('log-out'),
                    onPressed: () => _confirmSignOut(context, account),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textDark,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(l10n.logOut),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
