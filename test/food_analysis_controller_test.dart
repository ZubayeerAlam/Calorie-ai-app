import 'package:cal_ai_app/core/services/food_analysis_service.dart';
import 'package:cal_ai_app/features/food_log/data/models/food_entry.dart';
import 'package:cal_ai_app/features/food_log/presentation/meal_type_labels.dart';
import 'package:cal_ai_app/features/food_scan/data/models/analysis_request.dart';
import 'package:cal_ai_app/features/food_scan/data/models/food_description.dart';
import 'package:cal_ai_app/features/food_scan/providers/food_analysis_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_food_analysis_service.dart';

FoodAnalysisController _controller(
  FakeFoodAnalysisService service, {
  DateTime? now,
}) => FoodAnalysisController(
  service: service,
  request: const PhotoAnalysisRequest('/photos/meal.jpg'),
  now: now ?? DateTime(2026, 10, 30, 13),
);

void main() {
  test('analyses on creation and becomes ready with the items', () async {
    final c = _controller(FakeFoodAnalysisService());
    expect(c.status, AnalysisStatus.analyzing);
    await pumpEventQueue();
    expect(c.status, AnalysisStatus.ready);
    expect(c.items, hasLength(2));
    expect(c.totalCalories, 454);
    expect(c.canSave, isTrue);
  });

  test('a failure can be retried', () async {
    final service = FakeFoodAnalysisService(
      failures: [FoodAnalysisFailure.network],
    );
    final c = _controller(service);
    await pumpEventQueue();
    expect(c.status, AnalysisStatus.failed);
    expect(c.failure, FoodAnalysisFailure.network);
    expect(c.canSave, isFalse);

    await c.analyze();
    expect(c.status, AnalysisStatus.ready);
    expect(c.failure, isNull);
    expect(service.calls, 2);
  });

  test('edits and removals update the total and what can be saved', () async {
    final c = _controller(FakeFoodAnalysisService());
    await pumpEventQueue();

    c.updateItem(0, c.items[0].copyWith(calories: 300));
    expect(c.totalCalories, 506);

    c.updateItem(0, c.items[0].copyWith(name: '  '));
    expect(c.canSave, isFalse); // every item needs a name
    c.updateItem(0, c.items[0].copyWith(name: 'Chicken'));

    final keptKey = c.itemKey(1);
    c.removeItem(0);
    expect(c.items.single.name, 'Steamed rice');
    expect(c.itemKey(0), keptKey); // stable keys for the edit fields
    expect(c.totalCalories, 206);

    c.removeItem(0);
    expect(c.canSave, isFalse);
  });

  test('the meal is suggested from the time of day and can be changed', () {
    final service = FakeFoodAnalysisService();
    expect(
      _controller(service, now: DateTime(2026, 1, 1, 8)).meal,
      MealType.breakfast,
    );
    expect(
      _controller(service, now: DateTime(2026, 1, 1, 13)).meal,
      MealType.lunch,
    );
    expect(
      _controller(service, now: DateTime(2026, 1, 1, 19)).meal,
      MealType.dinner,
    );
    final c = _controller(service)..setMeal(MealType.snack);
    expect(c.meal, MealType.snack);
  });

  test('meal suggestion boundaries', () {
    MealType at(int h) => MealTypeLabel.suggestedFor(DateTime(2026, 1, 1, h));
    expect(at(9), MealType.breakfast);
    expect(at(10), MealType.lunch);
    expect(at(15), MealType.snack);
    expect(at(17), MealType.dinner);
    expect(at(22), MealType.snack);
  });

  test('entries keep the photo, the day, and the AI estimate mark', () async {
    final c = _controller(FakeFoodAnalysisService())..setMeal(MealType.dinner);
    await pumpEventQueue();
    c.updateItem(1, c.items[1].copyWith(name: ' Rice ', portion: ''));

    final entries = c.toEntries(
      DateTime(2026, 10, 29),
      now: DateTime(2026, 10, 30, 19, 45, 10),
    );
    expect(entries, hasLength(2));
    expect(entries.map((e) => e.id).toSet(), hasLength(2));
    for (final e in entries) {
      expect(e.aiEstimated, isTrue);
      expect(e.imagePath, '/photos/meal.jpg');
      expect(e.mealType, MealType.dinner);
      expect(e.loggedAt, DateTime(2026, 10, 29, 19, 45, 10));
    }
    expect(entries[0].portion, '150 g');
    expect(entries[1].name, 'Rice');
    expect(entries[1].portion, isNull);
  });

  test('closing the screen mid-analysis is safe', () async {
    final service = FakeFoodAnalysisService(hold: true);
    final c = _controller(service);
    c.dispose();
    service.release();
    await pumpEventQueue(); // no "used after dispose" error
  });

  test(
    'a typed description is analysed as text; entries have no photo',
    () async {
      final service = FakeFoodAnalysisService();
      const description = FoodDescription(
        text: 'chicken and rice',
        portion: '1 plate',
      );
      final c = FoodAnalysisController(
        service: service,
        request: const TextAnalysisRequest(description),
        now: DateTime(2026, 10, 30, 13),
      );
      expect(c.imagePath, isNull);
      expect(c.description, same(description));
      await pumpEventQueue();

      expect(service.lastDescription, same(description));
      expect(c.status, AnalysisStatus.ready);
      final entries = c.toEntries(DateTime(2026, 10, 30));
      expect(entries.every((e) => e.imagePath == null), isTrue);
      expect(entries.every((e) => e.aiEstimated), isTrue);
    },
  );
}
