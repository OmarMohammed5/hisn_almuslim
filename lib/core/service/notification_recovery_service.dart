import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'notification_service.dart';
import 'wird_notification.dart';

@pragma('vm:entry-point')
Future<void> notificationRecoveryEntryPoint(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  tzdata.initializeTimeZones();
  final zoneName = args.isNotEmpty && args.first.isNotEmpty
      ? args.first
      : 'Africa/Cairo';

  try {
    tz.setLocalLocation(tz.getLocation(zoneName));
  } catch (_) {
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
  }

  try {
    await NotificationRecoveryService.recover(timezoneName: zoneName);
  } finally {
    try {
      await const MethodChannel(
        'hisn_almuslim/notification_recovery',
      ).invokeMethod<void>('done');
    } catch (_) {
      // Native receiver also has a timeout fallback.
    }
  }
}

class NotificationRecoveryService {
  NotificationRecoveryService._();

  static Future<void> recover({String? timezoneName}) async {
    final notifications = NotificationService.service;

    try {
      await notifications.init(timezoneName: timezoneName);

      final health = await notifications.health();
      if (!health.notificationsGranted || !health.exactAlarmGranted) {
        NotificationSchedulerLogger.info(
          'recovery skipped: notification/exact-alarm permission unavailable',
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();

      final morningEnabled = prefs.getBool('enable_morning') ?? false;
      final eveningEnabled = prefs.getBool('enable_evening') ?? false;
      final wirdEnabled = prefs.getBool('enable_wird') ?? false;
      final dhikrEnabled = prefs.getBool('enable_dhikr_reminder') ?? false;

      if (morningEnabled) {
        await notifications.scheduleMorning(
          TimeOfDay(
            hour: prefs.getInt('morning_hour') ?? 5,
            minute: prefs.getInt('morning_minute') ?? 30,
          ),
        );
      }

      if (eveningEnabled) {
        await notifications.scheduleEvening(
          TimeOfDay(
            hour: prefs.getInt('evening_hour') ?? 15,
            minute: prefs.getInt('evening_minute') ?? 30,
          ),
        );
      }

      if (wirdEnabled) {
        await DailyWirdNotificationService.schedule(
          TimeOfDay(
            hour: prefs.getInt('wird_hour') ?? 6,
            minute: prefs.getInt('wird_minute') ?? 0,
          ),
        );
      }

      if (dhikrEnabled) {
        final minutes = prefs.getInt('dhikr_reminder_minutes') ?? 5;
        await notifications.scheduleDhikrReminder(minutes);
      }

      NotificationSchedulerLogger.info(
        'headless notification recovery completed',
      );
    } catch (e, stack) {
      NotificationSchedulerLogger.error(
        type: 'headless_recovery',
        error: e,
        stackTrace: stack,
      );
    }
  }
}
