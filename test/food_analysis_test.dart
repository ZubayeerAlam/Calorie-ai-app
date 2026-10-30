import 'package:cal_ai_app/core/services/demo_food_analysis_service.dart';
import 'package:cal_ai_app/core/services/food_analysis_service.dart';
import 'package:cal_ai_app/features/food_scan/data/models/food_analysis.dart';
import 'package:cal_ai_app/features/food_scan/data/models/food_description.dart';
import 'package:flutter_test/flutter_test.dart';

Matcher _failsWith(FoodAnalysisFailure failure) => throwsA(
  isA<FoodAnalysisException>().having((e) => e.failure, 'failure', failure),
);

void main() {
  group('FoodAnalysis.fromJson', () {
    test('reads items; whole numbers work for grams', () {
      final result = FoodAnalysis.fromJson({
        'isFood': true,
        'items': [
          {
            'name': ' Banana ',
            'portion': '1 medium',
            'calories': 105.4,
            'protein': 1,
            'carbs': 27,
            'fat': 0.4,
          },
        ],
      });
      final item = result.items.single;
      expect(item.name, 'Banana'); // trimmed
      expect(item.portion, '1 medium');
      expect(item.calories, 105); // rounded
      expect(item.protein, 1.0);
      expect(item.carbs, 27.0);
      expect(result.totalCalories, 105);
    });

    test('missing macros and portion default to 0 / empty', () {
      final item = FoodAnalysis.fromJson({
        'items': [
          {'name': 'Tea', 'calories': 2},
        ],
      }).items.single;
      expect(item.portion, '');
      expect(item.protein, 0);
    });

    test('isFood false or no items → notFood', () {
      expect(
        () => FoodAnalysis.fromJson({'isFood': false, 'items': []}),
        _failsWith(FoodAnalysisFailure.notFood),
      );
      expect(
        () => FoodAnalysis.fromJson({'items': []}),
        _failsWith(FoodAnalysisFailure.notFood),
      );
    });

    test('malformed replies → invalidResponse', () {
      expect(
        () => FoodAnalysis.fromJson({'isFood': true}),
        _failsWith(FoodAnalysisFailure.invalidResponse),
      );
      expect(
        () => FoodAnalysis.fromJson({
          'items': [
            {'name': 'Soup'},
          ],
        }),
        _failsWith(FoodAnalysisFailure.invalidResponse),
      );
      expect(
        () => FoodAnalysis.fromJson({
          'items': [
            {'name': '', 'calories': 10},
          ],
        }),
        _failsWith(FoodAnalysisFailure.invalidResponse),
      );
      expect(
        () => FoodAnalysis.fromJson({
          'items': [
            {'name': 'Soup', 'calories': 90, 'fat': -1},
          ],
        }),
        _failsWith(FoodAnalysisFailure.invalidResponse),
      );
      expect(
        () => FoodAnalysis.fromJson({
          'items': ['soup'],
        }),
        _failsWith(FoodAnalysisFailure.invalidResponse),
      );
    });

    test('items survive a JSON round trip', () {
      const item = AnalyzedFoodItem(
        name: 'Rice',
        portion: '1 cup',
        calories: 206,
        protein: 4.3,
        carbs: 44.5,
        fat: 0.4,
      );
      expect(AnalyzedFoodItem.fromJson(item.toJson()), item);
    });
  });

  group('DemoFoodAnalysisService', () {
    const demo = DemoFoodAnalysisService(delay: Duration.zero);

    test('is marked as a demo', () => expect(demo.isDemo, isTrue));

    test('same photo gives the same sample meal', () async {
      final a = await demo.analyzePhoto('/photos/lunch.jpg');
      final b = await demo.analyzePhoto('/photos/lunch.jpg');
      expect(a.items, isNotEmpty);
      expect(a.items, b.items);
    });
  });

  group('FoodDescription', () {
    test('details list only what was filled in; JSON skips blanks', () {
      const d = FoodDescription(
        text: ' Pad thai ',
        portion: '1 box',
        cookingMethod: ' ',
        brand: 'Thai Express',
      );
      expect(d.details, [('Portion', '1 box'), ('Brand', 'Thai Express')]);
      expect(d.toJson(), {
        'text': 'Pad thai',
        'portion': '1 box',
        'brand': 'Thai Express',
      });
    });
  });

  group('DemoFoodAnalysisService.analyzeText', () {
    const demo = DemoFoodAnalysisService(delay: Duration.zero);

    test('one item per food in the description', () async {
      final result = await demo.analyzeText(
        const FoodDescription(
          text: '2 scrambled eggs, toast with butter and black coffee',
        ),
      );
      expect(result.items.map((i) => i.name), [
        '2 scrambled eggs',
        'Toast with butter',
        'Black coffee',
      ]);
      for (final item in result.items) {
        expect(item.calories, inInclusiveRange(80, 400));
      }
    });

    test(
      'a single food keeps the portion detail; same text, same numbers',
      () async {
        const d = FoodDescription(text: 'banana', portion: '1 large');
        final a = await demo.analyzeText(d);
        final b = await demo.analyzeText(d);
        expect(a.items.single.name, 'Banana');
        expect(a.items.single.portion, '1 large');
        expect(a.items, b.items);
      },
    );

    test('nothing that looks like food → notFood', () {
      expect(
        () => demo.analyzeText(const FoodDescription(text: ' , and ; ')),
        _failsWith(FoodAnalysisFailure.notFood),
      );
    });
  });
}
