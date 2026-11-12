import 'package:cal_ai_app/core/services/health_service.dart';
import 'package:cal_ai_app/core/utils/date_utils.dart';

/// Test double for Apple Health / Health Connect: steps and workouts per
/// day, keyed `yyyy-mm-dd`.
class FakeHealthService implements HealthService {
  FakeHealthService({
    this.availabilityResult = HealthAvailability.available,
    this.granted = true,
    Map<String, int>? steps,
    Map<String, int>? workoutKcal,
    Map<String, List<HealthWorkout>>? workouts,
  }) : steps = steps ?? {},
       workoutKcal = workoutKcal ?? {},
       workouts = workouts ?? {};

  HealthAvailability availabilityResult;
  bool granted;
  final Map<String, int> steps;

  /// A day's workout kcal, as one workout from 12:00 to 12:45.
  final Map<String, int> workoutKcal;

  /// A day's workouts with their times (used instead of [workoutKcal]).
  final Map<String, List<HealthWorkout>> workouts;
  int accessRequests = 0;

  @override
  String get name => 'Health Connect';

  @override
  Future<HealthAvailability> availability() async => availabilityResult;

  @override
  Future<bool> requestAccess() async {
    accessRequests++;
    return granted;
  }

  @override
  Future<int?> stepsBetween(DateTime start, DateTime end) async =>
      steps[AppDates.key(start)];

  @override
  Future<List<HealthWorkout>> workoutsBetween(
    DateTime start,
    DateTime end,
  ) async {
    final day = AppDates.key(start);
    if (workouts[day] case final list?) return list;
    final kcal = workoutKcal[day];
    if (kcal == null) return const [];
    final noon = DateTime(start.year, start.month, start.day, 12);
    return [
      HealthWorkout(
        start: noon,
        end: noon.add(const Duration(minutes: 45)),
        kcal: kcal,
      ),
    ];
  }

  @override
  Future<void> install() async {}
}
