import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../profile/presentation/widgets/choice_chips.dart';
import '../../../profile/presentation/widgets/edit_section.dart';
import '../../data/models/exercise_settings.dart';
import '../exercise_labels.dart';

/// The optional choices on the setup screen, folded away by default:
/// fitness level, minutes, home equipment (Home only) and limitations.
class SetupExtrasSection extends StatelessWidget {
  const SetupExtrasSection({
    super.key,
    required this.settings,
    required this.onChanged,
    this.initiallyExpanded = false,
  });

  final ExerciseSettings settings;
  final ValueChanged<ExerciseSettings> onChanged;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Theme(
      // No divider lines above and below the expanded section.
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: const ValueKey('setup-extras'),
        initiallyExpanded: initiallyExpanded,
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(top: 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        iconColor: AppColors.textDark,
        collapsedIconColor: AppColors.textDark,
        title: Text(
          l10n.setupExtras,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Text(
          l10n.setupExtrasHint,
          style: TextStyle(fontSize: 13, color: AppColors.textGrey),
        ),
        children: [
          EditSection(
            title: l10n.setupLevel,
            child: OptionChips<FitnessLevel>(
              options: FitnessLevel.values,
              selected: {settings.level},
              labelOf: ExerciseLabels.level,
              onChanged: (s) => onChanged(settings.copyWith(level: s.first)),
            ),
          ),
          EditSection(
            title: l10n.setupMinutes,
            child: OptionChips<int>(
              options: ExerciseSettings.sessionMinuteOptions,
              selected: {settings.sessionMinutes},
              labelOf: l10n.minutesShort,
              onChanged: (s) =>
                  onChanged(settings.copyWith(sessionMinutes: s.first)),
            ),
          ),
          if (settings.environment == WorkoutEnvironment.home)
            EditSection(
              title: l10n.setupEquipment,
              child: OptionChips<HomeEquipment>(
                multiple: true,
                options: HomeEquipment.values,
                selected: settings.homeEquipment,
                labelOf: ExerciseLabels.equipment,
                onChanged: (s) =>
                    onChanged(settings.copyWith(homeEquipment: s)),
              ),
            ),
          EditSection(
            title: l10n.setupLimitations,
            hint: l10n.setupLimitationsHint,
            child: OptionChips<BodyLimitation>(
              multiple: true,
              options: BodyLimitation.values,
              selected: settings.limitations,
              labelOf: ExerciseLabels.limitation,
              onChanged: (s) => onChanged(settings.copyWith(limitations: s)),
            ),
          ),
        ],
      ),
    );
  }
}
