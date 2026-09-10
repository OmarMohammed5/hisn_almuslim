import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_health_checker.dart';
import 'notification_service.dart';
import 'wird_notification.dart';

/// Single application-level scheduling facade.
///
/// Feature Cubits should call this facade instead of constructing or
/// initializing FlutterLocalNotificationsPlugin themselves.
class NotificationScheduler {
  NotificationScheduler._();

  static final instance = NotificationScheduler._();

  final NotificationService _service = NotificationService.service;

  Future<void> initialize() => _service.init();

  Future<NotificationHealth> health() {
    return NotificationHealthChecker.instance.check();
  }

  Future<void> scheduleMorning(TimeOfDay time) {
    return _service.scheduleMorning(time);
  }

  Future<void> scheduleEvening(TimeOfDay time) {
    return _service.scheduleEvening(time);
  }

  Future<void> scheduleDailyWird(TimeOfDay time) {
    return DailyWirdNotificationService.schedule(time);
  }

  Future<void> scheduleDhikrReminder(int minutes) {
    return _service.scheduleDhikrReminder(minutes);
  }

  Future<void> cancel(int id) => _service.cancel(id);

  Future<void> cancelDailyWird() => DailyWirdNotificationService.cancel();

  Future<void> cancelDhikrReminder() => _service.cancelDhikrReminder();

  Future<List<PendingNotificationRequest>> pendingRequests() => _service.pendingRequests();
}
