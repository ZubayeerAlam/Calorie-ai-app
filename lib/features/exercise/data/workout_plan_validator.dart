import 'dart:math' as math;

import '../../../core/services/workout_plan_service.dart';
import '../../../l10n/l10n.dart';
import 'catalog/exercise_catalog.dart';
import 'exercise_estimate.dart';
import 'models/exercise.dart';
import 'models/workout_plan.dart';
import 'workout_plan_request.dart';

/// Turns a plan in JSON (from the AI) into a safe [WorkoutPlan].
///
/// The AI's choices are kept where they are sensible and corrected where
/// not:
/// - exercises not allowed for the user (unknown, wrong place or
///   equipment, a limitation) and repeats within a session are dropped;
/// - sets, reps, time and rest are kept within safe ranges;
/// - each session keeps at most [maxExercises], and exercises are removed
///   from the end while it runs well over the chosen minutes;
/// - sessions with fewer than [minExercises] are dropped, and there are at
///   most as many sessions as workout days.
///
/// Throws [WorkoutPlanException] (invalid response) if no session is left.
class WorkoutPlanValidator {
  WorkoutPlanValidator._();

  static const int minExercises = 3;
  static const int maxExercises = 8;
  static const int maxSets = 5;
  static const int minReps = 4;
  static const int maxReps = 25;
  static const int minSeconds = 15;

  /// Longest set for bodyweight holds and moves.
  static const int maxSeconds = 120;

  /// Longest set on a cardio machine (treadmill, bike, rower).
  static const int maxMachineSeconds = 900;
  static const int minRest = 20;
  static const int maxRest = 150;
  static const int maxWhyLength = 120;
  static const int maxSummaryLength = 200;

  /// A session may run this much over the chosen minutes before it is cut.
  static const double timeAllowance = 1.25;

  static WorkoutPlan validate(
    Map<String, dynamic> json,
    WorkoutPlanRequest request, {
    required String id,
    required PlanSource source,
  }) {
    final rawSessions = json['sessions'];
    if (rawSessions is! List) throw _invalid('No sessions');

    final sessions = <PlannedSession>[];
    for (final raw in rawSessions) {
      if (sessions.length >= request.sessionsPerWeek) break;
      if (raw is! Map<String, dynamic>) continue;
      final session = _session(raw, request, sessions.length);
      if (session != null) sessions.add(session);
    }
    if (sessions.isEmpty) throw _invalid('No usable session');

    return WorkoutPlan(
      id: id,
      environment: request.settings.environment,
      createdAt: request.now,
      source: source,
      summary: _text(json['summary'], maxSummaryLength),
      sessions: sessions,
      inputsKey: request.inputsKey,
    );
  }

  static PlannedSession? _session(
    Map<String, dynamic> json,
    WorkoutPlanRequest request,
    int index,
  ) {
    final rawExercises = json['exercises'];
    if (rawExercises is! List) return null;
    final exercises = <PlannedExercise>[];
    final used = <String>{};
    for (final raw in rawExercises) {
      if (exercises.length >= maxExercises) break;
      if (raw is! Map<String, dynamic>) continue;
      final id = raw['exerciseId'];
      if (id is! String || !request.allowedIds.contains(id)) continue;
      if (!used.add(id)) continue;
      exercises.add(_exercise(ExerciseCatalog.byId(id)!, raw));
    }

    // Trim from the end while the session is well over the time.
    final limit = request.settings.sessionMinutes * 60 * timeAllowance;
    while (exercises.length > minExercises && _seconds(exercises) > limit) {
      exercises.removeLast();
    }
    if (exercises.length < minExercises) return null;

    final name = _text(json['name'], 40);
    return PlannedSession(
      // "Day A", "Day B", … when the AI gave no name.
      name: name.isEmpty ? l10n.planDay(String.fromCharCode(65 + index)) : name,
      focus: _text(json['focus'], 80),
      exercises: exercises,
    );
  }

  static PlannedExercise _exercise(Exercise e, Map<String, dynamic> json) {
    final sets = _int(json['sets'], 3).clamp(1, maxSets);
    final rest = _int(
      json['restSeconds'],
      e.defaultRestSeconds,
    ).clamp(minRest, maxRest);
    final why = _text(json['why'], maxWhyLength);
    if (e.isTimed) {
      final max = e.equipment == Equipment.gym ? maxMachineSeconds : maxSeconds;
      return PlannedExercise(
        exerciseId: e.id,
        sets: sets,
        durationSeconds: _int(
          json['durationSeconds'],
          30,
        ).clamp(minSeconds, max),
        restSeconds: rest,
        why: why,
      );
    }
    return PlannedExercise(
      exerciseId: e.id,
      sets: sets,
      reps: _int(json['reps'], 10).clamp(minReps, maxReps),
      restSeconds: rest,
      why: why,
    );
  }

  /// A session's time: every exercise's sets and rests, plus a rest
  /// between exercises.
  static double _seconds(List<PlannedExercise> exercises) {
    var total = 0.0;
    for (final p in exercises) {
      total +=
          ExerciseEstimate.plannedSeconds(
            ExerciseCatalog.byId(p.exerciseId)!,
            p,
          ) +
          p.restSeconds;
    }
    return total;
  }

  /// Session time in seconds (for display and the rule-based planner).
  static double sessionSeconds(PlannedSession session) =>
      _seconds(session.exercises);

  static int _int(Object? value, int fallback) =>
      value is num && value.isFinite ? value.round() : fallback;

  static String _text(Object? value, int max) {
    if (value is! String) return '';
    final text = value.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (text.length <= max) return text;
    return '${text.substring(0, math.max(0, max - 1)).trimRight()}…';
  }

  static WorkoutPlanException _invalid(String message) =>
      WorkoutPlanException(WorkoutPlanFailure.invalidResponse, message);
}
