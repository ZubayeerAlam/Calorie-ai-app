import 'package:cal_ai_app/core/services/workout_plan_service.dart';
import 'package:cal_ai_app/features/exercise/data/models/exercise_settings.dart';
import 'package:cal_ai_app/features/exercise/data/models/workout_plan.dart';
import 'package:cal_ai_app/features/exercise/data/workout_plan_validator.dart';
import 'package:cal_ai_app/features/profile/data/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

import 'plan_test_data.dart';

Map<String, dynamic> _ex(
  String id, {
  Object? sets = 3,
  Object? reps = 12,
  Object? duration,
  Object? rest = 60,
  Object? why = 'Good for you',
}) => {
  'exerciseId': id,
  'sets': ?sets,
  'reps': ?reps,
  'durationSeconds': ?duration,
  'restSeconds': ?rest,
  'why': ?why,
};

WorkoutPlan _validate(
  Map<String, dynamic> json, {
  ActivityLevel activity = ActivityLevel.light,
  int minutes = 30,
  WorkoutEnvironment environment = WorkoutEnvironment.home,
  Set<BodyLimitation> limitations = const {},
}) => WorkoutPlanValidator.validate(
  json,
  testRequest(
    profile: testProfile(activity: activity),
    minutes: minutes,
    environment: environment,
    limitations: limitations,
  ),
  id: 'p1',
  source: PlanSource.ai,
);

Map<String, dynamic> _plan(List<List<Map<String, dynamic>>> sessions) => {
  'summary': 'A plan',
  'sessions': [
    for (final (i, exercises) in sessions.indexed)
      {'name': 'Day $i', 'focus': 'Focus', 'exercises': exercises},
  ],
};

final _good = [
  _ex('squat'),
  _ex('push_up', reps: 10),
  _ex('plank', reps: null, duration: 30),
  _ex('glute_bridge'),
];

Matcher get _invalid => throwsA(
  isA<WorkoutPlanException>().having(
    (e) => e.failure,
    'failure',
    WorkoutPlanFailure.invalidResponse,
  ),
);

