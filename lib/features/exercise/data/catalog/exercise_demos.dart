import 'dart:ui' show Offset;

import '../models/exercise_demo.dart';

/// Key poses for every exercise in the catalog (see [ExerciseDemo] for how
/// the angles work). The first pose is the starting position; the steps
/// in the instructions follow the poses.
class ExerciseDemos {
  ExerciseDemos._();

  static const _mat = [DemoProp(PropKind.mat)];

  static const Map<String, ExerciseDemo> _all = {
    'push_up': ExerciseDemo(
      pin: Joint.handNear,
      props: _mat,
      poses: [
        Pose(torso: 67, legNear: (-67, -67)),
        Pose(torso: 75, armNear: (-60, 35), legNear: (-75, -75)),
      ],
    ),
    'knee_push_up': ExerciseDemo(
      pin: Joint.handNear,
      props: _mat,
      poses: [
        Pose(torso: 55, legNear: (-55, -110)),
        Pose(torso: 68, armNear: (-60, 35), legNear: (-68, -110)),
      ],
    ),
    'incline_push_up': ExerciseDemo(
      pin: Joint.handNear,
      props: [DemoProp(PropKind.chair, anchor: Joint.handNear, dx: 0.04)],
      poses: [
        Pose(torso: 44, armNear: (10, 10), legNear: (-44, -44)),
        Pose(torso: 54, armNear: (-55, 40), legNear: (-54, -54)),
      ],
    ),
    'squat': ExerciseDemo(
      poses: [
        Pose(armNear: (10, 10)),
        Pose(torso: 35, armNear: (90, 90), legNear: (80, -30)),
      ],
    ),
    'lunge': ExerciseDemo(
      poses: [
        Pose(armNear: (-20, 60)),
        Pose(armNear: (-20, 60), legNear: (85, 0), legFar: (-30, -80)),
      ],
    ),
    'glute_bridge': ExerciseDemo(
      props: _mat,
      poses: [
        Pose(torso: -90, armNear: (90, 90), legNear: (135, 45)),
        Pose(torso: -110, armNear: (70, 90), legNear: (110, 41)),
      ],
    ),
    'plank': ExerciseDemo(
      pin: Joint.handNear,
      props: _mat,
      seconds: 3.2,
      poses: [
        Pose(torso: 78, armNear: (0, 90), legNear: (-78, -78)),
        Pose(torso: 76, armNear: (0, 90), legNear: (-80, -80)),
      ],
    ),
    'side_plank': ExerciseDemo(
      pin: Joint.handNear,
      props: _mat,
      seconds: 3.2,
      poses: [
        Pose(
          torso: 68,
          armNear: (0, 90),
          armFar: (30, 30),
          legNear: (-68, -68),
        ),
        Pose(
          torso: 66,
          armNear: (0, 90),
          armFar: (180, 180),
          legNear: (-66, -66),
        ),
      ],
    ),
    'mountain_climber': ExerciseDemo(
      pin: Joint.handNear,
      props: _mat,
      seconds: 1.2,
      poses: [
        Pose(torso: 67, legNear: (40, -60), legFar: (-67, -67)),
        Pose(torso: 67, legNear: (-67, -67), legFar: (40, -60)),
      ],
    ),
    'jumping_jack': ExerciseDemo(
      seconds: 1.2,
      poses: [
        Pose(armNear: (5, 5), armFar: (-5, -5)),
        Pose(
          armNear: (165, 175),
          armFar: (-165, -175),
          legNear: (10, 5),
          legFar: (-10, -5),
          raise: 0.03,
        ),
      ],
    ),
    'high_knees': ExerciseDemo(
      pin: Joint.hip,
      seconds: 1.0,
      poses: [
        Pose(
          armNear: (-35, 30),
          armFar: (40, 120),
          legNear: (90, -10),
          legFar: (0, 0),
          raise: 0.02,
        ),
        Pose(
          armNear: (40, 120),
          armFar: (-35, 30),
          legFar: (90, -10),
          raise: 0.02,
        ),
      ],
    ),
    'march_in_place': ExerciseDemo(
      pin: Joint.hip,
      seconds: 1.6,
      poses: [
        Pose(
          armNear: (-20, 10),
          armFar: (25, 70),
          legNear: (60, -10),
          legFar: (0, 0),
        ),
        Pose(armNear: (25, 70), armFar: (-20, 10), legFar: (60, -10)),
      ],
    ),
    'superman': ExerciseDemo(
      pin: Joint.hip,
      props: _mat,
      poses: [
        Pose(torso: 90, armNear: (90, 90), legNear: (-90, -90)),
        Pose(torso: 78, armNear: (105, 105), legNear: (-102, -102)),
      ],
    ),
    'bird_dog': ExerciseDemo(
      pin: Joint.footNear,
      props: _mat,
      poses: [
        Pose(torso: 77, legNear: (0, -90)),
        Pose(
          torso: 77,
          armNear: (95, 95),
          armFar: (0, 0),
          legNear: (0, -90),
          legFar: (-95, -95),
        ),
      ],
    ),
    'wall_sit': ExerciseDemo(
      props: [DemoProp(PropKind.wall)],
      seconds: 3.2,
      poses: [
        Pose(armNear: (60, 90), legNear: (90, 0)),
        Pose(torso: 2, armNear: (62, 92), legNear: (90, 0)),
      ],
    ),
    'chair_dip': ExerciseDemo(
      pin: Joint.handNear,
      props: [DemoProp(PropKind.chair, anchor: Joint.handNear, dx: -0.1)],
      poses: [
        Pose(torso: 5, armNear: (-15, -15), legNear: (80, 0)),
        Pose(torso: 5, armNear: (-80, 20), legNear: (100, 35)),
      ],
    ),
    'step_up': ExerciseDemo(
      props: [DemoProp(PropKind.step, anchor: Joint.footNear, dx: 0.03)],
      poses: [
        Pose(
          armNear: (-15, 0),
          armFar: (15, 20),
          legNear: (70, -5),
          legFar: (0, 0),
        ),
        Pose(
          armNear: (15, 20),
          armFar: (-15, 0),
          legFar: (20, -40),
          raise: 0.14,
        ),
      ],
    ),
    'calf_raise': ExerciseDemo(
      seconds: 1.6,
      poses: [
        Pose(armNear: (5, 5)),
        Pose(armNear: (5, 5), raise: 0.035),
      ],
    ),
    'dead_bug': ExerciseDemo(
      pin: Joint.hip,
      props: _mat,
      poses: [
        Pose(torso: -90, armNear: (180, 180), legNear: (180, 90)),
        Pose(
          torso: -90,
          armNear: (-95, -95),
          armFar: (180, 180),
          legNear: (180, 90),
          legFar: (100, 100),
        ),
      ],
    ),
    'goblet_squat': ExerciseDemo(
      hands: HandItem.dumbbell,
      poses: [
        Pose(armNear: (15, 170)),
        Pose(torso: 30, armNear: (45, 175), legNear: (80, -30)),
      ],
    ),
    'dumbbell_row': ExerciseDemo(
      hands: HandItem.dumbbell,
      props: [DemoProp(PropKind.bench, anchor: Joint.handFar, dx: -0.12)],
      poses: [
        Pose(torso: 80, legNear: (0, 0), legFar: (0, -90)),
        Pose(
          torso: 80,
          armNear: (-100, 0),
          armFar: (0, 0),
          legNear: (0, 0),
          legFar: (0, -90),
        ),
      ],
    ),
    'shoulder_press': ExerciseDemo(
      hands: HandItem.dumbbells,
      poses: [
        Pose(armNear: (25, 175)),
        Pose(armNear: (172, 178)),
      ],
    ),
    'romanian_deadlift': ExerciseDemo(
      hands: HandItem.dumbbells,
      poses: [
        Pose(armNear: (5, 5)),
        Pose(torso: 70, armNear: (0, 0), legNear: (-18, 2)),
      ],
    ),
    'bicep_curl': ExerciseDemo(
      hands: HandItem.dumbbells,
      seconds: 2,
      poses: [
        Pose(armNear: (0, 5)),
        Pose(armNear: (0, 150)),
      ],
    ),
    'band_row': ExerciseDemo(
      bandToFeet: true,
      pin: Joint.hip,
      props: _mat,
      poses: [
        Pose(armNear: (80, 85), legNear: (90, 90)),
        Pose(armNear: (-45, 80), legNear: (90, 90)),
      ],
    ),
    'band_pull_apart': ExerciseDemo(
      hands: HandItem.band,
      poses: [
        Pose(armNear: (90, 90)),
        Pose(armNear: (90, 90), armFar: (-90, -90)),
      ],
    ),
    'leg_press': ExerciseDemo(
      seat: Joint.hip,
      pin: Joint.hip,
      feet: FootItem.plate,
      lift: 0.18,
      props: [DemoProp(PropKind.machineSeat)],
      poses: [
        Pose(torso: -45, armNear: (20, 20), legNear: (150, 60)),
        Pose(torso: -45, armNear: (20, 20), legNear: (125, 125)),
      ],
    ),
    'lat_pulldown': ExerciseDemo(
      hands: HandItem.bar,
      cable: Offset(0, -0.08),
      props: [DemoProp(PropKind.machineSeat)],
      poses: [
        Pose(torso: -8, armNear: (172, 178), legNear: (90, 0)),
        Pose(torso: -12, armNear: (-10, 168), legNear: (90, 0)),
      ],
    ),
    'seated_cable_row': ExerciseDemo(
      seat: Joint.hip,
      hands: HandItem.handles,
      cable: Offset(0.26, 0),
      pin: Joint.hip,
      lift: 0.08,
      props: [DemoProp(PropKind.machineSeat)],
      poses: [
        Pose(torso: 5, armNear: (85, 90), legNear: (85, 95)),
        Pose(torso: -5, armNear: (-40, 80), legNear: (85, 95)),
      ],
    ),
    'chest_press': ExerciseDemo(
      hands: HandItem.handles,
      props: [DemoProp(PropKind.machineSeat)],
      poses: [
        Pose(torso: -5, armNear: (-55, 90), legNear: (90, 0)),
        Pose(torso: -5, armNear: (90, 90), legNear: (90, 0)),
      ],
    ),
    'dumbbell_bench_press': ExerciseDemo(
      hands: HandItem.dumbbells,
      props: [DemoProp(PropKind.bench, anchor: Joint.shoulder, dx: 0.1)],
      poses: [
        Pose(torso: -90, armNear: (180, 180), legNear: (90, 0)),
        Pose(torso: -90, armNear: (-30, 175), legNear: (90, 0)),
      ],
    ),
    'leg_curl': ExerciseDemo(
      seat: Joint.hip,
      pin: Joint.hip,
      feet: FootItem.pad,
      lift: 0.2,
      props: [DemoProp(PropKind.machineSeat)],
      poses: [
        Pose(torso: -15, armNear: (30, 30), legNear: (90, 90)),
        Pose(torso: -15, armNear: (30, 30), legNear: (90, -10)),
      ],
    ),
    'triceps_pushdown': ExerciseDemo(
      hands: HandItem.bar,
      cable: Offset(0.04, -0.4),
      seconds: 2,
      poses: [
        Pose(torso: 10, armNear: (5, 110)),
        Pose(torso: 10, armNear: (5, 10)),
      ],
    ),
    'treadmill_incline_walk': ExerciseDemo(
      lift: 0.05,
      seconds: 1.4,
      props: [DemoProp(PropKind.treadmill)],
      poses: [
        Pose(
          armNear: (-25, -10),
          armFar: (25, 45),
          legNear: (25, 15),
          legFar: (-25, -35),
        ),
        Pose(
          armNear: (25, 45),
          armFar: (-25, -10),
          legNear: (-25, -35),
          legFar: (25, 15),
        ),
      ],
    ),
    'stationary_bike': ExerciseDemo(
      seat: Joint.hip,
      pin: Joint.hip,
      lift: 0.46,
      seconds: 1.4,
      props: [DemoProp(PropKind.bike)],
      poses: [
        Pose(
          torso: 20,
          armNear: (60, 70),
          legNear: (25, -5),
          legFar: (95, -30),
        ),
        Pose(
          torso: 20,
          armNear: (60, 70),
          legNear: (95, -30),
          legFar: (25, -5),
        ),
      ],
    ),
    'rowing_machine': ExerciseDemo(
      seat: Joint.hip,
      lift: 0.04,
      props: [DemoProp(PropKind.rower)],
      poses: [
        Pose(torso: 20, armNear: (95, 95), legNear: (140, 30)),
        Pose(torso: -20, armNear: (-30, 80), legNear: (95, 95)),
      ],
    ),
  };

  /// The demo for the exercise [id], or null for an unknown id.
  static ExerciseDemo? of(String id) => _all[id];

  static Iterable<String> get ids => _all.keys;
}
