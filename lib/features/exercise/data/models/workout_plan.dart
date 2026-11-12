import 'exercise_settings.dart';

/// Who made the plan: Gemini, or the built-in rules (offline fallback).
enum PlanSource { ai, rules }

/// One exercise in a session, with its prescription.
class PlannedExercise {
  const PlannedExercise({
    required this.exerciseId,
    required this.sets,
    this.reps,
    this.durationSeconds,
    required this.restSeconds,
    this.why = '',
  }) : assert((reps == null) != (durationSeconds == null));

  final String exerciseId;
  final int sets;

  /// Repetitions per set (rep-based exercises).
  final int? reps;

  /// Seconds per set (timed exercises).
  final int? durationSeconds;
  final int restSeconds;

  /// Short reason it is in the plan, from the AI (may be empty).
  final String why;

  Map<String, dynamic> toJson() => {
    'exerciseId': exerciseId,
    'sets': sets,
    'reps': ?reps,
    'durationSeconds': ?durationSeconds,
    'restSeconds': restSeconds,
    'why': why,
  };

  factory PlannedExercise.fromJson(Map<String, dynamic> json) =>
      PlannedExercise(
        exerciseId: json['exerciseId'] as String,
        sets: json['sets'] as int,
        reps: json['reps'] as int?,
        durationSeconds: json['durationSeconds'] as int?,
        restSeconds: json['restSeconds'] as int,
        why: json['why'] as String? ?? '',
      );
}

/// One workout day in the weekly rotation, e.g. "Upper body".
class PlannedSession {
  const PlannedSession({
    required this.name,
    this.focus = '',
    required this.exercises,
  });

  final String name;
  final String focus;
  final List<PlannedExercise> exercises;

  Map<String, dynamic> toJson() => {
    'name': name,
    'focus': focus,
    'exercises': [for (final e in exercises) e.toJson()],
  };

  factory PlannedSession.fromJson(Map<String, dynamic> json) => PlannedSession(
    name: json['name'] as String,
    focus: json['focus'] as String? ?? '',
    exercises: [
      for (final e in json['exercises'] as List)
        PlannedExercise.fromJson(e as Map<String, dynamic>),
    ],
  );
}

/// A weekly plan: [sessions] are done in turn, one per workout day.
class WorkoutPlan {
  const WorkoutPlan({
    required this.id,
    required this.environment,
    required this.createdAt,
    required this.source,
    this.summary = '',
    required this.sessions,
    this.inputsKey = '',
  });

  final String id;
  final WorkoutEnvironment environment;
  final DateTime createdAt;
  final PlanSource source;
  final String summary;
  final List<PlannedSession> sessions;

  /// Fingerprint of the profile and settings it was made for, so the app
  /// can notice when they change and offer a new plan.
  final String inputsKey;

  Map<String, dynamic> toJson() => {
    'id': id,
    'environment': environment.name,
    'createdAt': createdAt.toIso8601String(),
    'source': source.name,
    'summary': summary,
    'sessions': [for (final s in sessions) s.toJson()],
    'inputsKey': inputsKey,
  };

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) => WorkoutPlan(
    id: json['id'] as String,
    environment: WorkoutEnvironment.values.byName(
      json['environment'] as String,
    ),
    createdAt: DateTime.parse(json['createdAt'] as String),
    source: PlanSource.values.byName(json['source'] as String),
    summary: json['summary'] as String? ?? '',
    sessions: [
      for (final s in json['sessions'] as List)
        PlannedSession.fromJson(s as Map<String, dynamic>),
    ],
    inputsKey: json['inputsKey'] as String? ?? '',
  );
}