void main() {
  test('a good reply is kept as it is', () {
    final plan = _validate(_plan([_good]));
    expect(plan.id, 'p1');
    expect(plan.source, PlanSource.ai);
    expect(plan.environment, WorkoutEnvironment.home);
    expect(plan.summary, 'A plan');
    expect(plan.createdAt, DateTime(2026, 11, 12, 9));
    expect(plan.inputsKey, isNotEmpty);
    final [session] = plan.sessions;
    expect(session.name, 'Day 0');
    expect(
      [for (final e in session.exercises) e.exerciseId],
      ['squat', 'push_up', 'plank', 'glute_bridge'],
    );
    expect(session.exercises[1].reps, 10);
    expect(session.exercises[2].durationSeconds, 30);
    expect(session.exercises[2].reps, isNull);
    expect(session.exercises[0].why, 'Good for you');
  });

  test('drops unknown, not allowed and repeated exercises', () {
    final plan = _validate(
      _plan([
        [
          _ex('squat'),
          _ex('flying_kick'),
          _ex('leg_press'), // gym only
          _ex('goblet_squat'), // needs dumbbells
          _ex('squat'), // repeat
          _ex('push_up'),
          _ex('glute_bridge'),
        ],
      ]),
    );
    expect(
      [for (final e in plan.sessions.single.exercises) e.exerciseId],
      ['squat', 'push_up', 'glute_bridge'],
    );
  });

  test('drops exercises that load a limited body area', () {
    expect(
      () => _validate(
        _plan([
          [_ex('squat'), _ex('lunge'), _ex('glute_bridge')],
        ]),
        limitations: {BodyLimitation.knees},
      ),
      _invalid,
    );
  });

  test('keeps numbers in safe ranges and fixes reps vs time', () {
    final plan = _validate(
      _plan([
        [
          _ex('squat', sets: 12, reps: 100, rest: 600),
          _ex('push_up', sets: 0, reps: 1, rest: 2),
          // A timed exercise given reps gets a default time.
          _ex('plank', reps: 20),
          // A rep exercise given only a time gets default reps.
          _ex('glute_bridge', reps: null, duration: 60),
          _ex('mountain_climber', reps: null, duration: 900),
          _ex('dead_bug', sets: '3', reps: 8.6, rest: null),
        ],
      ]),
      minutes: 60,
    );
    final [squat, push, plank, bridge, climber, deadBug] =
        plan.sessions.single.exercises;
    expect((squat.sets, squat.reps, squat.restSeconds), (5, 25, 150));
    expect((push.sets, push.reps, push.restSeconds), (1, 4, 20));
    expect((plank.durationSeconds, plank.reps), (30, null));
    expect((bridge.reps, bridge.durationSeconds), (10, null));
    expect(climber.durationSeconds, 120);
    // Wrong types fall back to defaults; decimals are rounded.
    expect((deadBug.sets, deadBug.reps, deadBug.restSeconds), (3, 9, 45));
  });

  test('cardio machines may run longer than bodyweight moves', () {
    final plan = _validate(
      _plan([
        [
          _ex('leg_press'),
          _ex('chest_press'),
          _ex('seated_cable_row'),
          _ex('stationary_bike', sets: 1, reps: null, duration: 600),
        ],
      ]),
      environment: WorkoutEnvironment.gym,
      minutes: 45,
    );
    expect(plan.sessions.single.exercises.last.durationSeconds, 600);
  });

  test('cuts a session that runs well over the chosen minutes', () {
    final long = [
      for (final id in [
        'squat',
        'push_up',
        'lunge',
        'glute_bridge',
        'superman',
        'bird_dog',
        'calf_raise',
        'dead_bug',
      ])
        _ex(id, sets: 5, reps: 20, rest: 120),
    ];
    final plan = _validate(_plan([long]), minutes: 15);
    final session = plan.sessions.single;
    expect(session.exercises.length, lessThan(8));
    expect(session.exercises.length, greaterThanOrEqualTo(3));
    // Only shortened while more than three exercises are left.
    expect(
      WorkoutPlanValidator.sessionSeconds(session) <= 15 * 60 * 1.25 ||
          session.exercises.length == 3,
      isTrue,
    );
  });

  test('at most eight exercises per session', () {
    final many = [
      for (final id in [
        'squat',
        'push_up',
        'lunge',
        'glute_bridge',
        'superman',
        'bird_dog',
        'calf_raise',
        'dead_bug',
        'plank',
        'wall_sit',
      ])
        _ex(id, sets: 1, reps: 5, rest: 20),
    ];
    expect(
      _validate(_plan([many]), minutes: 60).sessions.single.exercises,
      hasLength(8),
    );
  });

  test('keeps only as many sessions as workout days', () {
    // Light activity = 3 sessions a week.
    final plan = _validate(_plan([_good, _good, _good, _good, _good]));
    expect(plan.sessions, hasLength(3));
  });

  test('sessions with too few usable exercises are dropped', () {
    final plan = _validate(
      _plan([
        [_ex('squat'), _ex('nope')],
        _good,
      ]),
    );
    expect(plan.sessions, hasLength(1));
    expect(plan.sessions.single.name, 'Day 1');
  });

  test('a missing name becomes "Day A"; long texts are shortened', () {
    final plan = _validate({
      'summary': 'x' * 500,
      'sessions': [
        {'exercises': _good},
      ],
    });
    expect(plan.sessions.single.name, 'Day A');
    expect(plan.summary.length, WorkoutPlanValidator.maxSummaryLength);
    expect(plan.summary, endsWith('…'));
  });

  test('a reply without usable sessions is invalid', () {
    expect(() => _validate({'summary': 'x'}), _invalid);
    expect(() => _validate({'sessions': 'none'}), _invalid);
    expect(() => _validate({'sessions': []}), _invalid);
    expect(
      () => _validate({
        'sessions': [42, 'x'],
      }),
      _invalid,
    );
  });
}
