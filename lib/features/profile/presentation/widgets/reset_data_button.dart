import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../account/providers/account_provider.dart';
import '../../../../l10n/l10n.dart';

/// "Reset all data" at the bottom of Account, behind a confirmation.
class ResetDataButton extends StatelessWidget {
  const ResetDataButton({super.key});

  Future<void> _confirm(BuildContext context) async {
    final account = context.read<AccountProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.resetAllDataTitle),
        content: Text(
          account.isSignedIn ? l10n.resetSignedIn : l10n.resetLocal,
        ),
        actions: [
          TextButton(onPressed: () => ctx.pop(false), child: Text(l10n.cancel)),
          TextButton(
            key: const ValueKey('confirm-reset'),
            onPressed: () => ctx.pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.badge),
            child: Text(l10n.deleteEverything),
          ),
        ],
      ),
    );
    if (confirmed == true) await account.resetAllData();
  }

  @override
  Widget build(BuildContext context) {
    // Left-aligned, like a list action.
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        key: const ValueKey('reset-data'),
        onPressed: () => _confirm(context),
        icon: const Icon(Icons.delete_forever_outlined),
        label: Text(l10n.resetAllData),
        style: TextButton.styleFrom(foregroundColor: AppColors.badge),
      ),
    );
  }
}
