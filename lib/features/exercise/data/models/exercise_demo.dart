import 'dart:math' as math;
import 'dart:ui' show Offset, lerpDouble;

/// One arm or leg: the angles of its two segments (upper arm and forearm,
/// or thigh and shin), in degrees from pointing straight **down**;
/// positive turns towards the way the figure faces (right).
///
/// Examples: 0 = hanging down; 90 = straight forward; 180 = straight up;
/// −90 = straight back.
typedef Limb = (double upper, double lower);

/// A body position, seen from the side, facing right.
///
/// [torso] is the angle from the hips to the neck in degrees from
/// pointing straight **up**; positive leans forward (90 = lying face down
/// with the head to the right, −90 = lying on the back with the head to
/// the left). The far arm and leg default to the near ones.
class Pose {
  const Pose({
    this.torso = 0,
    this.armNear = (0, 0),
    Limb? armFar,
    this.legNear = (0, 0),
    Limb? legFar,
    this.raise = 0,
  }) : armFar = armFar ?? armNear,
       legFar = legFar ?? legNear;

  final double torso;
  final Limb armNear;
  final Limb armFar;
  final Limb legNear;
  final Limb legFar;

  /// Extra height off the floor (standing on a step, on tiptoe).
  final double raise;

  // Equal poses (e.g. while a pose is held) don't need redrawing.
  @override
  bool operator ==(Object other) =>
      other is Pose &&
      other.torso == torso &&
      other.armNear == armNear &&
      other.armFar == armFar &&
      other.legNear == legNear &&
      other.legFar == legFar &&
      other.raise == raise;

  @override
  int get hashCode =>
      Object.hash(torso, armNear, armFar, legNear, legFar, raise);

  /// The pose [t] of the way (0–1) from this one to [other].
  Pose lerp(Pose other, double t) {
    double l(double a, double b) => lerpDouble(a, b, t)!;
    Limb limb(Limb a, Limb b) => (l(a.$1, b.$1), l(a.$2, b.$2));
    return Pose(
      torso: l(torso, other.torso),
      armNear: limb(armNear, other.armNear),
      armFar: limb(armFar, other.armFar),
      legNear: limb(legNear, other.legNear),
      legFar: limb(legFar, other.legFar),
      raise: l(raise, other.raise),
    );
  }
}

/// Body proportions, as a share of the drawing's size (a standing figure
/// is about 0.85 tall).
class Bones {
  Bones._();

  static const double torso = 0.28;
  static const double neck = 0.035;
  static const double head = 0.055; // radius
  static const double upperArm = 0.14;
  static const double forearm = 0.13;
  static const double thigh = 0.21;
  static const double shin = 0.21;

  /// Thickness of a limb (the painter's stroke width).
  static const double limb = 0.042;
}

/// Where each joint of a [Pose] is, in the drawing's 0–1 square.
class Skeleton {
  const Skeleton({
    required this.hip,
    required this.shoulder,
    required this.neck,
    required this.head,
    required this.elbowNear,
    required this.handNear,
    required this.elbowFar,
    required this.handFar,
    required this.kneeNear,
    required this.footNear,
    required this.kneeFar,
    required this.footFar,
  });

  /// Lays out [pose] with the hips at [hip].
  factory Skeleton.of(Pose pose, Offset hip) {
    Offset up(double deg) {
      final r = deg * math.pi / 180;
      return Offset(math.sin(r), -math.cos(r));
    }

    Offset down(double deg) {
      final r = deg * math.pi / 180;
      return Offset(math.sin(r), math.cos(r));
    }

    final spine = up(pose.torso);
    final neck = hip + spine * Bones.torso;
    final shoulder = hip + spine * (Bones.torso * 0.93);
    final head = neck + spine * (Bones.neck + Bones.head);
    (Offset, Offset) limb(Offset from, Limb l, double a, double b) {
      final mid = from + down(l.$1) * a;
      return (mid, mid + down(l.$2) * b);
    }

    final (elbowNear, handNear) = limb(
      shoulder,
      pose.armNear,
      Bones.upperArm,
      Bones.forearm,
    );
    final (elbowFar, handFar) = limb(
      shoulder,
      pose.armFar,
      Bones.upperArm,
      Bones.forearm,
    );
    final (kneeNear, footNear) = limb(
      hip,
      pose.legNear,
      Bones.thigh,
      Bones.shin,
    );
    final (kneeFar, footFar) = limb(hip, pose.legFar, Bones.thigh, Bones.shin);
    return Skeleton(
      hip: hip,
      shoulder: shoulder,
      neck: neck,
      head: head,
      elbowNear: elbowNear,
      handNear: handNear,
      elbowFar: elbowFar,
      handFar: handFar,
      kneeNear: kneeNear,
      footNear: footNear,
      kneeFar: kneeFar,
      footFar: footFar,
    );
  }

