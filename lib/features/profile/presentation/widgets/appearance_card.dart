import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/appearance_controller.dart';
import '../../../dashboard/presentation/widgets/dashboard_card.dart';
import '../../../../l10n/l10n.dart';

/// Account → Appearance: follow the phone, or always light or dark.
class AppearanceCard extends StatelessWidget {
  const AppearanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appearance = context.watch<AppearanceController>();
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.appearance,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<ThemeMode>(
              key: const ValueKey('appearance'),
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.brightness_auto_outlined),
                  label: Text(l10n.themeSystem),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode_outlined),
                  label: Text(l10n.themeLight),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode_outlined),
                  label: Text(l10n.themeDark),
                ),
              ],
              selected: {appearance.mode},
              showSelectedIcon: false,
              onSelectionChanged: (s) => appearance.setMode(s.first),
              style: SegmentedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.textGrey,
                selectedBackgroundColor: AppColors.primary,
                selectedForegroundColor: AppColors.onPrimary,
                side: BorderSide(color: AppColors.line),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
