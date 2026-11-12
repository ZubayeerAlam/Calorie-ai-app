import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/models/exercise_demo.dart';

/// Colours for a demo drawing (from the app palette, so it follows dark
/// mode).
class FigureColors {
  const FigureColors({
    required this.body,
    required this.equipment,
    required this.equipmentFill,
    required this.floor,
    required this.mat,
  });

  final Color body;
  final Color equipment;
  final Color equipmentFill;
  final Color floor;
  final Color mat;

  static const Color band = Color(0xFFE5533D);
}

/// Draws a side-view figure in [pose] with the demo's equipment.
class ExerciseFigurePainter extends CustomPainter {
  ExerciseFigurePainter({
    required this.layout,
    required this.pose,
    required this.colors,
  });

  final DemoLayout layout;
  final Pose pose;
  final FigureColors colors;

  ExerciseDemo get demo => layout.demo;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    canvas.save();
    // Centre the square drawing in any size.
    canvas.translate((size.width - s) / 2, (size.height - s) / 2);
    Offset px(Offset u) => u * s;

    final body = layout.place(pose);
    final first = layout.first;

    // Floor.
    canvas.drawLine(
      px(const Offset(0.03, DemoLayout.floor)),
      px(const Offset(0.97, DemoLayout.floor)),
      Paint()
        ..color = colors.floor
        ..strokeWidth = 0.012 * s
        ..strokeCap = StrokeCap.round,
    );

    // Shrink to fit around the middle of the floor.
    canvas.translate(0.5 * s, DemoLayout.floor * s);
    canvas.scale(layout.scale);
    canvas.translate(-0.5 * s, -DemoLayout.floor * s);

    for (final prop in demo.props) {
      _prop(canvas, s, prop, first);
    }
    _cable(canvas, s, body, first);

    final limb = Paint()
      ..strokeWidth = Bones.limb * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final far = Paint.from(limb)..color = colors.body.withValues(alpha: 0.4);
    final near = Paint.from(limb)..color = colors.body;

    void segment(Paint p, List<Offset> points) {
      final path = Path()..moveTo(px(points[0]).dx, px(points[0]).dy);
      for (final point in points.skip(1)) {
        path.lineTo(px(point).dx, px(point).dy);
      }
      canvas.drawPath(path, p);
    }

    // Far side first, so the near side is drawn over it.
    segment(far, [body.hip, body.kneeFar, body.footFar]);
    _foot(canvas, s, body.kneeFar, body.footFar, far);
    segment(far, [body.shoulder, body.elbowFar, body.handFar]);
    _handItem(canvas, s, body.handFar, body.elbowFar, faded: true);

