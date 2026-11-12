import '../../../../core/services/local_storage_service.dart';
import '../models/exercise_settings.dart';

/// The Exercise setup choices (`exercise_settings`). Null until the user
/// has picked Home or Gym.
class ExerciseSettingsRepository {
  ExerciseSettingsRepository(this._storage);

  final LocalStorageService _storage;

  ExerciseSettings? read() => _storage.readObject(
    StorageKeys.exerciseSettings,
    ExerciseSettings.fromJson,
  );

  Future<void> save(ExerciseSettings settings) =>
      _storage.setJson(StorageKeys.exerciseSettings, settings.toJson());
}
