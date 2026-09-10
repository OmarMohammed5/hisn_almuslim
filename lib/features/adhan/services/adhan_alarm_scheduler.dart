// import 'package:adhan/adhan.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// import '../../../../core/service/location_service.dart';
// import '../../../../core/service/notification_service.dart';
// import '../data/models/adhan_settings.dart';
// import '../data/models/adhan_reciter.dart';
//
// class AdhanAlarmScheduler {
//   AdhanAlarmScheduler._();
//
//   static final instance = AdhanAlarmScheduler._();
//
//   Future<void> _queue = Future<void>.value();
//
//   FlutterLocalNotificationsPlugin get _plugin =>
//       NotificationService.service.plugin;
//
//   // Keep a 60-day rolling window so Adhan survives long periods without
//   // opening the app. With six entries/day this is at most 360 alarms,
//   // intentionally kept below Samsung's documented 500-alarm ceiling.
//   static const int _scheduleDays = 60;
//   static const int _entriesPerDay = 6;
//   static const int _baseNotificationId = 7100;
//
//   int _notificationId(int dayIndex, int prayerIndex) =>
//       _baseNotificationId + (dayIndex * 10) + prayerIndex;
//
//   Future<bool> requestPermissions() async {
//     final notificationsGranted = await NotificationService.service
//         .requestNotificationPermission();
//     if (!notificationsGranted) return false;
//
//     return NotificationService.service.requestExactAlarmPermission();
//   }
//
//   Future<void> cancelAll() async {
//     for (var day = 0; day < _scheduleDays; day++) {
//       for (var prayer = 0; prayer < _entriesPerDay; prayer++) {
//         await _plugin.cancel(_notificationId(day, prayer));
//       }
//     }
//   }
//
//   Future<void> _createAdhanChannel({required AdhanReciter reciter}) async {
//     final android = _plugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >();
//     if (android == null) return;
//
//     await android.createNotificationChannel(
//       AndroidNotificationChannel(
//         'adhan_${reciter.id}_v3',
//         'أذان ${reciter.name}',
//         description: 'تشغيل صوت الأذان عند دخول وقت الصلاة',
//         importance: Importance.max,
//         playSound: true,
//         sound: RawResourceAndroidNotificationSound(reciter.rawSound),
//         audioAttributesUsage: AudioAttributesUsage.alarm,
//       ),
//     );
//   }
//
//   Future<void> _createSunriseChannel() async {
//     final android = _plugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >();
//     if (android == null) return;
//
//     await android.createNotificationChannel(
//       const AndroidNotificationChannel(
//         'sunrise_channel_v3',
//         'تنبيه الشروق',
//         description: 'تنبيه عند وقت الشروق بدون تشغيل الأذان',
//         importance: Importance.high,
//         playSound: false,
//       ),
//     );
//   }
//
//   Future<void> reschedule(
//     AdhanSettings settings, {
//     bool refreshLocation = true,
//   }) {
//     final operation = _queue.then(
//       (_) => _rescheduleInternal(settings, refreshLocation: refreshLocation),
//     );
//     _queue = operation.catchError((_) {});
//     return operation;
//   }
//
//   Future<void> _rescheduleInternal(
//     AdhanSettings settings, {
//     required bool refreshLocation,
//   }) async {
//     await cancelAll();
//
//     if (!settings.enabled) {
//       NotificationSchedulerLogger.info('adhan scheduling disabled');
//       return;
//     }
//
//     final health = await NotificationService.service.health();
//     if (!health.readyForExactScheduling) {
//       throw StateError(
//         'Adhan requires POST_NOTIFICATIONS and SCHEDULE_EXACT_ALARM',
//       );
//     }
//
//     final c = refreshLocation
//         ? await LocationService.getCoordinates()
//         : await LocationService.getCachedCoordinates();
//
//     if (c == null) {
//       throw StateError(
//         'No cached location is available for background Adhan recovery',
//       );
//     }
//
//     final coords = Coordinates(c.lat, c.lng);
//     final params = CalculationMethod.egyptian.getParameters()
//       ..madhab = Madhab.shafi;
//     final reciter = AdhanReciter.fromId(settings.reciter);
//
//     await _createAdhanChannel(reciter: reciter);
//     await _createSunriseChannel();
//
//     final now = tz.TZDateTime.now(tz.local);
//     final firstDate = DateTime(now.year, now.month, now.day);
//
//     var scheduledCount = 0;
//
//     for (var day = 0; day < _scheduleDays; day++) {
//       final date = firstDate.add(Duration(days: day));
//       final prayerTimes = PrayerTimes(
//         coords,
//         DateComponents.from(date),
//         params,
//       );
//
//       final entries =
//           <({String key, String ar, DateTime time, bool enabled})>[
//         (
//           key: 'fajr',
//           ar: 'الفجر',
//           time: prayerTimes.fajr,
//           enabled: settings.fajr,
//         ),
//         (
//           key: 'sunrise',
//           ar: 'الشروق',
//           time: prayerTimes.sunrise,
//           enabled: settings.sunrise,
//         ),
//         (
//           key: 'dhuhr',
//           ar: 'الظهر',
//           time: prayerTimes.dhuhr,
//           enabled: settings.dhuhr,
//         ),
//         (
//           key: 'asr',
//           ar: 'العصر',
//           time: prayerTimes.asr,
//           enabled: settings.asr,
//         ),
//         (
//           key: 'maghrib',
//           ar: 'المغرب',
//           time: prayerTimes.maghrib,
//           enabled: settings.maghrib,
//         ),
//         (
//           key: 'isha',
//           ar: 'العشاء',
//           time: prayerTimes.isha,
//           enabled: settings.isha,
//         ),
//       ];
//
//       for (var prayerIndex = 0;
//           prayerIndex < entries.length;
//           prayerIndex++) {
//         final entry = entries[prayerIndex];
//         if (!entry.enabled) continue;
//
//         final scheduled = tz.TZDateTime.from(entry.time, tz.local);
//         if (!scheduled.isAfter(now)) continue;
//
//         final isSunrise = entry.key == 'sunrise';
//         final details = NotificationDetails(
//           android: AndroidNotificationDetails(
//             isSunrise ? 'sunrise_channel_v3' : 'adhan_${reciter.id}_v3',
//             isSunrise ? 'تنبيه الشروق' : 'أذان ${reciter.name}',
//             channelDescription: isSunrise
//                 ? 'تنبيه عند وقت الشروق'
//                 : 'تشغيل صوت الأذان عند دخول وقت الصلاة',
//             importance: Importance.max,
//             priority: Priority.max,
//             playSound: !isSunrise,
//             sound: isSunrise
//                 ? null
//                 : RawResourceAndroidNotificationSound(reciter.rawSound),
//             category: AndroidNotificationCategory.alarm,
//             audioAttributesUsage: AudioAttributesUsage.alarm,
//           ),
//           iOS: DarwinNotificationDetails(
//             presentAlert: true,
//             presentBadge: true,
//             presentSound: !isSunrise,
//           ),
//         );
//
//         try {
//           await _plugin.zonedSchedule(
//             _notificationId(day, prayerIndex),
//             isSunrise ? 'حان وقت الشروق ☀️' : 'حان الآن أذان ${entry.ar}',
//             isSunrise
//                 ? 'أشرقت الشمس، نسأل الله لك يوماً مباركاً'
//                 : 'حي على الصلاة 🤍',
//             scheduled,
//             details,
//             androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//             payload: 'adhan:${entry.key}',
//           );
//
//           scheduledCount++;
//           NotificationSchedulerLogger.scheduled(
//             type: isSunrise ? 'sunrise' : 'adhan:${entry.key}',
//             id: _notificationId(day, prayerIndex),
//             scheduledDate: scheduled,
//             timezone: tz.local.name,
//           );
//         } catch (e, stack) {
//           NotificationSchedulerLogger.error(
//             type: isSunrise ? 'sunrise' : 'adhan:${entry.key}',
//             id: _notificationId(day, prayerIndex),
//             scheduledDate: scheduled,
//             timezone: tz.local.name,
//             error: e,
//             stackTrace: stack,
//           );
//           rethrow;
//         }
//       }
//     }
//
//     NotificationSchedulerLogger.info(
//       'adhan schedule ready: days=$_scheduleDays alarms=$scheduledCount',
//     );
//   }
//
// }
