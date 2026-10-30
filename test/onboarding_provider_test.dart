import 'package:cal_ai_app/features/onboarding/providers/onboarding_provider.dart';
import 'package:cal_ai_app/features/profile/data/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

/// Moves a fresh provider to the goal step.
OnboardingProvider _atGoalStep() {
  final p = OnboardingProvider();
  p.setName('Sam');
  p.next();
  p.setGender(Gender.male);
  p.next();
  p.next(); // birthday
  p.next(); // height
  p.next(); // weight
  expect(p.step, OnboardingStep.goal);
  return p;
}

void main() {
  group('goal step', () {
    test('needs at least one goal of either kind', () {
      final p = _atGoalStep();
      expect(p.canContinue, isFalse);

      p.toggleFocus(GoalFocus.boostEnergy);
      expect(p.canContinue, isTrue);

      p.toggleFocus(GoalFocus.boostEnergy);
      expect(p.canContinue, isFalse);

      p.setGoal(GoalType.lose);
      expect(p.canContinue, isTrue);
    });

    test('weight goals exclude each other; tapping again clears', () {
      final p = _atGoalStep();
      p.setGoal(GoalType.lose);
      p.setGoal(GoalType.gain);
      expect(p.goal, GoalType.gain);
      p.setGoal(GoalType.gain);
      expect(p.goal, isNull);
    });

    test('focus goals combine and keep their order', () {
      final p = _atGoalStep();
      p.toggleFocus(GoalFocus.improveNutrition);
      p.toggleFocus(GoalFocus.gainMuscle);
      p.setGoal(GoalType.lose);
      expect(p.focuses, [GoalFocus.improveNutrition, GoalFocus.gainMuscle]);
      expect(p.goal, GoalType.lose);
    });

    test('only focus goals → calorie plan uses maintain', () {
      final p = _atGoalStep();
      p.toggleFocus(GoalFocus.gainMuscle);
      expect(p.effectiveGoal, GoalType.maintain);
      expect(p.weeklyChangeKg, 0);
    });
  });
}
