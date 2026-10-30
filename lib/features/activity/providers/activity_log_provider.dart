import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/services/step_counter_service.dart';
import '../../../core/utils/calorie_calculator.dart';
import '../data/activity_log_repository.dart';
import '../data/step_log_repository.dart';

enum StepTrackingStatus { off, tracking, denied, unavailable }

/// Burned calories: activity logged by hand plus walking from steps.
class ActivityLogProvider extends ChangeNotifier {
  ActivityLogProvider(this._repository, this._steps, this._stepCounter);

  final ActivityLogRepository _repository;
  final StepLogRepository _steps;
  final StepCounterService _stepCounter;

  StreamSubscription<int>? _subscription;
  StepTrackingStatus _status = StepTrackingStatus.off;

  StepTrackingStatus get stepStatus => _status;

  /// Activity kcal logged for [date].
  int burnedOn(DateTime date) => _repository.burnedOn(date);

  int stepsOn(DateTime date) => _steps.stepsOn(date);

  /// Walking kcal for [date] from its saved steps and the user's weight.
  int walkingOn(DateTime date, {required double weightKg}) =>
      CalorieCalculator.walkingKcal(stepsOn(date), weightKg);

  int totalBurnedOn(DateTime date, {required double weightKg}) =>
      burnedOn(date) + walkingOn(date, weightKg: weightKg);

  Future<void> setBurned(DateTime date, int kcal) async {
    await _repository.setBurned(date, kcal);
    notifyListeners();
  }

  /// Asks for step access once and starts listening. Safe to call again.
  Future<void> startStepTracking() async {
    if (_status != StepTrackingStatus.off) return;
    _status = StepTrackingStatus.tracking; // claim before awaiting
    if (!await _stepCounter.requestAccess()) {
      _setStatus(StepTrackingStatus.denied);
      return;
    }
    _subscription = _stepCounter.stepsSinceBoot.listen(
      (total) async {
        await _steps.record(total, DateTime.now());
        notifyListeners();
      },
      // No step sensor, or Motion access refused on iOS.
      onError: (_) => _setStatus(StepTrackingStatus.unavailable),
      cancelOnError: true,
    );
  }

  void _setStatus(StepTrackingStatus status) {
    _status = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
