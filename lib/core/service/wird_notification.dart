import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'notification_service.dart';

class DailyWirdNotificationService {
  DailyWirdNotificationService._();

  static const int notificationId = NotificationService.dailyWirdNotificationId;
  static const String channelId = 'daily_wird_channel_v2';

  static NotificationDetails _details() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        'الورد اليومي',
        channelDescription: 'تنبيه يومي للورد اليومي',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  static Future<void> schedule(TimeOfDay time) async {
    final service = NotificationService.service;
    await service.init();

    final plugin = service.plugin;

    // Make time changes idempotent: there must be exactly one daily alarm
    // for this feature.
    await plugin.cancel(notificationId);

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (!scheduledDate.isAfter(now)) {
      scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + 1,
        time.hour,
        time.minute,
      );
    }

    try {
      await plugin.zonedSchedule(
        notificationId,
        'الورد اليومي 📖',
        'لا تنسى قراءة وردك اليومي',
        scheduledDate,
        _details(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'daily_wird',
      );

      NotificationSchedulerLogger.scheduled(
        type: 'daily_wird',
        id: notificationId,
        scheduledDate: scheduledDate,
        timezone: tz.local.name,
      );
    } catch (e, stack) {
      NotificationSchedulerLogger.error(
        type: 'daily_wird',
        id: notificationId,
        scheduledDate: scheduledDate,
        timezone: tz.local.name,
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  static Future<void> cancel() async {
    await NotificationService.service.cancel(notificationId);
  }
}
