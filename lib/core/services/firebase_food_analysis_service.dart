import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

import '../../features/food_scan/data/models/food_analysis.dart';
import '../../features/food_scan/data/models/food_description.dart';
import '../constants/app_constants.dart';
import 'food_analysis_service.dart';

/// Sends a prompt, plus an optional image, to the model and returns the
/// model's text reply.
typedef GeminiCall = Future<String?> Function(
  String prompt, {
  Uint8List? image,
  String? mimeType,
});

/// Real food analysis with Gemini through Firebase AI Logic (Gemini
/// Developer API). The API key stays in Firebase; the app never holds it.
///
/// Gemini is asked for JSON in the exact shape [FoodAnalysis.fromJson]
/// reads, so the review screens work the same as with the demo service.
class FirebaseFoodAnalysisService implements FoodAnalysisService {
  /// [call] and [readFile] are replaceable for tests; by default they use
  /// Gemini and the device's file system.
  FirebaseFoodAnalysisService({
    GeminiCall? call,
    Future<Uint8List> Function(String path)? readFile,
    this.timeout = const Duration(seconds: 45),
  }) : _call = call ?? _geminiCall(),
       _readFile = readFile ?? ((path) => File(path).readAsBytes());

  final GeminiCall _call;
  final Future<Uint8List> Function(String path) _readFile;
  final Duration timeout;

  @override
  bool get isDemo => false;

  static const String _instructions =
      'You are the nutrition assistant of a calorie-tracking app. '
      'Identify each distinct food or drink and estimate a realistic portion '
      'and its nutrition, using standard nutrition references. '
      'For each item give: a short, plain name; the portion (e.g. '
      '"1 cup (160 g)"); calories in kcal as a whole number; and protein, '
      'carbs and fat in grams. Include cooking oils, sauces and drinks when '
      'they are visible or mentioned. '
      'If there is no food or drink at all, set isFood to false and return '
      'an empty items list. Reply only with JSON that matches the schema.';

  /// The reply shape, matching [FoodAnalysis.fromJson].
  static final Schema _replySchema = Schema.object(
    properties: {
      'isFood': Schema.boolean(
        description: 'False when there is no food or drink at all.',
      ),
      'items': Schema.array(
        items: Schema.object(
          properties: {
            'name': Schema.string(description: 'Short food name.'),
            'portion': Schema.string(description: 'e.g. "1 cup (160 g)".'),
            'calories': Schema.integer(description: 'Kilocalories.'),
            'protein': Schema.number(description: 'Grams of protein.'),
            'carbs': Schema.number(description: 'Grams of carbohydrate.'),
            'fat': Schema.number(description: 'Grams of fat.'),
          },
          propertyOrdering: [
            'name',
            'portion',
            'calories',
            'protein',
            'carbs',
            'fat',
          ],
        ),
      ),
    },
    propertyOrdering: ['isFood', 'items'],
  );

  /// Builds the Gemini model lazily, on the first call, so creating this
  /// service never touches Firebase.
  static GeminiCall _geminiCall() {
    GenerativeModel? model;
    return (prompt, {image, mimeType}) async {
      model ??= FirebaseAI.googleAI().generativeModel(
        model: AppConstants.foodAnalysisModel,
        systemInstruction: Content.system(_instructions),
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: _replySchema,
          temperature: 0.2,
        ),
      );
      final response = await model!.generateContent([
        Content.multi([
          TextPart(prompt),
          if (image != null) InlineDataPart(mimeType ?? 'image/jpeg', image),
        ]),
      ]);
      return response.text;
    };
  }

  @override
  Future<FoodAnalysis> analyzePhoto(String imagePath) => _run(() async {
    final bytes = await _readFile(imagePath);
    return _call(
      'Analyse the food and drinks in this photo.',
      image: bytes,
      mimeType: mimeTypeFor(imagePath),
    );
  });

  @override
  Future<FoodAnalysis> analyzeText(FoodDescription description) =>
      _run(() => _call(promptFor(description)));

  /// The text prompt for a typed meal, with any optional details.
  @visibleForTesting
  static String promptFor(FoodDescription description) => [
    'Analyse this meal, described by the user:',
    description.text.trim(),
    for (final (label, value) in description.details) '$label: $value',
  ].join('\n');

  /// Image type from the file name; JPEG when unknown.
  @visibleForTesting
  static String mimeTypeFor(String path) =>
      switch (path.split('.').last.toLowerCase()) {
        'png' => 'image/png',
        'webp' => 'image/webp',
        'heic' => 'image/heic',
        'heif' => 'image/heif',
        _ => 'image/jpeg',
      };

  /// Runs a request and turns the reply, or any error, into a result or a
  /// [FoodAnalysisException] the screens understand.
  Future<FoodAnalysis> _run(Future<String?> Function() request) async {
    final String? reply;
    try {
      reply = await request().timeout(timeout);
    } on FoodAnalysisException {
      rethrow;
    } on SocketException catch (e) {
      throw FoodAnalysisException(FoodAnalysisFailure.network, e.message);
    } on TimeoutException {
      throw const FoodAnalysisException(
        FoodAnalysisFailure.network,
        'Timed out',
      );
    } on FileSystemException catch (e) {
      throw FoodAnalysisException(FoodAnalysisFailure.unknown, e.message);
    } catch (e) {
      // e.g. AI Logic not enabled, quota used up, server error. Logged so
      // it shows in the console while developing.
      debugPrint('Food analysis failed: $e');
      throw FoodAnalysisException(
        _isNetworkError(e)
            ? FoodAnalysisFailure.network
            : FoodAnalysisFailure.unknown,
        '$e',
      );
    }
    return parseReply(reply);
  }

  /// Connection problems from the HTTP layer (its `ClientException`).
  static bool _isNetworkError(Object e) =>
      e.runtimeType.toString() == 'ClientException' ||
      '$e'.contains('Failed host lookup');

  /// Parses Gemini's JSON reply.
  @visibleForTesting
  static FoodAnalysis parseReply(String? reply) {
    if (reply == null || reply.trim().isEmpty) {
      throw const FoodAnalysisException(
        FoodAnalysisFailure.invalidResponse,
        'Empty reply',
      );
    }
    final Object? json;
    try {
      json = jsonDecode(reply);
    } on FormatException catch (e) {
      throw FoodAnalysisException(
        FoodAnalysisFailure.invalidResponse,
        e.message,
      );
    }
    if (json is! Map<String, dynamic>) {
      throw const FoodAnalysisException(
        FoodAnalysisFailure.invalidResponse,
        'Reply is not a JSON object',
      );
    }
    return FoodAnalysis.fromJson(json);
  }
}
