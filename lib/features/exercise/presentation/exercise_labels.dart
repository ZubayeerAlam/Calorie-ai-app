import '../../../core/services/rule_based_workout_plan_service.dart';
import '../../../l10n/l10n.dart';
import '../data/catalog/exercise_catalog.dart';
import '../data/models/exercise_settings.dart';
import '../data/models/workout_plan.dart';
import '../data/models/workout_record.dart';

/// Words for the Exercise feature's choices and states.
class ExerciseLabels {
  ExerciseLabels._();

  static String environment(WorkoutEnvironment e) => switch (e) {
    WorkoutEnvironment.home => l10n.envHome,
    WorkoutEnvironment.gym => l10n.envGym,
  };

  static String environmentDescription(WorkoutEnvironment e) => switch (e) {
    WorkoutEnvironment.home => l10n.envHomeDesc,
    WorkoutEnvironment.gym => l10n.envGymDesc,
  };

  static String level(FitnessLevel level) => switch (level) {
    FitnessLevel.beginner => l10n.levelBeginner,
    FitnessLevel.intermediate => l10n.levelIntermediate,
    FitnessLevel.advanced => l10n.levelAdvanced,
  };

  static String equipment(HomeEquipment e) => switch (e) {
    HomeEquipment.dumbbells => l10n.equipDumbbells,
    HomeEquipment.bands => l10n.equipBands,
  };

  static String limitation(BodyLimitation l) => switch (l) {
    BodyLimitation.knees => l10n.limitKnees,
    BodyLimitation.lowerBack => l10n.limitLowerBack,
    BodyLimitation.shoulders => l10n.limitShoulders,
    BodyLimitation.wrists => l10n.limitWrists,
  };

  static String status(ExerciseStatus status) => switch (status) {
    ExerciseStatus.notStarted => l10n.statusNotStarted,
    ExerciseStatus.inProgress => l10n.statusInProgress,
    ExerciseStatus.completed => l10n.statusCompleted,
  };

  /// One set's target: "12 reps", "30 s" or, for long sets, "8 min".
  static String target(PlannedExercise p) {
    final seconds = p.durationSeconds;
    if (seconds == null) return l10n.repsCount(p.reps ?? 0);
    if (seconds >= 120) return l10n.minutesShort((seconds / 60).round());
    return l10n.secondsShort(seconds);
  }

  /// "3 × 12" or "3 × 30 s".
  static String setsTimesTarget(PlannedExercise p) {
    final seconds = p.durationSeconds;
    final target = seconds == null
        ? '${p.reps ?? 0}'
        : seconds >= 120
        ? l10n.minutesShort((seconds / 60).round())
        : l10n.secondsShort(seconds);
    return l10n.setsTimesReps(p.sets, target);
  }

  /// A plan's summary. Plans made without AI are worded in the current
  /// language; AI plans keep the language they were made in.
  static String planSummary(WorkoutPlan plan) => plan.source == PlanSource.rules
      ? RuleBasedWorkoutPlanService.summary(plan.sessions.length)
      : plan.summary;

  static String sessionName(WorkoutPlan plan, int index) =>
      plan.source == PlanSource.rules
      ? RuleBasedWorkoutPlanService.sessionName(plan.sessions.length, index)
      : plan.sessions[index].name;

  static String sessionFocus(WorkoutPlan plan, int index) =>
      plan.source == PlanSource.rules
      ? RuleBasedWorkoutPlanService.sessionFocus(plan.sessions.length, index)
      : plan.sessions[index].focus;

  /// True for exercises measured in time (for icons).
  static bool isTimed(PlannedExercise p) =>
      ExerciseCatalog.byId(p.exerciseId)?.isTimed ?? p.durationSeconds != null;
}
