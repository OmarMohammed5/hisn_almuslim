import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService service = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// initialize the notification service
  Future<void> init() async {
    final status = await Permission.ignoreBatteryOptimizations.status;
    if (status.isDenied) {
      await Permission.ignoreBatteryOptimizations.request();
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(initSettings);

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  // //// Method to Calculate the time
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var target = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (target.isBefore(now)) {
      target = target.add(const Duration(days: 1));
    }
    return target;
  }

  // Morning Azkar with custom time
  Future<void> scheduleMorning(TimeOfDay time) async {
    await _plugin.zonedSchedule(
      1,
      "أذكار الصباح ☀️",
      "ابدأ يومك بذكر الله 🤍",
      _nextInstanceOfTime(time.hour, time.minute),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'morning_channel',
          'Morning Azkar',
          channelDescription: 'Daily morning azkar',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  // Evening Azkar with custom time
  Future<void> scheduleEvening(TimeOfDay time) async {
    await _plugin.zonedSchedule(
      2,
      "أذكار المساء 🌙",
      "اختم يومك بذكر الله 🤍",
      _nextInstanceOfTime(time.hour, time.minute),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'evening_channel',
          'Evening Azkar',
          channelDescription: 'Daily evening azkar',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  /// Cancel a notifiction
  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }

  /// Cancel All Notification
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
