import 'package:cal_ai_app/features/exercise/data/catalog/exercise_catalog.dart';
import 'package:cal_ai_app/features/exercise/data/models/workout_plan.dart';
import 'package:cal_ai_app/features/exercise/providers/workout_run_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DateTime now;
  late List<int> saved;
  late int alerts;

  WorkoutRunController run(
    String id, {
    int sets = 3,
    int? reps = 12,
    int? duration,
    int rest = 60,
    int setsDone = 0,
  }) => WorkoutRunController(
    exercise: ExerciseCatalog.byId(id)!,
    planned: PlannedExercise(
      exerciseId: id,
      sets: sets,
      reps: duration == null ? reps : null,
      durationSeconds: duration,
      restSeconds: rest,
    ),
    setsDone: setsDone,
    onSets: (n) async => saved.add(n),
    onAlert: () => alerts++,
    clock: () => now,
  );

  void wait(int seconds) => now = now.add(Duration(seconds: seconds));

  setUp(() {
    now = DateTime(2026, 11, 12, 18);
    saved = [];
    alerts = 0;
  });

  test('reps: work, rest, work… done; each set is saved', () async {
    final r = run('push_up');
    expect(r.phase, RunPhase.ready);
    expect(r.currentSet, 1);
    expect(r.secondsLeft, isNull);

    r.start();
    expect(r.phase, RunPhase.working);
    expect(r.secondsLeft, isNull); // reps are confirmed by hand
    await r.finishSet();
    expect(saved, [1]);
    expect(r.phase, RunPhase.resting);
    expect(r.currentSet, 2);
    expect(r.secondsLeft, 60);

    wait(30);
    r.tick();
    expect(r.phase, RunPhase.resting);
    expect(r.secondsLeft, 30);

    // The rest ends by itself, with a buzz.
    wait(31);
    r.tick();
    expect(r.phase, RunPhase.working);
    expect(alerts, 1);

    await r.finishSet();
    r.skipRest(); // skip straight to set 3
    expect(r.phase, RunPhase.working);
    expect(r.currentSet, 3);
    await r.finishSet();
    expect(r.phase, RunPhase.done);
    expect(saved, [1, 2, 3]);
    expect(r.secondsLeft, isNull);
  });

  test('+15 s lengthens the rest', () async {
    final r = run('push_up', rest: 45)..start();
    await r.finishSet();
    r.addRest();
    expect(r.secondsLeft, 60);
    wait(50);
    r.tick();
    expect(r.phase, RunPhase.resting);
  });

  test('timed sets count down, but still wait for Done', () async {
    final r = run('plank', duration: 30)..start();
    expect(r.isTimed, isTrue);
    expect(r.secondsLeft, 30);
    expect(r.timeUp, isFalse);

    wait(31);
    r.tick();
    expect(r.timeUp, isTrue);
    expect(alerts, 1);
    expect(r.phase, RunPhase.working); // not counted as done yet
    r.tick();
    expect(alerts, 1); // one buzz only

    await r.finishSet();
    expect(saved, [1]);
    expect(r.phase, RunPhase.resting);
  });

  test('Complete exercise marks every set done', () async {
    final r = run('squat')..start();
    await r.finishSet();
    await r.completeExercise();
    expect(r.phase, RunPhase.done);
    expect(r.setsDone, 3);
    expect(saved, [1, 3]);
  });

  test('carries on from the sets already done today', () {
    final r = run('squat', setsDone: 2);
    expect(r.phase, RunPhase.ready);
    expect(r.currentSet, 3);
    r.start();
    expect(r.currentSet, 3);
    expect(run('squat', setsDone: 3).phase, RunPhase.done);
    expect(run('squat', setsDone: 9).setsDone, 3);
  });

  test('buttons that don\'t fit the moment do nothing', () async {
    final r = run('squat');
    await r.finishSet(); // not started
    r.skipRest();
    r.addRest();
    expect(r.phase, RunPhase.ready);
    expect(saved, isEmpty);
  });

  test('the display only updates when the shown second changes', () async {
    final r = run('push_up')..start();
    await r.finishSet();
    var updates = 0;
    r.addListener(() => updates++);
    r.tick();
    r.tick();
    expect(updates, 1);
    now = now.add(const Duration(milliseconds: 300));
    r.tick();
    expect(updates, 1);
    wait(1);
    r.tick();
    expect(updates, 2);
  });
}
