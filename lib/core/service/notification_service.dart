import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService service = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get plugin => _plugin;

  static const int morningNotificationId = 1;
  static const int eveningNotificationId = 2;
  static const int dailyWirdNotificationId = 100;
  static const int dhikrReminderNotificationId = 300;
  static const int dhikrReminderImmediateNotificationId = 301;

  static const String _morningChannelId = 'morning_channel_v2';
  static const String _eveningChannelId = 'evening_channel_v2';
  static const String _wirdChannelId = 'daily_wird_channel_v2';
  static const String _dhikrReminderChannelId = 'dhikr_reminder_channel_v2';
  static const String _dhikrReminderSound = 'dhikr_reminder';

  bool _initialized = false;
  Future<void>? _initializationFuture;

  Future<void> init({String? timezoneName}) async {
    if (_initialized) return;

    final running = _initializationFuture;
    if (running != null) {
      await running;
      return;
    }

    final future = _initialize(timezoneName: timezoneName);
    _initializationFuture = future;

    try {
      await future;
    } catch (_) {
      // Allow a later app/recovery attempt to initialize again.
      if (identical(_initializationFuture, future)) {
        _initializationFuture = null;
      }
      rethrow;
    }
  }

  Future<void> _initialize({String? timezoneName}) async {
    tzdata.initializeTimeZones();

    var resolvedTimezone = timezoneName;
    if (resolvedTimezone == null || resolvedTimezone.isEmpty) {
      try {
        final info = await FlutterTimezone.getLocalTimezone();
        resolvedTimezone = info.identifier;
      } catch (e, stack) {
        NotificationSchedulerLogger.error(
          type: 'timezone',
          error: e,
          stackTrace: stack,
        );
      }
    }

    resolvedTimezone ??= 'Africa/Cairo';

    try {
      tz.setLocalLocation(tz.getLocation(resolvedTimezone));
    } catch (e, stack) {
      NotificationSchedulerLogger.error(
        type: 'timezone',
        error: e,
        stackTrace: stack,
      );
      tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(initSettings);
    await _createChannels();

    _initialized = true;

    NotificationSchedulerLogger.info(
      'initialized timezone=${tz.local.name}',
    );
  }

  Future<void> _createChannels() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        _morningChannelId,
        'أذكار الصباح',
        description: 'تنبيه يومي لأذكار الصباح',
        importance: Importance.max,
        playSound: true,
      ),
    );

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        _eveningChannelId,
        'أذكار المساء',
        description: 'تنبيه يومي لأذكار المساء',
        importance: Importance.max,
        playSound: true,
      ),
    );

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        _wirdChannelId,
        'الورد اليومي',
        description: 'تنبيه يومي للورد اليومي',
        importance: Importance.max,
        playSound: true,
      ),
    );

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        _dhikrReminderChannelId,
        'الصلاة على النبي ﷺ',
        description: 'تذكير متكرر بالصلاة على النبي ﷺ',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(_dhikrReminderSound),
        audioAttributesUsage: AudioAttributesUsage.notification,
      ),
    );
  }

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  Future<bool> requestNotificationPermission() async {
    final android = _android;
    if (android == null) return true;

    final result = await android.requestNotificationsPermission();
    final granted = result ?? false;

    NotificationSchedulerLogger.permission(
      permission: 'POST_NOTIFICATIONS',
      granted: granted,
    );

    return granted;
  }

  Future<bool> requestExactAlarmPermission() async {
    final android = _android;
    if (android == null) return true;

    final result = await android.requestExactAlarmsPermission();
    final granted = result ?? false;

    NotificationSchedulerLogger.permission(
      permission: 'SCHEDULE_EXACT_ALARM',
      granted: granted,
    );

    return granted;
  }

  Future<NotificationHealth> health() async {
    await init();

    final android = _android;
    if (android == null) {
      return const NotificationHealth(
        notificationsGranted: true,
        exactAlarmGranted: true,
        pendingCount: 0,
      );
    }

    final notificationsGranted =
        await android.areNotificationsEnabled() ?? false;
    final exactAlarmGranted =
        await android.canScheduleExactNotifications() ?? false;
    final pending = await _plugin.pendingNotificationRequests();

    return NotificationHealth(
      notificationsGranted: notificationsGranted,
      exactAlarmGranted: exactAlarmGranted,
      pendingCount: pending.length,
    );
  }

  Future<bool> requestDhikrReminderPermissions() async {
    final notificationsGranted = await requestNotificationPermission();
    if (!notificationsGranted) return false;
    return requestExactAlarmPermission();
  }

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

    if (!target.isAfter(now)) {
      target = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + 1,
        hour,
        minute,
      );
    }

    return target;
  }

  Future<void> scheduleMorning(TimeOfDay time) async {
    await init();
    await _scheduleDaily(
      id: morningNotificationId,
      channelId: _morningChannelId,
      channelName: 'أذكار الصباح',
      title: 'أذكار الصباح ☀️',
      body: 'ابدأ يومك بذكر الله 🤍',
      time: time,
      payload: 'morning_azkar',
    );
  }

  Future<void> scheduleEvening(TimeOfDay time) async {
    await init();
    await _scheduleDaily(
      id: eveningNotificationId,
      channelId: _eveningChannelId,
      channelName: 'أذكار المساء',
      title: 'أذكار المساء 🌙',
      body: 'اختم يومك بذكر الله 🤍',
      time: time,
      payload: 'evening_azkar',
    );
  }

  Future<void> _scheduleDaily({
    required int id,
    required String channelId,
    required String channelName,
    required String title,
    required String body,
    required TimeOfDay time,
    required String payload,
  }) async {
    // Replace the old alarm first. This makes the operation idempotent and
    // prevents stale schedules from surviving a time change.
    await _plugin.cancel(id);

    final scheduled = _nextInstanceOfTime(time.hour, time.minute);

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: 'تنبيه يومي',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );

      NotificationSchedulerLogger.scheduled(
        type: payload,
        id: id,
        scheduledDate: scheduled,
        timezone: tz.local.name,
      );
    } catch (e, stack) {
      NotificationSchedulerLogger.error(
        type: payload,
        id: id,
        scheduledDate: scheduled,
        timezone: tz.local.name,
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Future<void> scheduleDhikrReminder(int minutes) async {
    await init();

    const allowedIntervals = <int>{5, 10, 15, 30};
    if (!allowedIntervals.contains(minutes)) {
      throw ArgumentError('مدة التذكير غير مدعومة: $minutes دقيقة');
    }

    await _plugin.cancel(dhikrReminderNotificationId);

    const details = NotificationDetails(
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

    try {
      await _plugin.periodicallyShowWithDuration(
        dhikrReminderNotificationId,
        'صلِّ على النبي ﷺ 🤍',
        'اللهم صل وسلم وبارك على نبينا محمد ﷺ',
        Duration(minutes: minutes),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'dhikr_reminder:$minutes',
      );

      NotificationSchedulerLogger.scheduled(
        type: 'dhikr_reminder',
        id: dhikrReminderNotificationId,
        scheduledDate: tz.TZDateTime.now(tz.local).add(
          Duration(minutes: minutes),
        ),
        timezone: tz.local.name,
      );
    } catch (e, stack) {
      NotificationSchedulerLogger.error(
        type: 'dhikr_reminder',
        id: dhikrReminderNotificationId,
        timezone: tz.local.name,
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Future<void> showDhikrReminderNow() async {
    await init();

    const details = NotificationDetails(
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
      dhikrReminderImmediateNotificationId,
      'صلِّ على النبي ﷺ 🤍',
      'اللهم صل وسلم وبارك على نبينا محمد ﷺ',
      details,
    );
  }

  Future<List<PendingNotificationRequest>> pendingRequests() async {
    await init();
    return _plugin.pendingNotificationRequests();
  }

  Future<void> cancelDhikrReminder() async {
    await init();
    await _plugin.cancel(dhikrReminderNotificationId);
  }

  Future<void> cancel(int id) async {
    await init();
    await _plugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }
}

class NotificationHealth {
  final bool notificationsGranted;
  final bool exactAlarmGranted;
  final int pendingCount;

  const NotificationHealth({
    required this.notificationsGranted,
    required this.exactAlarmGranted,
    required this.pendingCount,
  });

  bool get readyForExactScheduling =>
      notificationsGranted && exactAlarmGranted;
}

class NotificationSchedulerLogger {
  static void info(String message) {
    debugPrint('[NotificationScheduler] $message');
  }

  static void permission({
    required String permission,
    required bool granted,
  }) {
    debugPrint(
      '[NotificationScheduler] permission=$permission granted=$granted',
    );
  }

  static void scheduled({
    required String type,
    required int id,
    required DateTime scheduledDate,
    required String timezone,
  }) {
    debugPrint(
      '[NotificationScheduler] scheduled '
      'type=$type id=$id date=$scheduledDate timezone=$timezone',
    );
  }

  static void error({
    required String type,
    int? id,
    DateTime? scheduledDate,
    String? timezone,
    required Object error,
    required StackTrace stackTrace,
  }) {
    debugPrint(
      '[NotificationScheduler] FAILED '
      'type=$type id=$id date=$scheduledDate timezone=$timezone '
      'error=$error\n$stackTrace',
    );
  }
}
