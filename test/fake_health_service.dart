import 'package:cal_ai_app/core/services/health_service.dart';
import 'package:cal_ai_app/core/utils/date_utils.dart';

/// Test double for Apple Health / Health Connect: steps and workout kcal
/// per day, keyed `yyyy-mm-dd`.
class FakeHealthService implements HealthService {
  FakeHealthService({
    this.availabilityResult = HealthAvailability.available,
    this.granted = true,
    Map<String, int>? steps,
    Map<String, int>? workoutKcal,
  }) : steps = steps ?? {},
       workoutKcal = workoutKcal ?? {};

  HealthAvailability availabilityResult;
  bool granted;
  final Map<String, int> steps;
  final Map<String, int> workoutKcal;
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
  Future<int> workoutKcalBetween(DateTime start, DateTime end) async =>
      workoutKcal[AppDates.key(start)] ?? 0;

  @override
  Future<void> install() async {}
}
