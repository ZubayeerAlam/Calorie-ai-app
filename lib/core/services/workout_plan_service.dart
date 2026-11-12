import '../../features/exercise/data/models/workout_plan.dart';
import '../../features/exercise/data/workout_plan_request.dart';

/// Why a plan couldn't be made.
enum WorkoutPlanFailure {
  /// No connection, or the service couldn't be reached.
  network,

  /// The AI replied, but not with a usable plan.
  invalidResponse,

  /// Anything else.
  unknown,
}

class WorkoutPlanException implements Exception {
  const WorkoutPlanException(this.failure, [this.message]);

  final WorkoutPlanFailure failure;
  final String? message;

  @override
  String toString() =>
      'WorkoutPlanException(${failure.name}${message == null ? '' : ': $message'})';
}

/// Makes a weekly workout plan for a profile and its Exercise settings.
///
/// Screens and providers use this interface only, so the AI behind it can
/// change without touching them. Implementations: `FirebaseWorkoutPlan
/// Service` (Gemini) and `RuleBasedWorkoutPlanService` (built-in rules,
/// works offline).
abstract class WorkoutPlanService {
  /// True when plans come from the AI.
  bool get usesAi;

  /// Throws [WorkoutPlanException] when no usable plan was made.
  Future<WorkoutPlan> generatePlan(WorkoutPlanRequest request);
}
