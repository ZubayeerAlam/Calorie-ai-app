import '../models/exercise.dart';
import '../models/exercise_settings.dart';

const _home = {WorkoutEnvironment.home};
const _gym = {WorkoutEnvironment.gym};
const _both = {WorkoutEnvironment.home, WorkoutEnvironment.gym};

const _knees = BodyLimitation.knees;
const _back = BodyLimitation.lowerBack;
const _shoulders = BodyLimitation.shoulders;
const _wrists = BodyLimitation.wrists;

/// The exercises plans are built from.
///
/// MET values are taken from the Compendium of Physical Activities
/// (calisthenics, resistance training and cardio machines at a moderate
/// effort). Names and instructions are in the ARB files (see
/// `ExerciseTexts`).
class ExerciseCatalog {
  ExerciseCatalog._();

  static const List<Exercise> all = [
    // Home, bodyweight (most also work in a gym).
    Exercise(
      id: 'push_up',
      environments: _both,
      equipment: Equipment.none,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.push,
      muscles: [MuscleGroup.chest, MuscleGroup.shoulders, MuscleGroup.triceps],
      met: 3.8,
      avoidWith: {_shoulders, _wrists},
    ),
    Exercise(
      id: 'knee_push_up',
      environments: _home,
      equipment: Equipment.none,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.push,
      muscles: [MuscleGroup.chest, MuscleGroup.shoulders, MuscleGroup.triceps],
      met: 3.0,
      avoidWith: {_wrists},
    ),
    Exercise(
      id: 'incline_push_up',
      environments: _home,
      equipment: Equipment.none,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.push,
      muscles: [MuscleGroup.chest, MuscleGroup.shoulders, MuscleGroup.triceps],
      met: 3.0,
      avoidWith: {_wrists},
    ),
    Exercise(
      id: 'squat',
      environments: _both,
      equipment: Equipment.none,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.legs,
      muscles: [MuscleGroup.quads, MuscleGroup.glutes, MuscleGroup.hamstrings],
      met: 5.0,
      avoidWith: {_knees},
    ),
    Exercise(
      id: 'lunge',
      environments: _both,
      equipment: Equipment.none,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.legs,
      muscles: [MuscleGroup.quads, MuscleGroup.glutes, MuscleGroup.hamstrings],
      met: 4.0,
      avoidWith: {_knees},
    ),
    Exercise(
      id: 'glute_bridge',
      environments: _both,
      equipment: Equipment.none,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.legs,
      muscles: [MuscleGroup.glutes, MuscleGroup.hamstrings, MuscleGroup.core],
      met: 3.0,
      defaultRestSeconds: 45,
    ),
    Exercise(
      id: 'plank',
      environments: _both,
      equipment: Equipment.none,
      kind: ExerciseKind.timed,
      pattern: MovementPattern.core,
      muscles: [MuscleGroup.core, MuscleGroup.shoulders],
      met: 3.0,
      defaultRestSeconds: 45,
      avoidWith: {_wrists},
    ),
    Exercise(
      id: 'side_plank',
      environments: _both,
      equipment: Equipment.none,
      kind: ExerciseKind.timed,
      pattern: MovementPattern.core,
      muscles: [MuscleGroup.core, MuscleGroup.shoulders],
      met: 3.0,
      defaultRestSeconds: 45,
      avoidWith: {_shoulders},
    ),
    Exercise(
      id: 'mountain_climber',
      environments: _both,
      equipment: Equipment.none,
      kind: ExerciseKind.timed,
      pattern: MovementPattern.cardio,
      muscles: [MuscleGroup.core, MuscleGroup.shoulders, MuscleGroup.heart],
      met: 8.0,
      defaultRestSeconds: 45,
      avoidWith: {_wrists},
    ),
    Exercise(
      id: 'jumping_jack',
      environments: _home,
      equipment: Equipment.none,
      kind: ExerciseKind.timed,
      pattern: MovementPattern.cardio,
      muscles: [MuscleGroup.fullBody, MuscleGroup.heart],
      met: 7.7,
      defaultRestSeconds: 30,
      avoidWith: {_knees},
    ),
    Exercise(
      id: 'high_knees',
      environments: _home,
      equipment: Equipment.none,
      kind: ExerciseKind.timed,
      pattern: MovementPattern.cardio,
      muscles: [MuscleGroup.quads, MuscleGroup.core, MuscleGroup.heart],
      met: 8.0,
      defaultRestSeconds: 30,
      avoidWith: {_knees},
    ),
    // Low impact: still possible with every limitation.
    Exercise(
      id: 'march_in_place',
      environments: _home,
      equipment: Equipment.none,
      kind: ExerciseKind.timed,
      pattern: MovementPattern.cardio,
      muscles: [MuscleGroup.heart, MuscleGroup.quads],
      met: 3.5,
      defaultRestSeconds: 30,
    ),
    Exercise(
      id: 'superman',
      environments: _home,
      equipment: Equipment.none,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.pull,
      muscles: [MuscleGroup.back, MuscleGroup.glutes],
      met: 2.5,
      defaultRestSeconds: 45,
      avoidWith: {_back},
    ),
    Exercise(
      id: 'bird_dog',
      environments: _both,
      equipment: Equipment.none,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.core,
      muscles: [MuscleGroup.core, MuscleGroup.back, MuscleGroup.glutes],
      met: 2.5,
      secondsPerRep: 4,
      defaultRestSeconds: 45,
    ),
    Exercise(
      id: 'wall_sit',
      environments: _home,
      equipment: Equipment.none,
      kind: ExerciseKind.timed,
      pattern: MovementPattern.legs,
      muscles: [MuscleGroup.quads, MuscleGroup.glutes],
      met: 3.0,
      defaultRestSeconds: 45,
      avoidWith: {_knees},
    ),
    Exercise(
      id: 'chair_dip',
      environments: _home,
      equipment: Equipment.none,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.push,
      muscles: [MuscleGroup.triceps, MuscleGroup.shoulders, MuscleGroup.chest],
      met: 3.5,
      avoidWith: {_shoulders, _wrists},
    ),
    Exercise(
      id: 'step_up',
      environments: _home,
      equipment: Equipment.none,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.legs,
      muscles: [MuscleGroup.quads, MuscleGroup.glutes],
      met: 4.5,
      avoidWith: {_knees},
    ),
    Exercise(
      id: 'calf_raise',
      environments: _both,
      equipment: Equipment.none,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.legs,
      muscles: [MuscleGroup.calves],
      met: 2.8,
      secondsPerRep: 2,
      defaultRestSeconds: 45,
    ),
    Exercise(
      id: 'dead_bug',
      environments: _both,
      equipment: Equipment.none,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.core,
      muscles: [MuscleGroup.core],
      met: 2.8,
      secondsPerRep: 4,
      defaultRestSeconds: 45,
    ),

    // Home with dumbbells or bands; dumbbells are in every gym too.
    Exercise(
      id: 'goblet_squat',
      environments: _both,
      equipment: Equipment.dumbbells,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.legs,
      muscles: [MuscleGroup.quads, MuscleGroup.glutes, MuscleGroup.core],
      met: 5.0,
      defaultRestSeconds: 75,
      avoidWith: {_knees},
    ),
    Exercise(
      id: 'dumbbell_row',
      environments: _both,
      equipment: Equipment.dumbbells,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.pull,
      muscles: [MuscleGroup.back, MuscleGroup.biceps],
      met: 3.5,
      avoidWith: {_back},
    ),
    Exercise(
      id: 'shoulder_press',
      environments: _both,
      equipment: Equipment.dumbbells,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.push,
      muscles: [MuscleGroup.shoulders, MuscleGroup.triceps],
      met: 3.5,
      avoidWith: {_shoulders},
    ),
    Exercise(
      id: 'romanian_deadlift',
      environments: _both,
      equipment: Equipment.dumbbells,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.legs,
      muscles: [MuscleGroup.hamstrings, MuscleGroup.glutes, MuscleGroup.back],
      met: 3.5,
      defaultRestSeconds: 75,
      avoidWith: {_back},
    ),
    Exercise(
      id: 'bicep_curl',
      environments: _both,
      equipment: Equipment.dumbbells,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.pull,
      muscles: [MuscleGroup.biceps],
      met: 3.0,
      defaultRestSeconds: 45,
    ),
    Exercise(
      id: 'band_row',
      environments: _home,
      equipment: Equipment.bands,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.pull,
      muscles: [MuscleGroup.back, MuscleGroup.biceps],
      met: 3.0,
      defaultRestSeconds: 45,
    ),
    Exercise(
      id: 'band_pull_apart',
      environments: _home,
      equipment: Equipment.bands,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.pull,
      muscles: [MuscleGroup.shoulders, MuscleGroup.back],
      met: 2.8,
      secondsPerRep: 2,
      defaultRestSeconds: 45,
    ),

    // Gym machines.
    Exercise(
      id: 'leg_press',
      environments: _gym,
      equipment: Equipment.gym,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.legs,
      muscles: [MuscleGroup.quads, MuscleGroup.glutes, MuscleGroup.hamstrings],
      met: 5.0,
      defaultRestSeconds: 90,
      avoidWith: {_knees},
    ),
    Exercise(
      id: 'lat_pulldown',
      environments: _gym,
      equipment: Equipment.gym,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.pull,
      muscles: [MuscleGroup.back, MuscleGroup.biceps],
      met: 3.5,
      avoidWith: {_shoulders},
    ),
    Exercise(
      id: 'seated_cable_row',
      environments: _gym,
      equipment: Equipment.gym,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.pull,
      muscles: [MuscleGroup.back, MuscleGroup.biceps],
      met: 3.5,
    ),
    Exercise(
      id: 'chest_press',
      environments: _gym,
      equipment: Equipment.gym,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.push,
      muscles: [MuscleGroup.chest, MuscleGroup.shoulders, MuscleGroup.triceps],
      met: 3.5,
    ),
    Exercise(
      id: 'dumbbell_bench_press',
      environments: _gym,
      equipment: Equipment.dumbbells,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.push,
      muscles: [MuscleGroup.chest, MuscleGroup.shoulders, MuscleGroup.triceps],
      met: 3.5,
      defaultRestSeconds: 75,
      avoidWith: {_shoulders},
    ),
    Exercise(
      id: 'leg_curl',
      environments: _gym,
      equipment: Equipment.gym,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.legs,
      muscles: [MuscleGroup.hamstrings],
      met: 3.5,
    ),
    Exercise(
      id: 'triceps_pushdown',
      environments: _gym,
      equipment: Equipment.gym,
      kind: ExerciseKind.reps,
      pattern: MovementPattern.push,
      muscles: [MuscleGroup.triceps],
      met: 3.0,
      defaultRestSeconds: 45,
    ),
    Exercise(
      id: 'treadmill_incline_walk',
      environments: _gym,
      equipment: Equipment.gym,
      kind: ExerciseKind.timed,
      pattern: MovementPattern.cardio,
      muscles: [MuscleGroup.heart, MuscleGroup.glutes, MuscleGroup.calves],
      met: 5.3,
      defaultRestSeconds: 30,
    ),
    Exercise(
      id: 'stationary_bike',
      environments: _gym,
      equipment: Equipment.gym,
      kind: ExerciseKind.timed,
      pattern: MovementPattern.cardio,
      muscles: [MuscleGroup.heart, MuscleGroup.quads],
      met: 6.8,
      defaultRestSeconds: 30,
    ),
    Exercise(
      id: 'rowing_machine',
      environments: _gym,
      equipment: Equipment.gym,
      kind: ExerciseKind.timed,
      pattern: MovementPattern.cardio,
      muscles: [MuscleGroup.heart, MuscleGroup.back, MuscleGroup.quads],
      met: 7.0,
      defaultRestSeconds: 45,
      avoidWith: {_back},
    ),
  ];

  static final Map<String, Exercise> _byId = {for (final e in all) e.id: e};

  /// The exercise with [id], or null for an unknown id.
  static Exercise? byId(String id) => _byId[id];

  /// Exercises that suit [settings]: the right place, equipment the user
  /// has (at home), and nothing that loads a limited body area.
  static List<Exercise> allowedFor(ExerciseSettings settings) => [
    for (final e in all)
      if (e.environments.contains(settings.environment) &&
          _hasEquipment(e, settings) &&
          e.avoidWith.intersection(settings.limitations).isEmpty)
        e,
  ];

  static bool _hasEquipment(Exercise e, ExerciseSettings settings) =>
      switch (e.equipment) {
        Equipment.none || Equipment.gym => true,
        Equipment.dumbbells =>
          settings.environment == WorkoutEnvironment.gym ||
              settings.homeEquipment.contains(HomeEquipment.dumbbells),
        Equipment.bands => settings.homeEquipment.contains(HomeEquipment.bands),
      };
}
