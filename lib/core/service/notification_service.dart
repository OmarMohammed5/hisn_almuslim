import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService service = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  // EXPOSE the plugin for use by other services
  FlutterLocalNotificationsPlugin get plugin => _plugin;

  /// Notification IDs used by this service.
  static const int morningNotificationId = 1;
  static const int eveningNotificationId = 2;
  static const int dhikrReminderNotificationId = 300;

  static const String _dhikrReminderChannelId = 'dhikr_reminder_channel_v2';
  static const String _dhikrReminderSound = 'dhikr_reminder';

  /// Initialize the notification service.
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

    // Request exact alarm permission on Android
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      await android.requestExactAlarmsPermission();
    }

    await _plugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // Create dhikr reminder channel explicitly
    await _createDhikrReminderChannel();
  }

  /// Create the dhikr reminder notification channel explicitly
  Future<void> _createDhikrReminderChannel() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android == null) return;

    const channel = AndroidNotificationChannel(
      _dhikrReminderChannelId,
      'الصلاة على النبي ﷺ',
      description: 'تذكير متكرر بالصلاة على النبي ﷺ',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(_dhikrReminderSound),
      audioAttributesUsage: AudioAttributesUsage.notification,
    );

    await android.createNotificationChannel(channel);
  }

  Future<bool> requestDhikrReminderPermissions() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final android = _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android == null) return true;

    // Request BOTH notification and exact alarm permissions
    final notificationGranted =
        await android.requestNotificationsPermission() ?? true;
    final exactAlarmsGranted =
        await android.requestExactAlarmsPermission() ?? true;

    return notificationGranted && exactAlarmsGranted;
  }

  /// Calculate the next daily occurrence for morning/evening notifications.
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

  /// Morning Azkar with custom time.
  Future<void> scheduleMorning(TimeOfDay time) async {
    await _plugin.zonedSchedule(
      morningNotificationId,
      'أذكار الصباح ☀️',
      'ابدأ يومك بذكر الله 🤍',
      _nextInstanceOfTime(time.hour, time.minute),
      const NotificationDetails(
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

  /// Evening Azkar with custom time.
  Future<void> scheduleEvening(TimeOfDay time) async {
    await _plugin.zonedSchedule(
      eveningNotificationId,
      'أذكار المساء 🌙',
      'اختم يومك بذكر الله 🤍',
      _nextInstanceOfTime(time.hour, time.minute),
      const NotificationDetails(
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

  Future<void> scheduleDhikrReminder(int minutes) async {
    const allowedIntervals = <int>{5, 10, 15, 30};

    if (!allowedIntervals.contains(minutes)) {
      throw ArgumentError('مدة التذكير غير مدعومة: $minutes دقيقة');
    }

    await cancelDhikrReminder();

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _dhikrReminderChannelId,
        'الصلاة على النبي ﷺ',
        channelDescription: 'تذكير متكرر بالصلاة على النبي ﷺ',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(_dhikrReminderSound),
        category: AndroidNotificationCategory.reminder,
        audioAttributesUsage: AudioAttributesUsage.notification,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // CHANGED: Use exactAndAllowWhileIdle instead of inexactAllowWhileIdle
    await _plugin.periodicallyShowWithDuration(
      dhikrReminderNotificationId,
      'صلِّ على النبي ﷺ 🤍',
      'اللهم صل وسلم وبارك على نبينا محمد ﷺ',
      Duration(minutes: minutes),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Show one immediate reminder so the user can confirm
  /// that notifications and the custom sound are working.
  Future<void> showDhikrReminderNow() async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _dhikrReminderChannelId,
        'الصلاة على النبي ﷺ',
        channelDescription: 'تذكير متكرر بالصلاة على النبي ﷺ',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(_dhikrReminderSound),
        category: AndroidNotificationCategory.reminder,
        audioAttributesUsage: AudioAttributesUsage.notification,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _plugin.show(
      dhikrReminderNotificationId + 1,
      'صلِّ على النبي ﷺ 🤍',
      'اللهم صل وسلم وبارك على نبينا محمد ﷺ',
      notificationDetails,
    );
  }

  /// Stop the recurring "الصلاة على النبي ﷺ" reminder only.
  Future<void> cancelDhikrReminder() async {
    await _plugin.cancel(dhikrReminderNotificationId);
  }

  /// Cancel a specific notification.
  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }

  /// Cancel all notifications managed by this service instance.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}