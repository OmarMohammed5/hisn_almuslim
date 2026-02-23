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

// ==============================

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:hisn_almuslim/features/al%20azkar/evening%20azkar/screen/evening_azkar_screen.dart';
// import 'package:hisn_almuslim/features/al%20azkar/morning%20azkar/screen/morning_azkar_screen.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:hisn_almuslim/main.dart'; // ✨ استيراد الـ navigatorKey

// class NotificationService {
//   NotificationService._();
//   static final NotificationService service = NotificationService._();

//   final FlutterLocalNotificationsPlugin _plugin =
//       FlutterLocalNotificationsPlugin();

//   /// initialize the notification service
//   Future<void> init() async {
//     final status = await Permission.ignoreBatteryOptimizations.status;
//     if (status.isDenied) {
//       await Permission.ignoreBatteryOptimizations.request();
//     }

//     const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosInit = DarwinInitializationSettings();

//     const initSettings = InitializationSettings(
//       android: androidInit,
//       iOS: iosInit,
//     );

//     // ✨ إضافة callback للـ notification tap
//     await _plugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: _onNotificationTap,
//     );

//     if (await Permission.notification.isDenied) {
//       await Permission.notification.request();
//     }

//     _plugin.resolvePlatformSpecificImplementation;
//     IOSFlutterLocalNotificationsPlugin().requestPermissions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }

//   // ✨ Method جديدة للتعامل مع الـ tap على الـ notification
//   void _onNotificationTap(NotificationResponse response) {
//     final payload = response.payload;

//     if (payload != null) {
//       _handleNavigation(payload);
//     }
//   }

//   // ✨ Method للـ navigation حسب الـ payload
//   void _handleNavigation(String payload) {
//     final context = navigatorKey.currentContext;

//     if (context != null) {
//       switch (payload) {
//         case 'morning':
//           // Navigate to morning azkar page
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) =>
//                   const MorningAzkarScreen(), // 👈 حط اسم صفحة أذكار الصباح
//             ),
//           );
//           break;

//         case 'evening':
//           // Navigate to evening azkar page
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) =>
//                   const EveningAzkarScreen(), // 👈 حط اسم صفحة أذكار المساء
//             ),
//           );
//           break;
//       }
//     }
//   }

//   // Method to Calculate the time
//   tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
//     final now = tz.TZDateTime.now(tz.local);
//     var target = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       hour,
//       minute,
//     );
//     if (target.isBefore(now)) {
//       target = target.add(const Duration(days: 1));
//     }
//     return target;
//   }

//   // Morning Azkar with custom time
//   Future<void> scheduleMorning(TimeOfDay time) async {
//     await _plugin.zonedSchedule(
//       1,
//       "أذكار الصباح ☀️",
//       "ابدأ يومك بذكر الله 🤍",
//       _nextInstanceOfTime(time.hour, time.minute),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'morning_channel',
//           'Morning Azkar',
//           channelDescription: 'Daily morning azkar',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       payload: 'morning', // ✨ إضافة payload
//       matchDateTimeComponents: DateTimeComponents.time,
//       androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//     );
//   }

//   // Evening Azkar with custom time
//   Future<void> scheduleEvening(TimeOfDay time) async {
//     await _plugin.zonedSchedule(
//       2,
//       "أذكار المساء 🌙",
//       "اختم يومك بذكر الله 🤍",
//       _nextInstanceOfTime(time.hour, time.minute),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'evening_channel',
//           'Evening Azkar',
//           channelDescription: 'Daily evening azkar',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       payload: 'evening', // ✨ إضافة payload
//       matchDateTimeComponents: DateTimeComponents.time,
//       androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//     );
//   }

//   /// Cancel a notification
//   Future<void> cancel(int id) async {
//     await _plugin.cancel(id);
//   }

//   /// Cancel All Notification
//   Future<void> cancelAll() async {
//     await _plugin.cancelAll();
//   }
// }