  final Offset hip;
  final Offset shoulder;
  final Offset neck;
  final Offset head;
  final Offset elbowNear;
  final Offset handNear;
  final Offset elbowFar;
  final Offset handFar;
  final Offset kneeNear;
  final Offset footNear;
  final Offset kneeFar;
  final Offset footFar;

  /// Every joint, for working out the figure's extent.
  List<Offset> get joints => [
    hip,
    shoulder,
    neck,
    elbowNear,
    handNear,
    elbowFar,
    handFar,
    kneeNear,
    footNear,
    kneeFar,
    footFar,
  ];

  /// Lowest point of the body (largest y), including the head's edge.
  double get lowest => [
    for (final j in joints) j.dy,
    head.dy + Bones.head - Bones.limb / 2,
  ].reduce(math.max);

  /// Highest point (smallest y), including the head.
  double get top =>
      [for (final j in joints) j.dy, head.dy - Bones.head].reduce(math.min);

  double get left =>
      [for (final j in joints) j.dx, head.dx - Bones.head].reduce(math.min);

  double get right =>
      [for (final j in joints) j.dx, head.dx + Bones.head].reduce(math.max);

  Offset joint(Joint j) => switch (j) {
    Joint.hip => hip,
    Joint.shoulder => shoulder,
    Joint.head => head,
    Joint.handNear => handNear,
    Joint.handFar => handFar,
    Joint.footNear => footNear,
    Joint.footFar => footFar,
    Joint.kneeNear => kneeNear,
  };
}

enum Joint {
  hip,
  shoulder,
  head,
  handNear,
  handFar,
  footNear,
  footFar,
  kneeNear,
}

/// Equipment drawn in a demo. Static props are placed once, relative to a
/// joint of the first pose; hand and foot items follow the body.
enum PropKind {
  /// Exercise mat on the floor under the figure.
  mat,

  /// Chair with its seat top at the anchor.
  chair,

  /// Flat bench with its top at the anchor.
  bench,

  /// Low step or box with its top at the anchor.
  step,

  /// Wall just behind the anchor (to the left).
  wall,

  /// Machine seat and backrest under the anchor (the hips).
  machineSeat,

  /// Treadmill belt under the feet and a console in front.
  treadmill,

  /// Exercise bike: seat at the hips, handlebars at the hands, pedals.
  bike,

  /// Rowing machine rail, seat and foot plate.
  rower,
}

/// What the hands hold.
enum HandItem {
  none,

  /// A dumbbell in each hand.
  dumbbells,

  /// One dumbbell, in the near hand.
  dumbbell,
  bar,
  handles,
  band,
}

/// What the feet push against.
enum FootItem { none, plate, pad }

class DemoProp {
  const DemoProp(this.kind, {this.anchor = Joint.hip, this.dx = 0});

  final PropKind kind;
  final Joint anchor;

  /// Moves the prop sideways from the anchor.
  final double dx;
}

