import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../profile/presentation/widgets/edit_section.dart';
import '../../../profile/providers/profile_provider.dart';
import '../../data/catalog/exercise_catalog.dart';
import '../../data/catalog/exercise_texts.dart';
import '../../data/exercise_estimate.dart';
import '../../data/models/workout_plan.dart';
import '../../providers/exercise_provider.dart';
import '../widgets/calorie_estimate_info.dart';
import '../widgets/demo_step_list.dart';
import '../widgets/exercise_demo_view.dart';
import '../widgets/exercise_stat_row.dart';
import '../widgets/muscle_chips.dart';
import '../widgets/primary_button.dart';
import '../widgets/safety_note.dart';

/// One exercise: the animated demo, how to do it, the prescription from
/// the plan, the muscles and benefits, and the calorie estimate.
class ExerciseDetailsScreen extends StatefulWidget {
  const ExerciseDetailsScreen({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  int _step = 0;

  /// The plan's prescription, or catalog defaults if the exercise isn't in
  /// the shown session (e.g. the plan changed meanwhile).
  PlannedExercise _planned(ExerciseProvider exercise) {
    final planned = exercise.plannedFor(widget.exerciseId);
    if (planned != null) return planned;
    final e = ExerciseCatalog.byId(widget.exerciseId)!;
    return PlannedExercise(
      exerciseId: e.id,
      sets: 3,
      reps: e.isTimed ? null : 10,
      durationSeconds: e.isTimed ? 30 : null,
      restSeconds: e.defaultRestSeconds,
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercise = ExerciseCatalog.byId(widget.exerciseId);
    final texts = ExerciseTexts.of(widget.exerciseId);
    if (exercise == null || texts == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.exerciseNotFound)),
      );
    }
    final provider = context.watch<ExerciseProvider>();
    final planned = _planned(provider);
    final weightKg = provider.weightKg;
    final useMetric =
        context.select<ProfileProvider, bool?>((p) => p.profile?.useMetric) ??
        true;
    final textStyle = TextStyle(fontSize: 14.5, color: AppColors.textDark);

    // Only exercises of the shown session can be started.
    final inPlan = provider.plannedFor(exercise.id) != null;
    final done = provider.setsDoneToday(exercise.id);
    final completed = inPlan && done >= planned.sets;

    return Scaffold(
      appBar: AppBar(title: Text(texts.name)),
      bottomNavigationBar: inPlan
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: PrimaryButton(
                  key: const ValueKey('start-workout'),
                  label: completed
                      ? l10n.doneToday
                      : done > 0
                      ? l10n.continueWorkout(done, planned.sets)
                      : l10n.startWorkout,
                  onPressed: completed
                      ? null
                      : () => context.push(
                          AppRoutes.exerciseWorkoutLocation(exercise.id),
                        ),
                ),
              ),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          ExerciseDemoView(
            exerciseId: exercise.id,
            onStep: (step) => setState(() => _step = step),
          ),
          const SizedBox(height: 16),
          ExerciseStatRow(planned: planned),
          const SizedBox(height: 8),
          CalorieEstimateInfo(
            kcal: ExerciseEstimate.plannedKcal(
              exercise,
              planned,
              weightKg: weightKg,
            ),
            met: exercise.met,
            weightKg: weightKg,
            activeSeconds:
                planned.sets *
                ExerciseEstimate.setSeconds(
                  exercise,
                  reps: planned.reps,
                  duration: planned.durationSeconds,
                ),
            useMetric: useMetric,
          ),
          const SizedBox(height: 16),
          EditSection(
            title: l10n.startingPosition,
            child: Text(texts.position, style: textStyle),
          ),
          EditSection(
            title: l10n.howToDoIt,
            child: DemoStepList(steps: texts.steps, current: _step),
          ),
          EditSection(
            title: l10n.formTip,
            child: SafetyNote(
              text: texts.tip,
              icon: Icons.lightbulb_outline_rounded,
            ),
          ),
          EditSection(
            title: l10n.musclesWorked,
            child: MuscleChips(muscles: exercise.muscles),
          ),
          EditSection(
            title: l10n.benefitsTitle,
            child: Text(texts.benefit, style: textStyle),
          ),
          if (planned.why.isNotEmpty)
            EditSection(
              title: l10n.whyInPlan,
              child: Text(planned.why, style: textStyle),
            ),
          SafetyNote(text: l10n.setupSafety),
        ],
      ),
    );
  }
}
