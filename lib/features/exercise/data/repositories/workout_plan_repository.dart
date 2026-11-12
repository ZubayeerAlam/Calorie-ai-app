import '../../../../core/services/local_storage_service.dart';
import '../models/workout_plan.dart';

/// The current weekly plan (`workout_plan`). Only one plan is kept; a new
/// one replaces it. History keeps the plan id of each workout.
class WorkoutPlanRepository {
  WorkoutPlanRepository(this._storage);

  final LocalStorageService _storage;

  WorkoutPlan? read() =>
      _storage.readObject(StorageKeys.workoutPlan, WorkoutPlan.fromJson);

  Future<void> save(WorkoutPlan plan) =>
      _storage.setJson(StorageKeys.workoutPlan, plan.toJson());

  Future<void> clear() => _storage.remove(StorageKeys.workoutPlan);
}
