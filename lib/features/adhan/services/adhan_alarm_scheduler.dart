import 'package:adhan/adhan.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/service/location_service.dart';
import '../data/models/adhan_settings.dart';
import '../data/models/adhan_reciter.dart';

class AdhanAlarmScheduler {
  AdhanAlarmScheduler._();

  static final instance = AdhanAlarmScheduler._();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  static const _ids = <int>[
    7100,
    7101,
    7102,
    7103,
    7104,
    7105,
    7106,
    7107,
    7108,
    7109,
    7110,
    7111,
    7112,
    7113,
    7114,
    7115,
    7116,
    7117,
    7118,
    7119,
    7120,
    7121,
    7122,
    7123,
    7124,
    7125,
    7126,
    7127,
    7128,
    7129,
    7130,
    7131,
    7132,
    7133,
    7134,
    7135,
    7136,
    7137,
    7138,
    7139,
    7140,
    7141,
  ];

  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    const androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(settings);

    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    await _ensureInitialized();

    final android = _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final notificationsGranted =
        await android?.requestNotificationsPermission() ?? true;

    final exactAlarmsGranted =
        await android?.requestExactAlarmsPermission() ?? true;

    await _plugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return notificationsGranted && exactAlarmsGranted;
  }

  Future<void> cancelAll() async {
    await _ensureInitialized();

    for (final id in _ids) {
      await _plugin.cancel(id);
    }
  }

  Future<void> _createAdhanChannel({
    required AdhanReciter reciter,
  }) async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android == null) return;

    final channel = AndroidNotificationChannel(
      'adhan_${reciter.id}_v2',
      'أذان ${reciter.name}',
      description: 'تشغيل صوت الأذان عند دخول وقت الصلاة',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(reciter.rawSound),
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    await android.createNotificationChannel(channel);
  }

  Future<void> _createSunriseChannel() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android == null) return;

    const channel = AndroidNotificationChannel(
      'sunrise_channel_v2',
      'تنبيه الشروق',
      description: 'تنبيه عند وقت الشروق بدون تشغيل الأذان',
      importance: Importance.high,
      playSound: false,
    );

    await android.createNotificationChannel(channel);
  }

  Future<void> reschedule(AdhanSettings settings) async {
    await _ensureInitialized();

    // Always clear the complete 7-day Adhan window first.
    await cancelAll();

    if (!settings.enabled) return;

    final c = await LocationService.getCoordinates();
    final coords = Coordinates(c.lat, c.lng);

    final params = CalculationMethod.egyptian.getParameters()
      ..madhab = Madhab.shafi;

    final reciter = AdhanReciter.fromId(settings.reciter);

    // Create fresh channel IDs so an old Android channel configuration
    // cannot silently keep an outdated sound setting.
    await _createAdhanChannel(reciter: reciter);
    await _createSunriseChannel();

    var idIndex = 0;
    final now = DateTime.now();

    for (var d = 0; d < 7; d++) {
      if (idIndex >= _ids.length) break;

      final date = now.add(Duration(days: d));
      final prayerTimes = PrayerTimes(
        coords,
        DateComponents.from(date),
        params,
      );

      final entries =
      <({String key, String ar, DateTime time, bool enabled})>[
        (
        key: 'fajr',
        ar: 'الفجر',
        time: prayerTimes.fajr,
        enabled: settings.fajr,
        ),
        (
        key: 'sunrise',
        ar: 'الشروق',
        time: prayerTimes.sunrise,
        enabled: settings.sunrise,
        ),
        (
        key: 'dhuhr',
        ar: 'الظهر',
        time: prayerTimes.dhuhr,
        enabled: settings.dhuhr,
        ),
        (
        key: 'asr',
        ar: 'العصر',
        time: prayerTimes.asr,
        enabled: settings.asr,
        ),
        (
        key: 'maghrib',
        ar: 'المغرب',
        time: prayerTimes.maghrib,
        enabled: settings.maghrib,
        ),
        (
        key: 'isha',
        ar: 'العشاء',
        time: prayerTimes.isha,
        enabled: settings.isha,
        ),
      ];

      for (final entry in entries) {
        if (!entry.enabled) continue;
        if (entry.time.isBefore(now)) continue;
        if (idIndex >= _ids.length) break;

        final isSunrise = entry.key == 'sunrise';

        final details = NotificationDetails(
          android: AndroidNotificationDetails(
            isSunrise ? 'sunrise_channel_v2' : 'adhan_${reciter.id}_v2',
            isSunrise ? 'تنبيه الشروق' : 'أذان ${reciter.name}',
            channelDescription: isSunrise
                ? 'تنبيه عند وقت الشروق بدون تشغيل الأذان'
                : 'تشغيل صوت الأذان عند دخول وقت الصلاة',
            importance: Importance.max,
            priority: Priority.max,
            playSound: !isSunrise,
            sound: isSunrise
                ? null
                : RawResourceAndroidNotificationSound(reciter.rawSound),
            category: AndroidNotificationCategory.alarm,
            audioAttributesUsage: AudioAttributesUsage.alarm,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: !isSunrise,
          ),
        );

        await _plugin.zonedSchedule(
          _ids[idIndex++],
          isSunrise
              ? 'حان وقت الشروق ☀️'
              : 'حان الآن أذان ${entry.ar}',
          isSunrise
              ? 'أشرقت الشمس، نسأل الله لك يوماً مباركاً'
              : 'حي على الصلاة 🤍',
          tz.TZDateTime.from(entry.time, tz.local),
          details,
          androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle,
          payload: 'adhan:${entry.key}',
        );
      }
    }
  }
}