/// An exercise's demonstration: key poses played in a loop (each held
/// briefly, eased between), and the equipment around the figure.
///
/// The three instruction steps go with the loop: step 1 while in the
/// first pose, step 2 moving into and holding the next, step 3 coming
/// back.
class ExerciseDemo {
  /// [poses] needs at least two.
  const ExerciseDemo({
    required this.poses,
    this.props = const [],
    this.hands = HandItem.none,
    this.feet = FootItem.none,
    this.cable,
    this.bandToFeet = false,
    this.lift = 0,
    this.pin = Joint.footNear,
    this.seat,
    this.seconds = 2.4,
  });

  final List<Pose> poses;
  final List<DemoProp> props;
  final HandItem hands;
  final FootItem feet;

  /// A cable from this point (relative to the near hand in the first
  /// pose) to the near hand, e.g. a pulldown from above.
  final Offset? cable;

  /// A resistance band from the hands to the feet.
  final bool bandToFeet;

  /// Space between the body's lowest point and the floor (feet on pedals,
  /// a treadmill belt).
  final double lift;

  /// The joint that stays in place sideways while the body moves (the
  /// feet for most exercises, the hands for push-ups).
  final Joint pin;

  /// For seated exercises: this joint (the hips) stays at [lift] above the
  /// floor, instead of the body's lowest point resting on the floor.
  final Joint? seat;

  /// Length of one loop.
  final double seconds;

  /// Where the step for the loop position [t] (0–1) is: 0, 1 or 2.
  int stepAt(double t) {
    final (from, _, moving) = segmentAt(t);
    if (!moving) return math.min(from, 2);
    return from == poses.length - 1 ? 2 : math.min(from + 1, 2);
  }

  /// The pose at loop position [t] (0–1).
  Pose poseAt(double t) {
    final (from, progress, moving) = segmentAt(t);
    if (!moving) return poses[from];
    final to = (from + 1) % poses.length;
    return poses[from].lerp(poses[to], _ease(progress));
  }

  /// Each pose is held for [holdShare] of its slot, then eases to the
  /// next. Returns the pose index, how far through the move (0–1), and
  /// whether it is moving.
  (int, double, bool) segmentAt(double t) {
    final n = poses.length;
    final slot = (t % 1) * n;
    final index = slot.floor().clamp(0, n - 1);
    final within = slot - index;
    if (within < holdShare) return (index, 0, false);
    return (index, (within - holdShare) / (1 - holdShare), true);
  }

  static const double holdShare = 0.3;

  static double _ease(double x) =>
      x < 0.5 ? 2 * x * x : 1 - math.pow(-2 * x + 2, 2) / 2;
}

/// Places a demo's figure: standing on the floor, centred, with the
/// [ExerciseDemo.pin] joint kept still sideways.
class DemoLayout {
  DemoLayout(this.demo) {
    final skeletons = [for (final p in demo.poses) _place(p, 0)];
    final left = skeletons.map((s) => s.left).reduce(math.min);
    final right = skeletons.map((s) => s.right).reduce(math.max);
    final top = skeletons.map((s) => s.top).reduce(math.min);
    _pinX = 0.5 - (left + right) / 2;
    // Shrink poses that reach above the top or are too wide.
    scale = math.min(
      1,
      math.min(
        (floor - margin) / (floor - top),
        (1 - 2 * margin) / (right - left),
      ),
    );
  }

  /// The floor's height in the 0–1 square.
  static const double floor = 0.93;

  /// Space kept free at the top and sides.
  static const double margin = 0.04;

  final ExerciseDemo demo;
  late final double _pinX;

  /// How much the figure and equipment are shrunk to fit (1 = not at
  /// all), around the middle of the floor.
  late final double scale;

  Skeleton place(Pose pose) => _place(pose, _pinX);

  /// The first pose, where static props are anchored.
  late final Skeleton first = place(demo.poses.first);

  Skeleton _place(Pose pose, double pinX) {
    final origin = Skeleton.of(pose, Offset.zero);
    final base = floor - demo.lift - pose.raise - Bones.limb / 2;
    final seat = demo.seat;
    final y = seat == null
        ? base - origin.lowest
        : base - origin.joint(seat).dy;
    final x = pinX - origin.joint(demo.pin).dx;
    return Skeleton.of(pose, Offset(x, y));
  }
}
