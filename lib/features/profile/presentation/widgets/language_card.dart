import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../l10n/language_controller.dart';
import '../../../dashboard/presentation/widgets/dashboard_card.dart';

/// Account → Language: follow the phone, or always English or Bangla.
class LanguageCard extends StatelessWidget {
  const LanguageCard({super.key});

  // A segment's value; '' stands for "follow the phone".
  static const String _system = '';

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageController>();
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.language,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              key: const ValueKey('language'),
              segments: [
                ButtonSegment(value: _system, label: Text(l10n.languageSystem)),
                // Each language in its own words.
                for (final MapEntry(key: code, value: name)
                    in LanguageController.languages.entries)
                  ButtonSegment(value: code, label: Text(name)),
              ],
              selected: {language.code ?? _system},
              showSelectedIcon: false,
              onSelectionChanged: (s) =>
                  language.setCode(s.first == _system ? null : s.first),
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
