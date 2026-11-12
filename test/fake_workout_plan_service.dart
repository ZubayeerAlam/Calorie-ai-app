import 'dart:async';

import 'package:cal_ai_app/core/services/rule_based_workout_plan_service.dart';
import 'package:cal_ai_app/core/services/workout_plan_service.dart';
import 'package:cal_ai_app/features/exercise/data/models/workout_plan.dart';
import 'package:cal_ai_app/features/exercise/data/workout_plan_request.dart';

/// Stands in for the Gemini planner: returns the rule-based plan marked as
/// AI (summary "AI plan"), or fails with [failure]. With [hold] it waits
/// until [release] is called, to see the loading state.
class FakeWorkoutPlanService implements WorkoutPlanService {
  FakeWorkoutPlanService({this.failure, this.hold = false});

  WorkoutPlanFailure? failure;
  bool hold;
  int calls = 0;
  WorkoutPlanRequest? lastRequest;
  Completer<void>? _gate;

  @override
  bool get usesAi => true;

  void release() => _gate?.complete();

  @override
  Future<WorkoutPlan> generatePlan(WorkoutPlanRequest request) async {
    calls++;
    lastRequest = request;
    if (hold) {
      _gate = Completer<void>();
      await _gate!.future;
    }
    final failure = this.failure;
    if (failure != null) throw WorkoutPlanException(failure);
    final json = RuleBasedWorkoutPlanService.build(request).toJson()
      ..['source'] = PlanSource.ai.name
      ..['summary'] = 'AI plan'
      ..['id'] = 'ai-$calls';
    return WorkoutPlan.fromJson(json);
  }
}
