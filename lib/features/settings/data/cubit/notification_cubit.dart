import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/service/notification_service.dart';
import 'package:hisn_almuslim/core/service/wird_notification.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/notification_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState());

  final NotificationService _service = NotificationService.service;

  static const List<int> dhikrReminderIntervals = <int>[5, 10, 15, 30];

  // Load saved preferences.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final enableMorning = prefs.getBool('enable_morning') ?? false;
    final enableEvening = prefs.getBool('enable_evening') ?? false;
    final enableWird = prefs.getBool('enable_wird') ?? false;

    final enableDhikrReminder = prefs.getBool('enable_dhikr_reminder') ?? false;
    final savedDhikrMinutes = prefs.getInt('dhikr_reminder_minutes') ?? 5;
    final dhikrReminderMinutes =
    dhikrReminderIntervals.contains(savedDhikrMinutes)
        ? savedDhikrMinutes
        : 5;

    // Load saved times for Wird.
    final wirdHour = prefs.getInt('wird_hour') ?? 6;
    final wirdMinute = prefs.getInt('wird_minute') ?? 0;

    // Load saved times.
    final morningHour = prefs.getInt('morning_hour') ?? 5;
    final morningMinute = prefs.getInt('morning_minute') ?? 30;
    final eveningHour = prefs.getInt('evening_hour') ?? 15;
    final eveningMinute = prefs.getInt('evening_minute') ?? 30;

    emit(
      state.copyWith(
        enableMorning: enableMorning,
        enableEvening: enableEvening,
        enableDailyWird: enableWird,
        dailyWirdTime: TimeOfDay(hour: wirdHour, minute: wirdMinute),
        morningTime: TimeOfDay(hour: morningHour, minute: morningMinute),
        eveningTime: TimeOfDay(hour: eveningHour, minute: eveningMinute),
        enableDhikrReminder: enableDhikrReminder,
        dhikrReminderMinutes: dhikrReminderMinutes,
      ),
    );

    if (enableMorning) {
      try {
        await _service.scheduleMorning(state.morningTime);
      } catch (e) {
        // print('Failed to load morning notification: $e');
      }
    }

    if (enableEvening) {
      try {
        await _service.scheduleEvening(state.eveningTime);
      } catch (e) {
        // print('Failed to load evening notification: $e');
      }
    }

    if (enableWird) {
      try {
        await DailyWirdNotificationService.schedule(
          TimeOfDay(hour: wirdHour, minute: wirdMinute),
        );
      } catch (e) {
        // print('Failed to load wird notification: $e');
      }
    }

    if (enableDhikrReminder) {
      try {
        await _service.scheduleDhikrReminder(dhikrReminderMinutes);
      } catch (e) {
        // print('Failed to load dhikr reminder: $e');
        // Disable it if loading fails
        await prefs.setBool('enable_dhikr_reminder', false);
      }
    }
  }

  // Change Morning Time.
  Future<void> setMorningTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('morning_hour', time.hour);
    await prefs.setInt('morning_minute', time.minute);

    emit(state.copyWith(morningTime: time));

    if (state.enableMorning) {
      try {
        await _service.cancel(NotificationService.morningNotificationId);
        await _service.scheduleMorning(time);
      } catch (e) {
        // print('Failed to update morning notification: $e');
      }
    }
  }

  // Change Evening Time.
  Future<void> setEveningTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('evening_hour', time.hour);
    await prefs.setInt('evening_minute', time.minute);

    emit(state.copyWith(eveningTime: time));

    if (state.enableEvening) {
      try {
        await _service.cancel(NotificationService.eveningNotificationId);
        await _service.scheduleEvening(time);
      } catch (e) {
        // print('Failed to update evening notification: $e');
      }
    }
  }

  // Toggle Morning.
  Future<void> toggleMorning(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enable_morning', value);

    emit(state.copyWith(enableMorning: value));

    if (value) {
      try {
        await _service.scheduleMorning(state.morningTime);
      } catch (e) {
        // print('Failed to enable morning notification: $e');
        await prefs.setBool('enable_morning', false);
        emit(state.copyWith(enableMorning: false));
      }
    } else {
      try {
        await _service.cancel(NotificationService.morningNotificationId);
      } catch (e) {
        // print('Failed to disable morning notification: $e');
      }
    }
  }

  // Toggle Evening.
  Future<void> toggleEvening(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enable_evening', value);

    emit(state.copyWith(enableEvening: value));

    if (value) {
      try {
        await _service.scheduleEvening(state.eveningTime);
      } catch (e) {
        // print('Failed to enable evening notification: $e');
        await prefs.setBool('enable_evening', false);
        emit(state.copyWith(enableEvening: false));
      }
    } else {
      try {
        await _service.cancel(NotificationService.eveningNotificationId);
      } catch (e) {
        // print('Failed to disable evening notification: $e');
      }
    }
  }

  // Quran Daily Wird.
  Future<void> toggleDailyWird(bool value) async {
    emit(state.copyWith(enableDailyWird: value));
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('enable_wird', value);

    if (value) {
      try {
        await DailyWirdNotificationService.schedule(state.dailyWirdTime);
      } catch (e) {
        // print('Failed to enable wird notification: $e');
        await prefs.setBool('enable_wird', false);
        emit(state.copyWith(enableDailyWird: false));
      }
    } else {
      try {
        await DailyWirdNotificationService.cancel();
      } catch (e) {
        // print('Failed to disable wird notification: $e');
      }
    }
  }

  // Change Daily Wird Time.
  Future<void> changeDailyWirdTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('wird_hour', time.hour);
    await prefs.setInt('wird_minute', time.minute);

    emit(state.copyWith(dailyWirdTime: time));

    if (state.enableDailyWird) {
      try {
        await DailyWirdNotificationService.cancel();
        await DailyWirdNotificationService.schedule(time);
      } catch (e) {
        // print('Failed to update wird notification: $e');
      }
    }
  }

  // Toggle the recurring "الصلاة على النبي ﷺ" reminder.
  Future<void> toggleDhikrReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    if (!value) {
      await prefs.setBool('enable_dhikr_reminder', false);
      await _service.cancelDhikrReminder();
      await _service.cancel(
        NotificationService.dhikrReminderNotificationId + 1,
      );
      emit(state.copyWith(enableDhikrReminder: false));
      return;
    }

    final permissionGranted =
    await _service.requestDhikrReminderPermissions();

    if (!permissionGranted) {
      await prefs.setBool('enable_dhikr_reminder', false);
      emit(state.copyWith(enableDhikrReminder: false));
      return;
    }

    try {
      // Show an immediate notification when the user enables the reminder.
      await _service.showDhikrReminderNow();

      // Then activate the recurring reminder.
      await _service.scheduleDhikrReminder(
        state.dhikrReminderMinutes,
      );

      await prefs.setBool('enable_dhikr_reminder', true);
      await prefs.setInt(
        'dhikr_reminder_minutes',
        state.dhikrReminderMinutes,
      );

      emit(state.copyWith(enableDhikrReminder: true));
    } catch (e) {
      // print('Failed to enable dhikr reminder: $e');

      await prefs.setBool('enable_dhikr_reminder', false);
      emit(state.copyWith(enableDhikrReminder: false));
    }
  }

  // Change the recurring reminder interval.
  Future<void> setDhikrReminderMinutes(int minutes) async {
    if (!dhikrReminderIntervals.contains(minutes)) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dhikr_reminder_minutes', minutes);

    emit(state.copyWith(dhikrReminderMinutes: minutes));

    if (state.enableDhikrReminder) {
      try {
        await _service.scheduleDhikrReminder(minutes);
      } catch (e) {
        // print('Failed to update dhikr reminder interval: $e');
      }
    }
  }
}