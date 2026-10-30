import 'dart:async';

import 'package:cal_ai_app/core/services/step_counter_service.dart';

/// Test double for the pedometer: push running totals with [emit].
class FakeStepCounter implements StepCounterService {
  FakeStepCounter({this.granted = true});

  final bool granted;
  final _controller = StreamController<int>.broadcast();

  void emit(int stepsSinceBoot) => _controller.add(stepsSinceBoot);

  @override
  Future<bool> requestAccess() async => granted;

  @override
  Stream<int> get stepsSinceBoot => _controller.stream;
}
