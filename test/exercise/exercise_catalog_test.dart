import 'dart:ui';

import 'package:cal_ai_app/features/exercise/data/catalog/exercise_catalog.dart';
import 'package:cal_ai_app/features/exercise/data/catalog/exercise_texts.dart';
import 'package:cal_ai_app/features/exercise/data/models/exercise.dart';
import 'package:cal_ai_app/features/exercise/data/models/exercise_settings.dart';
import 'package:cal_ai_app/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

ExerciseSettings _settings(
  WorkoutEnvironment environment, {
  Set<HomeEquipment> equipment = const {},
  Set<BodyLimitation> limitations = const {},
}) => ExerciseSettings(
  environment: environment,
  level: FitnessLevel.beginner,
  homeEquipment: equipment,
  limitations: limitations,
);

Set<String> _ids(List<Exercise> exercises) => {for (final e in exercises) e.id};

void main() {
  final languages = {
    'en': lookupAppLocalizations(const Locale('en')),
    'bn': lookupAppLocalizations(const Locale('bn')),
  };

  test('the catalog has about 30 exercises with unique ids', () {
    expect(ExerciseCatalog.all.length, greaterThanOrEqualTo(30));
    expect(_ids(ExerciseCatalog.all), hasLength(ExerciseCatalog.all.length));
    expect(ExerciseCatalog.byId('push_up')!.kind, ExerciseKind.reps);
    expect(ExerciseCatalog.byId('nope'), isNull);
  });

  test('every exercise has sensible numbers', () {
    for (final e in ExerciseCatalog.all) {
      expect(e.environments, isNotEmpty, reason: e.id);
      expect(e.muscles, isNotEmpty, reason: e.id);
      expect(e.met, inInclusiveRange(2, 10), reason: e.id);
      expect(e.secondsPerRep, greaterThan(0), reason: e.id);
      expect(e.defaultRestSeconds, inInclusiveRange(20, 150), reason: e.id);
      expect(RegExp(r'^[a-z_]+$').hasMatch(e.id), isTrue, reason: e.id);
    }
  });

  for (final MapEntry(key: lang, value: loc) in languages.entries) {
    test('every exercise and muscle has $lang texts', () {
      final names = <String>{};
      for (final e in ExerciseCatalog.all) {
        final texts = ExerciseTexts.of(e.id, loc);
        expect(texts, isNotNull, reason: e.id);
        expect(texts!.steps, hasLength(3), reason: e.id);
        for (final text in [
          texts.name,
          texts.position,
          texts.tip,
          texts.benefit,
          ...texts.steps,
        ]) {
          expect(text.trim(), isNotEmpty, reason: e.id);
        }
        names.add(texts.name);
      }
      expect(names, hasLength(ExerciseCatalog.all.length));
      for (final m in MuscleGroup.values) {
        expect(ExerciseTexts.muscle(m, loc), isNotEmpty);
      }
    });
  }

  test('an unknown id falls back to the id as its name', () {
    expect(ExerciseTexts.of('nope', languages['en']), isNull);
    expect(ExerciseTexts.nameOf('nope', languages['en']), 'nope');
    expect(ExerciseTexts.nameOf('push_up', languages['en']), 'Push-up');
  });

  group('allowedFor', () {
    test('home without equipment is bodyweight only', () {
      final home = ExerciseCatalog.allowedFor(
        _settings(WorkoutEnvironment.home),
      );
      expect(home.every((e) => e.equipment == Equipment.none), isTrue);
      expect(_ids(home), containsAll(['push_up', 'squat', 'plank']));
      expect(_ids(home), isNot(contains('leg_press')));
    });

    test('home equipment adds dumbbell and band exercises', () {
      final ids = _ids(
        ExerciseCatalog.allowedFor(
          _settings(
            WorkoutEnvironment.home,
            equipment: {HomeEquipment.dumbbells, HomeEquipment.bands},
          ),
        ),
      );
      expect(ids, containsAll(['goblet_squat', 'band_row']));
      expect(ids, isNot(contains('chest_press')));
    });

    test('the gym has machines and dumbbells but no bands or home moves', () {
      final ids = _ids(
        ExerciseCatalog.allowedFor(_settings(WorkoutEnvironment.gym)),
      );
      expect(ids, containsAll(['leg_press', 'lat_pulldown', 'goblet_squat']));
      expect(ids, isNot(contains('band_row')));
      expect(ids, isNot(contains('chair_dip')));
    });

    test('limitations leave out exercises that load that area', () {
      final ids = _ids(
        ExerciseCatalog.allowedFor(
          _settings(
            WorkoutEnvironment.home,
            limitations: {BodyLimitation.knees},
          ),
        ),
      );
      expect(ids, isNot(contains('squat')));
      expect(ids, isNot(contains('lunge')));
      expect(ids, contains('glute_bridge'));
    });

    for (final environment in WorkoutEnvironment.values) {
      test('${environment.name} covers every movement type', () {
        final patterns = {
          for (final e in ExerciseCatalog.allowedFor(_settings(environment)))
            e.pattern,
        };
        expect(patterns, containsAll(MovementPattern.values));
      });

      test('${environment.name} still has a workout with every limitation', () {
        final allowed = ExerciseCatalog.allowedFor(
          _settings(environment, limitations: BodyLimitation.values.toSet()),
        );
        expect(allowed.length, greaterThanOrEqualTo(5));
        expect({
          for (final e in allowed) e.pattern,
        }, containsAll([MovementPattern.legs, MovementPattern.core]));
      });
    }
  });
}
