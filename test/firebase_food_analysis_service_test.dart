import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cal_ai_app/core/services/firebase_food_analysis_service.dart';
import 'package:cal_ai_app/core/services/food_analysis_service.dart';
import 'package:cal_ai_app/features/food_scan/data/models/food_description.dart';
import 'package:flutter_test/flutter_test.dart';

const _validReply = '''
{
  "isFood": true,
  "items": [
    {"name": "Fried egg", "portion": "2 eggs", "calories": 180,
     "protein": 12.6, "carbs": 0.8, "fat": 14},
    {"name": "Toast", "portion": "1 slice", "calories": 80,
     "protein": 3, "carbs": 14, "fat": 1}
  ]
}''';

Matcher _failsWith(FoodAnalysisFailure failure) => throwsA(
  isA<FoodAnalysisException>().having((e) => e.failure, 'failure', failure),
);

void main() {
  // What the fake Gemini was sent.
  late String sentPrompt;
  Uint8List? sentImage;
  String? sentMime;

  FirebaseFoodAnalysisService service(
    FutureOr<String?> Function() reply, {
    Duration timeout = const Duration(seconds: 5),
  }) => FirebaseFoodAnalysisService(
    timeout: timeout,
    readFile: (path) async => Uint8List.fromList([1, 2, 3]),
    call: (prompt, {image, mimeType}) async {
      sentPrompt = prompt;
      sentImage = image;
      sentMime = mimeType;
      return reply();
    },
  );

  setUp(() {
    sentPrompt = '';
    sentImage = null;
    sentMime = null;
  });

  test('is a real service, not the demo', () {
    expect(service(() => _validReply).isDemo, isFalse);
  });

  test('photo: sends the image with its type and parses the items', () async {
    final result = await service(() => _validReply).analyzePhoto('/a/meal.PNG');
    expect(sentImage, [1, 2, 3]);
    expect(sentMime, 'image/png');
    expect(sentPrompt, contains('photo'));
    expect(result.items.map((i) => i.name), ['Fried egg', 'Toast']);
    expect(result.totalCalories, 260);
  });

  test('text: sends the description and details, no image', () async {
    await service(() => _validReply).analyzeText(
      const FoodDescription(
        text: 'two fried eggs and toast',
        cookingMethod: 'fried in butter',
      ),
    );
    expect(sentImage, isNull);
    expect(sentPrompt, contains('two fried eggs and toast'));
    expect(sentPrompt, contains('Cooking: fried in butter'));
  });

  test('image types from the file name', () {
    String type(String p) => FirebaseFoodAnalysisService.mimeTypeFor(p);
    expect(type('x.jpg'), 'image/jpeg');
    expect(type('x.jpeg'), 'image/jpeg');
    expect(type('x.webp'), 'image/webp');
    expect(type('x.heic'), 'image/heic');
    expect(type('x'), 'image/jpeg');
  });

  test('"no food" reply → notFood', () {
    expect(
      service(() => '{"isFood": false, "items": []}').analyzePhoto('/a.jpg'),
      _failsWith(FoodAnalysisFailure.notFood),
    );
  });

  test('empty, non-JSON or wrong-shape replies → invalidResponse', () {
    for (final reply in [null, '  ', 'Sure! Here is the food:', '[1, 2]']) {
      expect(
        service(() => reply).analyzePhoto('/a.jpg'),
        _failsWith(FoodAnalysisFailure.invalidResponse),
        reason: 'reply: $reply',
      );
    }
  });

  test('no connection or a timeout → network', () {
    expect(
      service(() => throw const SocketException('offline'))
          .analyzeText(const FoodDescription(text: 'rice')),
      _failsWith(FoodAnalysisFailure.network),
    );
    expect(
      service(
        () => Completer<String?>().future, // never answers
        timeout: const Duration(milliseconds: 10),
      ).analyzeText(const FoodDescription(text: 'rice')),
      _failsWith(FoodAnalysisFailure.network),
    );
  });

  test('other errors (e.g. AI Logic not enabled) → unknown', () {
    expect(
      service(() => throw StateError('API not enabled')).analyzePhoto('/a.jpg'),
      _failsWith(FoodAnalysisFailure.unknown),
    );
  });
}