    segment(near, [body.hip, body.neck]);
    canvas.drawCircle(
      px(body.head),
      Bones.head * s,
      Paint()..color = colors.body,
    );
    segment(near, [body.hip, body.kneeNear, body.footNear]);
    _foot(canvas, s, body.kneeNear, body.footNear, near);
    _footItem(canvas, s, body);
    segment(near, [body.shoulder, body.elbowNear, body.handNear]);
    _handItem(canvas, s, body.handNear, body.elbowNear);
    _band(canvas, s, body);
    canvas.restore();
  }

  /// A short foot pointing forward from the ankle.
  void _foot(Canvas canvas, double s, Offset knee, Offset ankle, Paint p) {
    final shin = ankle - knee;
    if (shin.distance == 0) return;
    // Perpendicular to the shin, on the side the figure faces.
    var dir = Offset(-shin.dy, shin.dx) / shin.distance;
    if (dir.dx < 0) dir = -dir;
    canvas.drawLine(ankle * s, (ankle + dir * 0.035) * s, p);
  }

  void _handItem(
    Canvas canvas,
    double s,
    Offset hand,
    Offset elbow, {
    bool faded = false,
  }) {
    final metal = colors.equipment.withValues(alpha: faded ? 0.45 : 1);
    switch (demo.hands) {
      case HandItem.none:
      case HandItem.band:
        return;
      case HandItem.dumbbell when faded:
        return;
      case HandItem.dumbbells:
      case HandItem.dumbbell:
        final forearm = hand - elbow;
        final angle = math.atan2(forearm.dy, forearm.dx) + math.pi / 2;
        canvas.save();
        canvas.translate(hand.dx * s, hand.dy * s);
        canvas.rotate(angle);
        final bar = Paint()
          ..color = metal
          ..strokeWidth = 0.014 * s
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(-0.04 * s, 0), Offset(0.04 * s, 0), bar);
        final plate = Paint()..color = metal;
        for (final x in [-0.04, 0.04]) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(x * s, 0),
                width: 0.022 * s,
                height: 0.05 * s,
              ),
              Radius.circular(0.006 * s),
            ),
            plate,
          );
        }
        canvas.restore();
      case HandItem.bar:
        canvas.drawCircle(hand * s, 0.022 * s, Paint()..color = metal);
      case HandItem.handles:
        canvas.drawCircle(hand * s, 0.018 * s, Paint()..color = metal);
    }
  }

  void _band(Canvas canvas, double s, Skeleton body) {
    final paint = Paint()
      ..color = FigureColors.band
      ..strokeWidth = 0.012 * s
      ..strokeCap = StrokeCap.round;
    if (demo.bandToFeet) {
      canvas.drawLine(body.handNear * s, body.footNear * s, paint);
    } else if (demo.hands == HandItem.band) {
      canvas.drawLine(
        body.handNear * s,
        (body.handFar + const Offset(0, -0.02)) * s,
        paint,
      );
    }
  }

  void _footItem(Canvas canvas, double s, Skeleton body) {
    final metal = Paint()..color = colors.equipment;
    switch (demo.feet) {
      case FootItem.none:
        return;
      case FootItem.plate:
        final leg = body.footNear - body.hip;
        final dir = leg / leg.distance;
        final across = Offset(-dir.dy, dir.dx);
        final centre = body.footNear + dir * 0.03;
        canvas.drawLine(
          (centre - across * 0.09) * s,
          (centre + across * 0.09) * s,
          metal
            ..strokeWidth = 0.025 * s
            ..strokeCap = StrokeCap.round,
        );
      case FootItem.pad:
        canvas.drawCircle(
          (body.footNear + const Offset(0, -0.035)) * s,
          0.028 * s,
          metal,
        );
    }
  }

  void _cable(Canvas canvas, double s, Skeleton body, Skeleton first) {
    final offset = demo.cable;
    if (offset == null) return;
    final anchor = first.handNear + offset;
    final line = Paint()
      ..color = colors.equipment
      ..strokeWidth = 0.008 * s;
    // The machine's tower, then the cable to the hand.
    final tower = Paint()
      ..color = colors.equipmentFill
      ..strokeWidth = 0.03 * s
      ..strokeCap = StrokeCap.round;
    if (offset.dx.abs() < 0.1) {
      // Overhead cable: a tower behind the figure and a beam to the pulley.
      final towerX = first.left - 0.05;
      canvas.drawLine(
        Offset(towerX, anchor.dy) * s,
        Offset(towerX, DemoLayout.floor) * s,
        tower,
      );
      canvas.drawLine(
        Offset(towerX, anchor.dy) * s,
        Offset(anchor.dx + 0.02, anchor.dy) * s,
        tower,
      );
    } else {
      final towerX = anchor.dx + (offset.dx > 0 ? 0.03 : -0.03);
      canvas.drawLine(
        Offset(towerX, math.min(anchor.dy, 0.1)) * s,
        Offset(towerX, DemoLayout.floor) * s,
        tower,
      );
    }
    canvas.drawLine(anchor * s, body.handNear * s, line);
    canvas.drawCircle(anchor * s, 0.016 * s, Paint()..color = colors.equipment);
  }

  void _prop(Canvas canvas, double s, DemoProp prop, Skeleton first) {
    final a = first.joint(prop.anchor) + Offset(prop.dx, 0);
    final fill = Paint()..color = colors.equipmentFill;
    final edge = Paint()
      ..color = colors.equipment
      ..strokeWidth = 0.014 * s
      ..strokeCap = StrokeCap.round;
    Rect r(double l, double t, double rr, double b) =>
        Rect.fromLTRB(l * s, t * s, rr * s, b * s);
    void rect(Rect rect, [double radius = 0.01]) => canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius * s)),
      fill,
    );
    void line(Offset from, Offset to) =>
        canvas.drawLine(from * s, to * s, edge);
    const floor = DemoLayout.floor;

    switch (prop.kind) {
      case PropKind.mat:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            r(first.left - 0.03, floor - 0.016, first.right + 0.03, floor),
            Radius.circular(0.008 * s),
          ),
          Paint()..color = colors.mat,
        );
      case PropKind.chair:
        final seatTop = a.dy + Bones.limb / 2;
        rect(r(a.dx - 0.09, seatTop, a.dx + 0.09, seatTop + 0.025));
        line(Offset(a.dx - 0.08, seatTop), Offset(a.dx - 0.08, floor));
        line(Offset(a.dx + 0.08, seatTop), Offset(a.dx + 0.08, floor));
        final backX = a.dx < 0.5 ? a.dx - 0.085 : a.dx + 0.085;
        line(Offset(backX, seatTop), Offset(backX, seatTop - 0.2));
      case PropKind.bench:
        final top = a.dy + Bones.limb / 2;
        rect(r(a.dx - 0.22, top, a.dx + 0.22, top + 0.035));
        line(Offset(a.dx - 0.16, top), Offset(a.dx - 0.16, floor));
        line(Offset(a.dx + 0.16, top), Offset(a.dx + 0.16, floor));
      case PropKind.step:
        final top = a.dy + Bones.limb / 2;
        rect(r(a.dx - 0.1, top, a.dx + 0.1, floor));
      case PropKind.wall:
        final x = a.dx - Bones.limb / 2;
        rect(r(x - 0.04, 0.04, x, floor), 0.004);
      case PropKind.machineSeat:
        final seatTop = a.dy + Bones.limb / 2;
        rect(r(a.dx - 0.09, seatTop, a.dx + 0.06, seatTop + 0.035));
        line(Offset(a.dx - 0.02, seatTop), Offset(a.dx - 0.02, floor));
        // Backrest along the back of the first pose.
        final spine = first.shoulder - first.hip;
        final back = Offset(spine.dy, -spine.dx) / spine.distance;
        final offset = back.dx > 0 ? -back : back; // behind = to the left
        canvas.drawLine(
          (first.hip + offset * 0.045) * s,
          (first.shoulder + offset * 0.045) * s,
          Paint()
            ..color = colors.equipmentFill
            ..strokeWidth = 0.04 * s
            ..strokeCap = StrokeCap.round,
        );
      case PropKind.treadmill:
        final top = floor - demo.lift;
        rect(r(first.left - 0.12, top, first.right + 0.1, floor), 0.015);
        final front = first.right + 0.1;
        line(Offset(front, top), Offset(front - 0.03, first.handNear.dy));
        rect(
          r(
            front - 0.09,
            first.handNear.dy - 0.03,
            front + 0.01,
            first.handNear.dy,
          ),
          0.006,
        );
      case PropKind.bike:
        final crank = (first.footNear + first.footFar) / 2;
        final seat = first.hip + const Offset(0, Bones.limb / 2 + 0.012);
        rect(r(seat.dx - 0.06, seat.dy, seat.dx + 0.04, seat.dy + 0.025));
        line(seat, crank);
        line(crank, Offset(crank.dx + 0.12, floor));
        line(Offset(crank.dx + 0.12, floor), first.handNear);
        line(Offset(seat.dx - 0.12, floor), Offset(crank.dx + 0.2, floor));
        canvas.drawCircle(
          crank * s,
          0.025 * s,
          Paint()..color = colors.equipment,
        );
      case PropKind.rower:
        final railY = floor - 0.02;
        line(
          Offset(first.left - 0.04, railY),
          Offset(first.right + 0.06, railY),
        );
        rect(
          r(
            first.hip.dx - 0.06,
            first.hip.dy + Bones.limb / 2,
            first.hip.dx + 0.05,
            railY,
          ),
        );
        final foot = first.footNear;
        line(
          Offset(foot.dx + 0.02, foot.dy - 0.08),
          Offset(foot.dx + 0.02, railY),
        );
        canvas.drawCircle(
          Offset(first.right + 0.06, railY - 0.06) * s,
          0.06 * s,
          fill,
        );
    }
  }

  @override
  bool shouldRepaint(ExerciseFigurePainter old) =>
      old.pose != pose || old.layout != layout || old.colors != colors;
}
