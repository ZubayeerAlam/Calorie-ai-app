import 'package:cal_ai_app/core/services/notification_service.dart';
import 'package:flutter/foundation.dart';

/// Test double for local notifications: keeps what is scheduled by id.
class FakeNotificationService implements NotificationService {
  FakeNotificationService({this.granted = true});

  bool granted;
  final Map<int, ({DateTime at, String title, String? payload})> scheduled = {};
  ValueChanged<String>? tapHandler;

  @override
  Future<bool> requestPermission() async => granted;

  @override
  Future<void> schedule({
    required int id,
    required DateTime at,
    required String title,
    required String body,
    String? payload,
  }) async => scheduled[id] = (at: at, title: title, payload: payload);

  @override
  Future<void> cancel(int id) async => scheduled.remove(id);

  @override
  set onTap(ValueChanged<String>? handler) => tapHandler = handler;

  /// Payloads of what's scheduled for [meal] ("breakfast", ...).
  List<DateTime> timesFor(String meal) => [
    for (final n in scheduled.values)
      if (n.payload == meal) n.at,
  ]..sort();
}
