import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../profile/providers/profile_provider.dart';
import '../../../profile/data/models/user_profile.dart';
import '../../data/models/exercise_settings.dart';
import '../../providers/exercise_provider.dart';
import 'environment_option_card.dart';
import 'safety_note.dart';
import 'setup_extras_section.dart';

/// Pick Home or Gym (plus optional extras), then make the plan.
///
/// Shown in the Exercise tab the first time, and as "Workout setup" later
/// (prefilled with the saved choices). [onDone] runs once the plan is made.
class ExerciseSetupView extends StatefulWidget {
  const ExerciseSetupView({super.key, this.onDone});

  final VoidCallback? onDone;

  @override
  State<ExerciseSetupView> createState() => _ExerciseSetupViewState();
}

class _ExerciseSetupViewState extends State<ExerciseSetupView> {
  ExerciseSettings? _saved;
  WorkoutEnvironment? _environment;
  late ExerciseSettings _extras;

  @override
  void initState() {
    super.initState();
    _saved = context.read<ExerciseProvider>().settings;
    _environment = _saved?.environment;
    final activity =
        context.read<ProfileProvider>().profile?.activityLevel ??
        ActivityLevel.light;
    _extras =
        _saved ??
        ExerciseSettings.defaultsFor(WorkoutEnvironment.home, activity);
  }

  ExerciseSettings? get _settings {
    final environment = _environment;
    if (environment == null) return null;
    return _extras.copyWith(
      environment: environment,
      // Home equipment means nothing at the gym.
      homeEquipment: environment == WorkoutEnvironment.gym
          ? const {}
          : _extras.homeEquipment,
    );
  }

  Future<void> _create() async {
    final settings = _settings;
    if (settings == null) return;
    await context.read<ExerciseProvider>().setUp(settings);
    widget.onDone?.call();
  }

  @override
  Widget build(BuildContext context) {
    final generating = context.select<ExerciseProvider, bool>(
      (p) => p.generating,
    );
    final settings = _settings;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text(
          l10n.exerciseIntroTitle,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.exerciseIntroBody,
          style: TextStyle(fontSize: 14, color: AppColors.textGrey),
        ),
        const SizedBox(height: 20),
        for (final environment in WorkoutEnvironment.values) ...[
          EnvironmentOptionCard(
            key: ValueKey('env-${environment.name}'),
            environment: environment,
            selected: _environment == environment,
            onTap: generating
                ? () {}
                : () => setState(() => _environment = environment),
          ),
          const SizedBox(height: 12),
        ],
        SetupExtrasSection(
          settings: settings ?? _extras,
          onChanged: (s) => setState(() => _extras = s),
        ),
        const SizedBox(height: 16),
        SafetyNote(text: l10n.setupSafety),
        const SizedBox(height: 20),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            key: const ValueKey('create-plan'),
            onPressed: settings == null || generating ? null : _create,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              elevation: 0,
              shape: const StadiumBorder(),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: generating
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(child: Text(l10n.creatingPlan)),
                    ],
                  )
                : Text(_saved == null ? l10n.createPlan : l10n.updatePlan),
          ),
        ),
      ],
    );
  }
}
