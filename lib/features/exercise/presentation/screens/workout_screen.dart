import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../data/catalog/exercise_catalog.dart';
import '../../data/catalog/exercise_texts.dart';
import '../../data/exercise_estimate.dart';
import '../../data/models/exercise.dart';
import '../../data/models/workout_plan.dart';
import '../../providers/exercise_provider.dart';
import '../../providers/workout_run_controller.dart';
import '../exercise_labels.dart';
import '../widgets/exercise_demo_view.dart';
import '../widgets/primary_button.dart';
import '../widgets/rest_timer.dart';
import '../widgets/set_indicator.dart';
import '../widgets/set_target.dart';
import '../widgets/workout_done_view.dart';

/// Doing one exercise of today's plan, set by set, with rests between.
///
/// Every finished set is saved right away, so leaving (End early, Back)
/// keeps the progress, and opening the exercise again carries on.
class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  WorkoutRunController? _run;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ExerciseProvider>();
    final exercise = ExerciseCatalog.byId(widget.exerciseId);
    final planned = provider.plannedFor(widget.exerciseId);
    if (exercise == null || planned == null) return;
    _run = WorkoutRunController(
      exercise: exercise,
      planned: planned,
      setsDone: provider.setsDoneToday(widget.exerciseId),
      onSets: (sets) => provider.recordSets(widget.exerciseId, sets),
      onAlert: HapticFeedback.heavyImpact,
    );
    // Countdowns use end times; this only refreshes the display.
    _timer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => _run?.tick(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _run?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final run = _run;
    final name = ExerciseTexts.nameOf(widget.exerciseId);
    if (run == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.exerciseNotFound)),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListenableBuilder(
        listenable: run,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            if (run.phase != RunPhase.done) ...[
              ExerciseDemoView(exerciseId: widget.exerciseId),
              const SizedBox(height: 16),
              SetIndicator(
                current: run.currentSet,
                total: run.totalSets,
                done: run.setsDone,
              ),
              const SizedBox(height: 20),
            ],
            ..._phase(context, run),
          ],
        ),
      ),
    );
  }

  List<Widget> _phase(BuildContext context, WorkoutRunController run) {
    final planned = run.planned;
    return switch (run.phase) {
      RunPhase.ready => [
        Text(
          '${ExerciseLabels.setsTimesTarget(planned)} · '
          '${l10n.statRest} ${l10n.secondsShort(planned.restSeconds)}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.getReadyHint,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: AppColors.textGrey),
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          key: const ValueKey('start-sets'),
          label: run.setsDone > 0
              ? l10n.continueWorkout(run.setsDone, run.totalSets)
              : l10n.startWorkout,
          onPressed: run.start,
        ),
      ],
      RunPhase.working => [
        SetTarget(
          reps: planned.reps,
          secondsLeft: run.secondsLeft,
          totalSeconds: planned.durationSeconds,
          timeUp: run.timeUp,
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          key: const ValueKey('finish-set'),
          label: run.currentSet == run.totalSets
              ? l10n.doneLastSet
              : l10n.doneNextSet,
          onPressed: run.finishSet,
        ),
        const SizedBox(height: 4),
        _SecondaryActions(run: run),
      ],
      RunPhase.resting => [
        RestTimer(
          secondsLeft: run.secondsLeft ?? 0,
          totalSeconds: planned.restSeconds,
          nextSet: run.currentSet,
          totalSets: run.totalSets,
          onAddTime: run.addRest,
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          key: const ValueKey('skip-rest'),
          label: l10n.skipRest,
          onPressed: run.skipRest,
        ),
        const SizedBox(height: 4),
        _SecondaryActions(run: run),
      ],
      RunPhase.done => [_done(context, run.exercise, planned)],
    };
  }

  Widget _done(
    BuildContext context,
    Exercise exercise,
    PlannedExercise planned,
  ) {
    final provider = context.watch<ExerciseProvider>();
    final next = provider.nextExerciseAfter(widget.exerciseId);
    final kcal = ExerciseEstimate.plannedKcal(
      exercise,
      planned,
      weightKg: provider.weightKg,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: WorkoutDoneView(
        sets: planned.sets,
        kcal: ExerciseEstimate.displayKcal(kcal),
        workoutComplete: provider.sessionCompleted,
        onNext: next == null
            ? null
            : () => context.pushReplacement(
                AppRoutes.exerciseWorkoutLocation(next),
              ),
        onBack: () => context.pop(),
      ),
    );
  }
}

/// "Complete exercise" and "End early", under the main button.
class _SecondaryActions extends StatelessWidget {
  const _SecondaryActions({required this.run});

  final WorkoutRunController run;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: [
        TextButton(
          key: const ValueKey('complete-exercise'),
          onPressed: run.completeExercise,
          child: Text(l10n.completeExercise),
        ),
        TextButton(
          key: const ValueKey('end-early'),
          onPressed: () => context.pop(),
          child: Text(l10n.endEarly),
        ),
      ],
    );
  }
}
