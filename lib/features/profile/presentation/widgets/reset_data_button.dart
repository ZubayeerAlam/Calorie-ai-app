import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../account/providers/account_provider.dart';

/// "Reset all data" at the bottom of Account, behind a confirmation.
class ResetDataButton extends StatelessWidget {
  const ResetDataButton({super.key});

  Future<void> _confirm(BuildContext context) async {
    final account = context.read<AccountProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset all data?'),
        content: Text(
          account.isSignedIn
              ? 'This deletes your profile, meals, weight and activity from '
                    'this phone and from your account, and starts again with '
                    "setup. You'll stay signed in. This can't be undone."
              : 'This deletes your profile, meals, weight and activity from '
                    "this phone and starts again with setup. This can't be "
                    'undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            key: const ValueKey('confirm-reset'),
            onPressed: () => ctx.pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.badge),
            child: const Text('Delete everything'),
          ),
        ],
      ),
    );
    if (confirmed == true) await account.resetAllData();
  }

  @override
  Widget build(BuildContext context) {
    // Left-aligned: the raised camera button sits in the centre.
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        key: const ValueKey('reset-data'),
        onPressed: () => _confirm(context),
        icon: const Icon(Icons.delete_forever_outlined),
        label: const Text('Reset all data'),
        style: TextButton.styleFrom(foregroundColor: AppColors.badge),
      ),
    );
  }
}
