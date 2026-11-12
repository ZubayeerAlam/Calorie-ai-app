import 'exercise_settings.dart';

/// Where one exercise of a workout stands.
enum ExerciseStatus { notStarted, inProgress, completed }

/// Where a whole workout stands. [partial] means it was ended early.
enum WorkoutStatus { inProgress, completed, partial }

/// One exercise as done in a workout.
class ExerciseRecord {
  const ExerciseRecord({
    required this.exerciseId,
    required this.setsTarget,
    this.setsDone = 0,
    this.reps,
    this.durationSeconds,
    this.estimatedKcal = 0,
  });

  final String exerciseId;
  final int setsTarget;
  final int setsDone;

  /// Reps per set, or seconds per set for timed exercises.
  final int? reps;
  final int? durationSeconds;

  /// Net kcal for the sets done (an estimate, see `ExerciseEstimate`).
  final double estimatedKcal;

  ExerciseStatus get status => setsDone <= 0
      ? ExerciseStatus.notStarted
      : setsDone >= setsTarget
      ? ExerciseStatus.completed
      : ExerciseStatus.inProgress;

  ExerciseRecord copyWith({int? setsDone, double? estimatedKcal}) =>
      ExerciseRecord(
        exerciseId: exerciseId,
        setsTarget: setsTarget,
        setsDone: setsDone ?? this.setsDone,
        reps: reps,
        durationSeconds: durationSeconds,
        estimatedKcal: estimatedKcal ?? this.estimatedKcal,
      );

  Map<String, dynamic> toJson() => {
    'exerciseId': exerciseId,
    'setsTarget': setsTarget,
    'setsDone': setsDone,
    'reps': ?reps,
    'durationSeconds': ?durationSeconds,
    'estimatedKcal': estimatedKcal,
  };

  factory ExerciseRecord.fromJson(Map<String, dynamic> json) => ExerciseRecord(
    exerciseId: json['exerciseId'] as String,
    setsTarget: json['setsTarget'] as int,
    setsDone: json['setsDone'] as int? ?? 0,
    reps: json['reps'] as int?,
    durationSeconds: json['durationSeconds'] as int?,
    estimatedKcal: (json['estimatedKcal'] as num?)?.toDouble() ?? 0,
  );
}

/// One workout session as done on a day: what was done and when.
class WorkoutRecord {
  const WorkoutRecord({
    required this.id,
    required this.startedAt,
    this.endedAt,
    required this.planId,
    required this.sessionIndex,
    required this.environment,
    this.status = WorkoutStatus.inProgress,
    required this.exercises,
  });

  final String id;
  final DateTime startedAt;

  /// Set when the workout is completed or ended early.
  final DateTime? endedAt;
  final String planId;

  /// Which session of the plan this was.
  final int sessionIndex;
  final WorkoutEnvironment environment;
  final WorkoutStatus status;
  final List<ExerciseRecord> exercises;

  /// The day the workout counts for.
  DateTime get date => DateTime(startedAt.year, startedAt.month, startedAt.day);

  double get estimatedKcal =>
      exercises.fold(0, (sum, e) => sum + e.estimatedKcal);

  int get completedExercises =>
      exercises.where((e) => e.status == ExerciseStatus.completed).length;

  bool get isFinished => status != WorkoutStatus.inProgress;

  WorkoutRecord copyWith({
    DateTime? endedAt,
    WorkoutStatus? status,
    List<ExerciseRecord>? exercises,
  }) => WorkoutRecord(
    id: id,
    startedAt: startedAt,
    endedAt: endedAt ?? this.endedAt,
    planId: planId,
    sessionIndex: sessionIndex,
    environment: environment,
    status: status ?? this.status,
    exercises: exercises ?? this.exercises,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'startedAt': startedAt.toIso8601String(),
    'endedAt': ?endedAt?.toIso8601String(),
    'planId': planId,
    'sessionIndex': sessionIndex,
    'environment': environment.name,
    'status': status.name,
    'exercises': [for (final e in exercises) e.toJson()],
  };

  factory WorkoutRecord.fromJson(Map<String, dynamic> json) => WorkoutRecord(
    id: json['id'] as String,
    startedAt: DateTime.parse(json['startedAt'] as String),
    endedAt: switch (json['endedAt']) {
      final String s => DateTime.parse(s),
      _ => null,
    },
    planId: json['planId'] as String,
    sessionIndex: json['sessionIndex'] as int,
    environment: WorkoutEnvironment.values.byName(
      json['environment'] as String,
    ),
    status: WorkoutStatus.values.byName(json['status'] as String),
    exercises: [
      for (final e in json['exercises'] as List)
        ExerciseRecord.fromJson(e as Map<String, dynamic>),
    ],
  );
}
