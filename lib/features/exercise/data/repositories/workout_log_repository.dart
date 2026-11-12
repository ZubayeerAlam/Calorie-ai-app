import '../../../../core/services/local_storage_service.dart';
import '../../../../core/utils/date_utils.dart';
import '../models/workout_record.dart';

/// Workout history (`workout_sessions`): one record per workout, stored as
/// a list and saved by id (saving a record again updates it).
class WorkoutLogRepository {
  WorkoutLogRepository(this._storage);

  final LocalStorageService _storage;

  /// Every workout, oldest first.
  List<WorkoutRecord> all() =>
      _storage.readList(StorageKeys.workoutSessions, WorkoutRecord.fromJson)
        ..sort((a, b) => a.startedAt.compareTo(b.startedAt));

  /// Workouts started on [date], oldest first.
  List<WorkoutRecord> on(DateTime date) =>
      all().where((r) => AppDates.isSameDay(r.startedAt, date)).toList();

  WorkoutRecord? byId(String id) {
    for (final r in all()) {
      if (r.id == id) return r;
    }
    return null;
  }

  /// Adds [record], or replaces the saved record with the same id.
  Future<void> save(WorkoutRecord record) {
    final records = all();
    final i = records.indexWhere((r) => r.id == record.id);
    if (i < 0) {
      records.add(record);
    } else {
      records[i] = record;
    }
    return _write(records);
  }

  Future<void> remove(String id) =>
      _write(all()..removeWhere((r) => r.id == id));

  /// Estimated net kcal of the workouts on [date] (finished or not: every
  /// set done counts).
  double kcalOn(DateTime date) =>
      on(date).fold(0, (sum, r) => sum + r.estimatedKcal);

  Future<void> _write(List<WorkoutRecord> records) => _storage.setJsonList(
    StorageKeys.workoutSessions,
    [for (final r in records) r.toJson()],
  );
}
