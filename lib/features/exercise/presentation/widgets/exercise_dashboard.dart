import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../data/exercise_estimate.dart';
import '../../providers/exercise_provider.dart';
import 'exercise_card.dart';
import 'exercise_grid.dart';
import 'plan_notice.dart';
import 'safety_note.dart';
import 'session_switcher.dart';
import 'workout_progress_header.dart';

/// The plan's session for the day: notices, the session chips, progress
/// and a two-column grid of exercise cards.
class ExerciseDashboard extends StatelessWidget {
  const ExerciseDashboard({super.key, this.onOpenExercise});

  /// Opens an exercise's demo and instructions.
  final void Function(String exerciseId)? onOpenExercise;

  @override
  Widget build(BuildContext context) {
    final exercise = context.watch<ExerciseProvider>();
    final plan = exercise.plan!;
    final session = exercise.selectedSession;
    final today = exercise.todaySessionIndex;
    final selected = exercise.selectedSessionIndex;
    final busy = exercise.generating;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        if (exercise.madeWithoutAi) ...[
          PlanNotice(
            key: const ValueKey('notice-offline'),
            icon: Icons.cloud_off_rounded,
            message: l10n.planMadeOffline,
            actionLabel: l10n.planTryAi,
            onAction: busy ? null : exercise.generate,
          ),
          const SizedBox(height: 12),
        ] else if (exercise.planOutdated) ...[
          PlanNotice(
            key: const ValueKey('notice-outdated'),
            icon: Icons.update_rounded,
            message: l10n.planOutdated,
            actionLabel: l10n.planUpdate,
            onAction: busy ? null : exercise.generate,
          ),
          const SizedBox(height: 12),
        ],
        if (plan.summary.isNotEmpty) ...[
          Text(
            plan.summary,
            style: TextStyle(fontSize: 14, color: AppColors.textGrey),
          ),
          const SizedBox(height: 12),
        ],
        if (plan.sessions.length > 1) ...[
          SessionSwitcher(
            sessions: plan.sessions,
            selected: selected,
            today: today,
            onSelected: exercise.selectSession,
          ),
          const SizedBox(height: 12),
        ],
        if (session != null) ...[
          WorkoutProgressHeader(
            title: selected == today ? l10n.todaysWorkout : session.name,
            total: exercise.totalExercises,
            done: exercise.completedExercises,
            minutes: exercise.estimatedMinutes,
            kcal: ExerciseEstimate.displayKcal(exercise.estimatedKcal),
          ),
          if (session.focus.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              session.focus,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
          const SizedBox(height: 12),
          ExerciseGrid(
            children: [
              for (final planned in session.exercises)
                ExerciseCard(
                  key: ValueKey('exercise-${planned.exerciseId}'),
                  planned: planned,
                  status: exercise.statusOf(planned.exerciseId),
                  kcal: exercise.plannedKcal(planned),
                  onTap: onOpenExercise == null
                      ? null
                      : () => onOpenExercise!(planned.exerciseId),
                ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        SafetyNote(text: l10n.kcalDisclaimer),
      ],
    );
  }
}
