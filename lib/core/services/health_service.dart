import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

enum HealthAvailability {
  available,

  /// Android without the Health Connect app (or an outdated one).
  needsInstall,

  /// No health platform here (e.g. tests, desktop, web).
  unsupported,
}

/// Steps and workouts from Apple Health (iOS) or Health Connect (Android).
abstract class HealthService {
  /// Shown to the user, e.g. "Apple Health".
  String get name;

  Future<HealthAvailability> availability();

  /// Asks to read steps and workouts. True when allowed (iOS never says
  /// whether reading was refused, so there it's true once asked).
  Future<bool> requestAccess();

  /// Total steps between [start] and [end], or null when unknown.
  Future<int?> stepsBetween(DateTime start, DateTime end);

  /// Calories burned in workouts that started between [start] and [end].
  Future<int> workoutKcalBetween(DateTime start, DateTime end);

  /// Opens the store page for Health Connect (Android only).
  Future<void> install();
}

/// Used where there is no health platform, and by default in tests.
class UnavailableHealthService implements HealthService {
  const UnavailableHealthService();

  @override
  String get name => 'Health';

  @override
  Future<HealthAvailability> availability() async =>
      HealthAvailability.unsupported;

  @override
  Future<bool> requestAccess() async => false;

  @override
  Future<int?> stepsBetween(DateTime start, DateTime end) async => null;

  @override
  Future<int> workoutKcalBetween(DateTime start, DateTime end) async => 0;

  @override
  Future<void> install() async {}
}

/// Wraps the health plugin so features don't depend on it directly.
class HealthPluginService implements HealthService {
  HealthPluginService();

  final Health _health = Health();
  bool _configured = false;

  List<HealthDataType> get _types => [
    HealthDataType.STEPS,
    HealthDataType.WORKOUT,
    // Android reads a workout's calories from its calorie records.
    if (Platform.isAndroid) HealthDataType.TOTAL_CALORIES_BURNED,
  ];

  Future<void> _configure() async {
    if (_configured) return;
    await _health.configure();
    _configured = true;
  }

  @override
  String get name => Platform.isIOS ? 'Apple Health' : 'Health Connect';

  @override
  Future<HealthAvailability> availability() async {
    try {
      if (Platform.isIOS) return HealthAvailability.available;
      if (!Platform.isAndroid) return HealthAvailability.unsupported;
      await _configure();
      return switch (await _health.getHealthConnectSdkStatus()) {
        HealthConnectSdkStatus.sdkAvailable => HealthAvailability.available,
        HealthConnectSdkStatus.sdkUnavailableProviderUpdateRequired =>
          HealthAvailability.needsInstall,
        _ => HealthAvailability.unsupported,
      };
    } catch (e) {
      debugPrint('Health availability failed: $e');
      return HealthAvailability.unsupported;
    }
  }

  @override
  Future<bool> requestAccess() async {
    try {
      await _configure();
      return await _health.requestAuthorization(_types);
    } catch (e) {
      debugPrint('Health access failed: $e');
      return false;
    }
  }

  @override
  Future<int?> stepsBetween(DateTime start, DateTime end) async {
    try {
      await _configure();
      return await _health.getTotalStepsInInterval(start, end);
    } catch (e) {
      debugPrint('Health steps failed: $e');
      return null;
    }
  }

  @override
  Future<int> workoutKcalBetween(DateTime start, DateTime end) async {
    try {
      await _configure();
      final points = await _health.getHealthDataFromTypes(
        types: [HealthDataType.WORKOUT],
        startTime: start,
        endTime: end,
      );
      var kcal = 0;
      for (final point in points) {
        final value = point.value;
        if (value is WorkoutHealthValue) kcal += value.totalEnergyBurned ?? 0;
      }
      return kcal;
    } catch (e) {
      debugPrint('Health workouts failed: $e');
      return 0;
    }
  }

  @override
  Future<void> install() => _health.installHealthConnect();
}
