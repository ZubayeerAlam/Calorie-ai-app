import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

import '../../features/exercise/data/catalog/exercise_texts.dart';
import '../../features/exercise/data/models/workout_plan.dart';
import '../../features/exercise/data/workout_plan_request.dart';
import '../../features/exercise/data/workout_plan_validator.dart';
import '../../l10n/l10n.dart';
import '../constants/app_constants.dart';
import 'gemini_errors.dart';
import 'workout_plan_service.dart';

/// Sends a prompt to the model with a reply [schema] and returns its text.
typedef GeminiJsonCall = Future<String?> Function(String prompt, Schema schema);

/// Workout plans from Gemini through Firebase AI Logic.
///
/// Gemini only chooses from the exercises allowed for the user (the
/// schema lists their ids), and sets the sets, reps or time, and rest.
/// [WorkoutPlanValidator] then checks and corrects the reply, so the app
/// never shows an exercise it can't demonstrate or an unsafe amount.
class FirebaseWorkoutPlanService implements WorkoutPlanService {
  /// [call] is replaceable for tests; by default it uses Gemini.
  FirebaseWorkoutPlanService({
    GeminiJsonCall? call,
    this.timeout = const Duration(seconds: 60),
  }) : _call = call ?? _geminiCall;

  final GeminiJsonCall _call;
  final Duration timeout;

  @override
  bool get usesAi => true;

  static const String _instructions =
      'You are the workout coach of a calorie-tracking app. Build a safe, '
      'balanced weekly workout plan for the user described, using only the '
      'allowed exercises (by id). Give exactly the number of sessions asked '
      'for; each session has 4 to 7 exercises that fit the session length, '
      'including rests. Balance push, pull, legs, core and cardio across '
      'the week, and do not repeat an exercise within a session. '
      'Rep exercises get "reps" and no "durationSeconds"; timed exercises '
      'get "durationSeconds" and no "reps". Beginners: 2 sets and easier '
      'exercises; intermediate: 3 sets; advanced: 3-4 sets. Building muscle: '
      'about 8-12 reps; losing weight: 12-15 reps with shorter rests. '
      'Rest is 30-120 seconds. '
      'Write a short summary of the plan, a short name and focus for each '
      'session, and for each exercise a short "why" linking it to the '
      "user's goals. Do not give medical advice, and never claim an "
      'exercise burns fat from a body part or a specific amount of fat. '
      'Reply only with JSON that matches the schema.';

