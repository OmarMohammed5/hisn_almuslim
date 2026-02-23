import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class DailyWirdNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const int _notificationId = 500;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'daily_wird_channel',
    'الورد اليومي',
    description: 'تنبيهات خاصة بالورد اليومي',
    importance: Importance.high,
  );

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await _notifications.initialize(settings);

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  static NotificationDetails _details() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_wird_channel',
        'الورد اليومي',
        channelDescription: 'تنبيهات خاصة بالورد اليومي',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
  }

  static Future<void> schedule(TimeOfDay time) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      _notificationId,
      "الورد اليومي 📖",
      "لا تنسى قراءة وردك اليومي",
      scheduledDate,
      _details(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancel() async {
    await _notifications.cancel(_notificationId);
  }
}
