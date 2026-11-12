import 'exercise_settings.dart';

/// How a set is measured: a number of repetitions, or a time.
enum ExerciseKind { reps, timed }

/// What an exercise needs. [none] is bodyweight only (a chair, wall or
/// mat at most); [gym] is a gym machine.
enum Equipment { none, dumbbells, bands, gym }

/// The movement type, used to build balanced sessions.
enum MovementPattern { push, pull, legs, core, cardio }

enum MuscleGroup {
  chest,
  shoulders,
  triceps,
  biceps,
  back,
  core,
  glutes,
  quads,
  hamstrings,
  calves,
  fullBody,
  heart,
}

/// One exercise in the curated catalog (see `ExerciseCatalog`).
///
/// The AI only picks exercises from the catalog and sets the sets, reps
/// and rest, so every exercise it suggests has instructions, a
/// demonstration and a known MET value.
class Exercise {
  const Exercise({
    required this.id,
    required this.environments,
    required this.equipment,
    required this.kind,
    required this.pattern,
    required this.muscles,
    required this.met,
    this.secondsPerRep = 3,
    this.defaultRestSeconds = 60,
    this.avoidWith = const {},
  });

  /// Stable id, e.g. `push_up` (stored in plans and history).
  final String id;
  final Set<WorkoutEnvironment> environments;
  final Equipment equipment;
  final ExerciseKind kind;
  final MovementPattern pattern;

  /// Main muscles first.
  final List<MuscleGroup> muscles;

  /// Metabolic equivalent while doing the exercise (Compendium of
  /// Physical Activities); 1 MET is resting.
  final double met;

  /// Typical time for one repetition, for [ExerciseKind.reps] exercises.
  final double secondsPerRep;
  final int defaultRestSeconds;

  /// Left out of plans for users with these limitations.
  final Set<BodyLimitation> avoidWith;

  bool get isTimed => kind == ExerciseKind.timed;
}
