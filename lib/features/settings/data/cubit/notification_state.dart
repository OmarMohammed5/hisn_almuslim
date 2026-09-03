import 'package:flutter/material.dart';

class NotificationState {
  final bool enableMorning;
  final bool enableEvening;

  final TimeOfDay morningTime;
  final TimeOfDay eveningTime;

  // Daily Quran Wird.
  final bool enableDailyWird;
  final TimeOfDay dailyWirdTime;

  // Recurring "الصلاة على النبي ﷺ" reminder.
  final bool enableDhikrReminder;
  final int dhikrReminderMinutes;

  NotificationState({
    this.enableMorning = false,
    this.enableEvening = false,
    this.morningTime = const TimeOfDay(hour: 5, minute: 30),
    this.eveningTime = const TimeOfDay(hour: 15, minute: 30),
    this.enableDailyWird = false,
    this.dailyWirdTime = const TimeOfDay(hour: 6, minute: 0),
    this.enableDhikrReminder = false,
    this.dhikrReminderMinutes = 5,
  });

  NotificationState copyWith({
    bool? enableMorning,
    bool? enableEvening,
    TimeOfDay? morningTime,
    TimeOfDay? eveningTime,
    bool? enableDailyWird,
    TimeOfDay? dailyWirdTime,
    bool? enableDhikrReminder,
    int? dhikrReminderMinutes,
  }) {
    return NotificationState(
      enableMorning: enableMorning ?? this.enableMorning,
      enableEvening: enableEvening ?? this.enableEvening,
      morningTime: morningTime ?? this.morningTime,
      eveningTime: eveningTime ?? this.eveningTime,
      enableDailyWird: enableDailyWird ?? this.enableDailyWird,
      dailyWirdTime: dailyWirdTime ?? this.dailyWirdTime,
      enableDhikrReminder: enableDhikrReminder ?? this.enableDhikrReminder,
      dhikrReminderMinutes: dhikrReminderMinutes ?? this.dhikrReminderMinutes,
    );
  }
}
