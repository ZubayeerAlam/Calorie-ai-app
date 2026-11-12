import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cal_ai_app/core/services/firebase_workout_plan_service.dart';
import 'package:cal_ai_app/core/services/workout_plan_service.dart';
import 'package:cal_ai_app/features/exercise/data/models/exercise_settings.dart';
import 'package:cal_ai_app/features/exercise/data/models/workout_plan.dart';
import 'package:cal_ai_app/features/profile/data/models/user_profile.dart';
import 'package:cal_ai_app/l10n/l10n.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_test/flutter_test.dart';

import 'plan_test_data.dart';

const _reply = '''
{
  "summary": "Three full-body sessions to build strength.",
  "sessions": [
    {"name": "Full body", "focus": "Strength",
     "exercises": [
       {"exerciseId": "squat", "sets": 3, "reps": 12, "restSeconds": 60,
        "why": "Strong legs"},
       {"exerciseId": "push_up", "sets": 3, "reps": 10, "restSeconds": 60,
        "why": "Upper body"},
       {"exerciseId": "plank", "sets": 3, "durationSeconds": 30,
        "restSeconds": 45, "why": "Core"}
     ]}
  ]
}''';

Matcher _failsWith(WorkoutPlanFailure failure) => throwsA(
  isA<WorkoutPlanException>().having((e) => e.failure, 'failure', failure),
);

void main() {
  late String sentPrompt;
  late Schema sentSchema;

  FirebaseWorkoutPlanService service(
    FutureOr<String?> Function() reply, {
    Duration timeout = const Duration(seconds: 5),
  }) => FirebaseWorkoutPlanService(
    timeout: timeout,
    call: (prompt, schema) async {
      sentPrompt = prompt;
      sentSchema = schema;
      return reply();
    },
  );

  tearDown(() => useLocalizations(lookupAppLocalizations(const Locale('en'))));

  test('uses AI', () {
    expect(service(() => _reply).usesAi, isTrue);
  });

  test('sends the profile, settings and allowed exercises', () async {
    final request = testRequest(
      profile: testProfile(
        goal: GoalType.lose,
        focuses: [GoalFocus.gainMuscle],
      ),
      limitations: {BodyLimitation.knees},
      equipment: {HomeEquipment.bands},
      minutes: 45,
    );
    // Squat isn't allowed with bad knees, so the fake reply uses a bridge.
    final reply = _reply.replaceAll('squat', 'glute_bridge');
    final plan = await service(() => reply).generatePlan(request);

    expect(sentPrompt, contains('Age: 31; gender: male'));
    expect(sentPrompt, contains('Height: 175 cm; weight: 72.0 kg'));
    expect(sentPrompt, contains('Weight goal: lose weight'));
    expect(sentPrompt, contains('Also wants to: gain muscle'));
    expect(sentPrompt, contains('Fitness level: beginner'));
    expect(sentPrompt, contains('Works out at: home'));
    expect(sentPrompt, contains('Home equipment: bands'));
    expect(sentPrompt, contains('Go easy on: knees'));
    expect(sentPrompt, contains('3 sessions a week, about 45 minutes each'));
    expect(sentPrompt, contains('- push_up: Push-up; chest, shoulders'));
    expect(sentPrompt, contains('- plank: Plank; core, shoulders; timed'));
    expect(sentPrompt, contains('band_row'));
    // Not allowed: knees, the gym, dumbbells.
    expect(sentPrompt, isNot(contains('- squat:')));
    expect(sentPrompt, isNot(contains('leg_press')));
    expect(sentPrompt, isNot(contains('goblet_squat')));
    expect(sentPrompt, isNot(contains('Bangla')));

    // The schema only accepts the allowed ids.
    final exercise = sentSchema
        .properties!['sessions']!
        .items!
        .properties!['exercises']!
        .items!;
    expect(exercise.properties!['exerciseId']!.enumValues, [
      for (final e in request.allowed) e.id,
    ]);
    expect(exercise.optionalProperties, ['reps', 'durationSeconds']);

    expect(plan.source, PlanSource.ai);
    expect(plan.id, startsWith('ai-'));
    expect(plan.summary, contains('Three full-body'));
  });

  test('exercises the user may not do are removed from the reply', () async {
    // Squat is in the reply, but not allowed with bad knees: only two
    // exercises are left, too few for a session.
    await expectLater(
      service(() => _reply)
          .generatePlan(testRequest(limitations: {BodyLimitation.knees})),
      _failsWith(WorkoutPlanFailure.invalidResponse),
    );
  });

  test('parses a good reply into a checked plan', () async {
    final plan = await service(() => _reply).generatePlan(testRequest());
    final [session] = plan.sessions;
    expect(session.name, 'Full body');
    expect(
      [for (final e in session.exercises) e.exerciseId],
      ['squat', 'push_up', 'plank'],
    );
    expect(session.exercises.first.why, 'Strong legs');
    expect(plan.inputsKey, testRequest().inputsKey);
  });

  test('asks for Bangla texts when the app is in Bangla', () async {
    useLocalizations(lookupAppLocalizations(const Locale('bn')));
    await service(() => _reply).generatePlan(testRequest());
    expect(sentPrompt, contains('in Bangla'));
    // Exercise names in the list stay English.
    expect(sentPrompt, contains('Push-up'));
  });

  test('bad replies are invalid responses', () async {
    for (final reply in [null, '', 'not json', '[1, 2]', '{"sessions": []}']) {
      await expectLater(
        service(() => reply).generatePlan(testRequest()),
        _failsWith(WorkoutPlanFailure.invalidResponse),
        reason: '$reply',
      );
    }
  });

  test('no connection and timeouts are network failures', () async {
    await expectLater(
      service(() => throw const SocketException('offline'))
          .generatePlan(testRequest()),
      _failsWith(WorkoutPlanFailure.network),
    );
    await expectLater(
      service(
        () => Completer<String?>().future,
        timeout: const Duration(milliseconds: 10),
      ).generatePlan(testRequest()),
      _failsWith(WorkoutPlanFailure.network),
    );
  });

  test('other errors are unknown failures', () async {
    await expectLater(
      service(() => throw StateError('quota')).generatePlan(testRequest()),
      _failsWith(WorkoutPlanFailure.unknown),
    );
  });

  test('the plan fingerprint changes with the inputs that matter', () {
    final base = testRequest().inputsKey;
    expect(testRequest().inputsKey, base);
    expect(testRequest(minutes: 45).inputsKey, isNot(base));
    expect(
      testRequest(limitations: {BodyLimitation.knees}).inputsKey,
      isNot(base),
    );
    expect(
      testRequest(profile: testProfile(goal: GoalType.gain)).inputsKey,
      isNot(base),
    );
    // Small weigh-in changes don't count.
    expect(testRequest(profile: testProfile(weightKg: 72.3)).inputsKey, base);
    expect(
      testRequest(profile: testProfile(weightKg: 74)).inputsKey,
      isNot(base),
    );
    // Order of chosen equipment doesn't matter.
    expect(
      testRequest(equipment: {HomeEquipment.bands, HomeEquipment.dumbbells})
          .inputsKey,
      testRequest(equipment: {HomeEquipment.dumbbells, HomeEquipment.bands})
          .inputsKey,
    );
  });
}
