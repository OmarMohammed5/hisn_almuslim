// notification_state.dart
import 'package:flutter/material.dart';

class NotificationState {
  final bool enableMorning;
  final bool enableEvening;

  final TimeOfDay morningTime;
  final TimeOfDay eveningTime;

  // ✅ جديد للورد اليومي
  final bool enableDailyWird;
  final TimeOfDay dailyWirdTime;

  NotificationState({
    this.enableMorning = false,
    this.enableEvening = false,
    this.morningTime = const TimeOfDay(hour: 5, minute: 30),
    this.eveningTime = const TimeOfDay(hour: 15, minute: 30),

    // ✅ قيم افتراضية للورد
    this.enableDailyWird = false,
    this.dailyWirdTime = const TimeOfDay(hour: 6, minute: 0),
  });

  NotificationState copyWith({
    bool? enableMorning,
    bool? enableEvening,
    TimeOfDay? morningTime,
    TimeOfDay? eveningTime,

    // ✅ جديد
    bool? enableDailyWird,
    TimeOfDay? dailyWirdTime,
  }) {
    return NotificationState(
      enableMorning: enableMorning ?? this.enableMorning,
      enableEvening: enableEvening ?? this.enableEvening,
      morningTime: morningTime ?? this.morningTime,
      eveningTime: eveningTime ?? this.eveningTime,

      // ✅ جديد
      enableDailyWird: enableDailyWird ?? this.enableDailyWird,
      dailyWirdTime: dailyWirdTime ?? this.dailyWirdTime,
    );
  }
}
