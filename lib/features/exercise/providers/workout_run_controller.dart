import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../data/models/exercise.dart';
import '../data/models/workout_plan.dart';

/// Where a workout of one exercise stands.
enum RunPhase {
  /// Not started yet ("Start workout").
  ready,

  /// Doing a set: reps (confirmed by hand) or a countdown for timed sets.
  working,

  /// Resting between sets, with a countdown.
  resting,

  /// Every set is done.
  done,
}

/// Runs one exercise set by set: work, rest, work… until done.
///
/// Times are kept as end times on the [clock], not as counted ticks, so
/// the countdowns stay right if the app is in the background; the screen
/// calls [tick] a few times a second to move on when a rest is over.
/// Repetitions are never counted by the app: the user taps "Done" after
/// each set. Every finished set is reported to [onSets] (to be saved).
class WorkoutRunController extends ChangeNotifier {
  WorkoutRunController({
    required this.exercise,
    required this.planned,
    required this._onSets,
    int setsDone = 0,
    this._onAlert,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now,
       _setsDone = setsDone.clamp(0, planned.sets),
       _phase = setsDone >= planned.sets ? RunPhase.done : RunPhase.ready;

  /// How much "+15 s" adds to a rest.
  static const int extraRestSeconds = 15;

  final Exercise exercise;
  final PlannedExercise planned;
  final Future<void> Function(int setsDone) _onSets;

  /// A buzz when a timed set or a rest is over.
  final VoidCallback? _onAlert;
  final DateTime Function() _clock;

  RunPhase _phase;
  int _setsDone;
  DateTime? _endsAt;
  bool _alerted = false;
  int? _shown;

  RunPhase get phase => _phase;
  int get setsDone => _setsDone;
  int get totalSets => planned.sets;

  /// The set being done, or next up (1-based).
  int get currentSet => math.min(_setsDone + 1, totalSets);

  bool get isTimed => exercise.isTimed;

  /// Seconds left of the timed set or the rest; null when nothing is
  /// counting down.
  int? get secondsLeft {
    final end = _endsAt;
    if (end == null) return null;
    final ms = end.difference(_clock()).inMilliseconds;
    return math.max(0, (ms / 1000).ceil());
  }

  /// A timed set's countdown has reached zero (waiting for "Done").
  bool get timeUp => _phase == RunPhase.working && secondsLeft == 0;

  /// Starts the first (or next, when resuming) set.
  void start() {
    if (_phase != RunPhase.ready) return;
    _startSet();
  }

  /// The current set is done: rest, or finish after the last one.
  Future<void> finishSet() async {
    if (_phase != RunPhase.working) return;
    _setsDone++;
    if (_setsDone >= totalSets) {
      _phase = RunPhase.done;
      _endsAt = null;
    } else {
      _phase = RunPhase.resting;
      _endsAt = _clock().add(Duration(seconds: planned.restSeconds));
      _alerted = false;
    }
    notifyListeners();
    await _onSets(_setsDone);
  }

  /// Ends the rest now and starts the next set.
  void skipRest() {
    if (_phase != RunPhase.resting) return;
    _startSet();
  }

  /// Adds [extraRestSeconds] to the rest.
  void addRest() {
    final end = _endsAt;
    if (_phase != RunPhase.resting || end == null) return;
    _endsAt = end.add(const Duration(seconds: extraRestSeconds));
    notifyListeners();
  }

  /// Marks every set done (e.g. done without the timer).
  Future<void> completeExercise() async {
    if (_phase == RunPhase.done) return;
    _setsDone = totalSets;
    _phase = RunPhase.done;
    _endsAt = null;
    notifyListeners();
    await _onSets(_setsDone);
  }

  /// Moves on when a rest is over, and buzzes when a countdown ends.
  void tick() {
    final left = secondsLeft;
    if (left == null) return;
    if (left == 0 && !_alerted) {
      _alerted = true;
      _onAlert?.call();
      if (_phase == RunPhase.resting) {
        _startSet();
        return;
      }
    }
    // Redraw only when the shown second changes.
    if (left != _shown) {
      _shown = left;
      notifyListeners();
    }
  }

  void _startSet() {
    _phase = RunPhase.working;
    _alerted = false;
    _endsAt = isTimed
        ? _clock().add(Duration(seconds: planned.durationSeconds ?? 30))
        : null;
    notifyListeners();
  }
}