  static Future<String?> _geminiCall(String prompt, Schema schema) async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: AppConstants.workoutPlanModel,
      systemInstruction: Content.system(_instructions),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: schema,
        temperature: 0.3,
      ),
    );
    final response = await model.generateContent([Content.text(prompt)]);
    return response.text;
  }

  /// The reply shape; exercise ids are limited to [allowedIds].
  @visibleForTesting
  static Schema schemaFor(List<String> allowedIds) => Schema.object(
    properties: {
      'summary': Schema.string(description: 'One or two sentences.'),
      'sessions': Schema.array(
        items: Schema.object(
          properties: {
            'name': Schema.string(description: 'e.g. "Upper body".'),
            'focus': Schema.string(description: 'What the session trains.'),
            'exercises': Schema.array(
              items: Schema.object(
                properties: {
                  'exerciseId': Schema.enumString(enumValues: allowedIds),
                  'sets': Schema.integer(),
                  'reps': Schema.integer(description: 'Rep exercises only.'),
                  'durationSeconds': Schema.integer(
                    description: 'Timed exercises only: seconds per set.',
                  ),
                  'restSeconds': Schema.integer(),
                  'why': Schema.string(description: 'Under 100 characters.'),
                },
                optionalProperties: ['reps', 'durationSeconds'],
                propertyOrdering: [
                  'exerciseId',
                  'sets',
                  'reps',
                  'durationSeconds',
                  'restSeconds',
                  'why',
                ],
              ),
            ),
          },
          propertyOrdering: ['name', 'focus', 'exercises'],
        ),
      ),
    },
    propertyOrdering: ['summary', 'sessions'],
  );

  /// The prompt: the user's details, the plan's shape, and the exercises
  /// to choose from (in English, whatever the app language).
  @visibleForTesting
  static String promptFor(WorkoutPlanRequest request) {
    final english = lookupAppLocalizations(const Locale('en'));
    final p = request.profile;
    final s = request.settings;
    return [
      'User:',
      '- Age: ${request.age}; gender: ${p.gender.name}',
      '- Height: ${p.heightCm} cm; weight: ${p.weightKg.toStringAsFixed(1)} kg',
      '- Weight goal: ${p.goal.name} weight',
      if (p.focuses.isNotEmpty)
        '- Also wants to: ${[for (final f in p.focuses) _focusText(f.name)].join(', ')}',
      '- Activity level: ${p.activityLevel.name}',
      '- Fitness level: ${s.level.name}',
      '- Works out at: ${s.environment.name}',
      if (s.homeEquipment.isNotEmpty)
        '- Home equipment: ${[for (final e in s.homeEquipment) e.name].join(', ')}',
      if (s.limitations.isNotEmpty)
        '- Go easy on: ${[for (final l in s.limitations) l.name].join(', ')} '
            '(exercises that load these are already removed)',
      '',
      'Plan: ${request.sessionsPerWeek} sessions a week, '
          'about ${s.sessionMinutes} minutes each.',
      '',
      'Allowed exercises (id: name; muscles; reps or timed):',
      for (final e in request.allowed)
        '- ${e.id}: ${ExerciseTexts.nameOf(e.id, english)}; '
            '${[for (final m in e.muscles) m.name].join(', ')}; '
            '${e.isTimed ? 'timed' : 'reps'}',
      ?languageLine(),
    ].join('\n');
  }

  static String _focusText(String focus) => switch (focus) {
    'gainMuscle' => 'gain muscle',
    'boostEnergy' => 'boost energy',
    'improveNutrition' => 'improve nutrition',
    _ => focus,
  };

  /// Asks for the texts in the app's language; null for English.
  @visibleForTesting
  static String? languageLine() => switch (l10n.localeName) {
    'bn' =>
      'Write the summary, session names, focus and every "why" in Bangla '
          '(Bengali). Keep exercise ids and field names as they are.',
    _ => null,
  };

  @override
  Future<WorkoutPlan> generatePlan(WorkoutPlanRequest request) async {
    if (request.allowed.isEmpty) {
      throw const WorkoutPlanException(
        WorkoutPlanFailure.invalidResponse,
        'No exercises allowed',
      );
    }
    final String? reply;
    try {
      reply = await _call(
        promptFor(request),
        schemaFor([for (final e in request.allowed) e.id]),
      ).timeout(timeout);
    } on SocketException catch (e) {
      throw WorkoutPlanException(WorkoutPlanFailure.network, e.message);
    } on TimeoutException {
      throw const WorkoutPlanException(WorkoutPlanFailure.network, 'Timed out');
    } catch (e) {
      // e.g. AI Logic not enabled, quota used up, App Check refused.
      debugPrint('Workout plan failed: $e');
      throw WorkoutPlanException(
        isGeminiNetworkError(e)
            ? WorkoutPlanFailure.network
            : WorkoutPlanFailure.unknown,
        '$e',
      );
    }
    return parseReply(reply, request);
  }

  @visibleForTesting
  static WorkoutPlan parseReply(String? reply, WorkoutPlanRequest request) {
    if (reply == null || reply.trim().isEmpty) {
      throw const WorkoutPlanException(
        WorkoutPlanFailure.invalidResponse,
        'Empty reply',
      );
    }
    final Object? json;
    try {
      json = jsonDecode(reply);
    } on FormatException catch (e) {
      throw WorkoutPlanException(WorkoutPlanFailure.invalidResponse, e.message);
    }
    if (json is! Map<String, dynamic>) {
      throw const WorkoutPlanException(
        WorkoutPlanFailure.invalidResponse,
        'Reply is not a JSON object',
      );
    }
    return WorkoutPlanValidator.validate(
      json,
      request,
      id: 'ai-${request.now.microsecondsSinceEpoch}',
      source: PlanSource.ai,
    );
  }
}
