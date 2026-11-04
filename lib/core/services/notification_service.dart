import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../l10n/l10n.dart';

/// Local notifications on the phone (meal reminders).
abstract class NotificationService {
  /// Asks to show notifications. True when allowed.
  Future<bool> requestPermission();

  /// Shows a notification at [at] (local time). Scheduling the same [id]
  /// again replaces it. [payload] comes back through [onTap].
  Future<void> schedule({
    required int id,
    required DateTime at,
    required String title,
    required String body,
    String? payload,
  });

  Future<void> cancel(int id);

  /// Called with a notification's payload when the user taps it.
  set onTap(ValueChanged<String>? handler);
}

/// No notifications; the default until `main` passes the real one (tests).
class UnavailableNotificationService implements NotificationService {
  const UnavailableNotificationService();

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> schedule({
    required int id,
    required DateTime at,
    required String title,
    required String body,
    String? payload,
  }) async {}

  @override
  Future<void> cancel(int id) async {}

  @override
  set onTap(ValueChanged<String>? handler) {}
}

/// Wraps flutter_local_notifications so features don't depend on it.
class LocalNotificationService implements NotificationService {
  LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  ValueChanged<String>? _onTap;

  /// Payload of the notification that opened the app, handed to [onTap]
  /// once a handler is set.
  String? _launchPayload;

  // The channel's name shows in the phone's notification settings.
  static AndroidNotificationDetails get _android => AndroidNotificationDetails(
    'meal_reminders',
    l10n.mealReminders,
    channelDescription: l10n.mealRemindersChannelDesc,
    importance: Importance.high,
    priority: Priority.high,
  );

  /// Sets up time zones and the plugin. Never throws: on failure the app
  /// just has no reminders.
  static Future<LocalNotificationService> init() async {
    final service = LocalNotificationService._();
    try {
      tz_data.initializeTimeZones();
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
      await service._plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          // Permission is asked when a reminder is turned on, not at start.
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: (response) {
          final payload = response.payload;
          if (payload != null) service._onTap?.call(payload);
        },
      );
      final launch = await service._plugin.getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp ?? false) {
        service._launchPayload = launch!.notificationResponse?.payload;
      }
    } catch (e) {
      debugPrint('Notifications unavailable: $e');
    }
    return service;
  }

  @override
  set onTap(ValueChanged<String>? handler) {
    _onTap = handler;
    final payload = _launchPayload;
    if (handler != null && payload != null) {
      _launchPayload = null;
      handler(payload);
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (android != null) {
        return await android.requestNotificationsPermission() ?? false;
      }
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await ios?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    } catch (e) {
      debugPrint('Notification permission failed: $e');
      return false;
    }
  }

  @override
  Future<void> schedule({
    required int id,
    required DateTime at,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        payload: payload,
        scheduledDate: tz.TZDateTime.from(at, tz.local),
        notificationDetails: NotificationDetails(
          android: _android,
          iOS: const DarwinNotificationDetails(),
        ),
        // Inexact: needs no "alarms & reminders" permission; reminders may
        // arrive a few minutes late, which is fine for meals.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('Scheduling reminder $id failed: $e');
    }
  }

  @override
  Future<void> cancel(int id) async {
    try {
      await _plugin.cancel(id: id);
    } catch (e) {
      debugPrint('Cancelling reminder $id failed: $e');
    }
  }
}
