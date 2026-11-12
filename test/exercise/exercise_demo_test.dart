import 'package:cal_ai_app/features/exercise/data/catalog/exercise_catalog.dart';
import 'package:cal_ai_app/features/exercise/data/catalog/exercise_demos.dart';
import 'package:cal_ai_app/features/exercise/data/models/exercise_demo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every catalog exercise has a demo, and only those', () {
    expect(ExerciseDemos.ids.toSet(), {
      for (final e in ExerciseCatalog.all) e.id,
    });
    for (final id in ExerciseDemos.ids) {
      expect(
        ExerciseDemos.of(id)!.poses.length,
        greaterThanOrEqualTo(2),
        reason: id,
      );
    }
    expect(ExerciseDemos.of('nope'), isNull);
  });

  test('a standing figure is about 0.85 tall, feet to head', () {
    final s = Skeleton.of(const Pose(), const Offset(0.5, 0.5));
    final height = s.footNear.dy - (s.head.dy - Bones.head);
    expect(height, closeTo(0.845, 0.01));
    expect(s.footNear, s.footFar);
    expect(s.handNear.dy, greaterThan(s.hip.dy)); // arms hang down
  });

  test('angles: limbs from straight down, torso from straight up', () {
    final s = Skeleton.of(
      const Pose(torso: 90, armNear: (90, 90), legNear: (-90, -90)),
      Offset.zero,
    );
    expect(s.neck.dx, closeTo(Bones.torso, 1e-9)); // lying, head right
    expect(s.neck.dy, closeTo(0, 1e-9));
    expect(s.handNear.dx, greaterThan(s.shoulder.dx)); // arm forward
    expect(s.footNear.dx, closeTo(-(Bones.thigh + Bones.shin), 1e-9));
  });

  // Every frame of every demo, including in-between ones, must fit in the
  // drawing and stand on (not sink into) the floor.
  for (final id in ExerciseDemos.ids) {
    test('$id fits in its drawing', () {
      final demo = ExerciseDemos.of(id)!;
      final layout = DemoLayout(demo);
      Offset shown(Offset p) => Offset(
        0.5 + (p.dx - 0.5) * layout.scale,
        DemoLayout.floor + (p.dy - DemoLayout.floor) * layout.scale,
      );
      double? seatY;
      for (var i = 0; i <= 40; i++) {
        final s = layout.place(demo.poseAt(i / 40));
        for (final j in s.joints) {
          final p = shown(j);
          expect(p.dx, inInclusiveRange(-0.01, 1.01), reason: '$id x $i');
          expect(
            p.dy,
            inInclusiveRange(-0.01, DemoLayout.floor + 0.001),
            reason: '$id y $i',
          );
        }
        expect(
          shown(s.head).dy - Bones.head * layout.scale,
          greaterThan(-0.02),
          reason: '$id head $i',
        );
        // Seated exercises keep the hips on the seat.
        if (demo.seat != null) {
          seatY ??= s.hip.dy;
          expect(s.hip.dy, closeTo(seatY, 1e-9), reason: '$id seat $i');
        } else {
          expect(
            s.lowest + Bones.limb / 2,
            closeTo(
              DemoLayout.floor - demo.lift - demo.poseAt(i / 40).raise,
              1e-6,
            ),
            reason: '$id floor $i',
          );
        }
      }
    });
  }

  test('the loop: hold, move, hold, move back; steps follow', () {
    const demo = ExerciseDemo(poses: [Pose(), Pose(torso: 40)]);
    expect(demo.poseAt(0).torso, 0);
    expect(demo.poseAt(0.1).torso, 0); // holding the first pose
    expect(demo.poseAt(0.5).torso, 40);
    expect(demo.poseAt(0.6).torso, 40); // holding the second
    expect(demo.poseAt(0.32).torso, inExclusiveRange(0, 40)); // moving
    expect(demo.poseAt(0.9).torso, inExclusiveRange(0, 40)); // back
    expect(
      [
        for (final t in [0.0, 0.1, 0.3, 0.5, 0.6, 0.8, 0.99]) demo.stepAt(t),
      ],
      [0, 0, 1, 1, 1, 2, 2],
    );
  });

  test('poses blend smoothly', () {
    const a = Pose(armNear: (0, 0), legNear: (10, 20), raise: 0);
    const b = Pose(armNear: (90, 90), legNear: (30, 40), raise: 0.1);
    final mid = a.lerp(b, 0.5);
    expect(mid.armNear, (45.0, 45.0));
    expect(mid.legNear, (20.0, 30.0));
    expect(mid.raise, closeTo(0.05, 1e-9));
  });
}
