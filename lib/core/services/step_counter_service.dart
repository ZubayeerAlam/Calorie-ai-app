import 'dart:io' show Platform;

import 'package:pedometer/pedometer.dart';

import 'permission_service.dart';

/// Source of step counts. Both platforms report the steps taken since the
/// phone was last switched on (a running total, not per day).
abstract class StepCounterService {
  /// Asks for step access. False when denied or unsupported (e.g. desktop).
  Future<bool> requestAccess();

  /// Running total of steps since the device booted.
  Stream<int> get stepsSinceBoot;
}

/// Wraps the pedometer plugin so features don't depend on it directly.
class PedometerStepCounter implements StepCounterService {
  PedometerStepCounter(this._permissions);

  final PermissionService _permissions;

  @override
  Future<bool> requestAccess() async {
    try {
      if (Platform.isAndroid) {
        final result = await _permissions.requestActivityRecognition();
        return result == AppPermissionResult.granted;
      }
      // iOS shows its Motion prompt when steps are first read.
      return Platform.isIOS;
    } catch (_) {
      return false;
    }
  }

  @override
  Stream<int> get stepsSinceBoot =>
      Pedometer.stepCountStream.map((event) => event.steps);
}
