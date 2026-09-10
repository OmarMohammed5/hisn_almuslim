import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/service/notification_health_checker.dart';
import 'package:hisn_almuslim/core/service/notification_service.dart';
import 'package:hisn_almuslim/core/service/wird_notification.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/notification_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState()) {
    unawaited(load());
  }

  final NotificationService _service = NotificationService.service;
  Future<void>? _loadFuture;

  static const List<int> dhikrReminderIntervals = <int>[5, 10, 15, 30];

  Future<void> load() {
    return _loadFuture ??= _load();
  }

  Future<void> _load() async {
    // Initialization must happen before health checks or scheduling.
    await _service.init();
    final prefs = await SharedPreferences.getInstance();

    final enableMorning = prefs.getBool('enable_morning') ?? false;
    final enableEvening = prefs.getBool('enable_evening') ?? false;
    final enableWird = prefs.getBool('enable_wird') ?? false;
    final enableDhikrReminder =
        prefs.getBool('enable_dhikr_reminder') ?? false;

    final savedDhikrMinutes = prefs.getInt('dhikr_reminder_minutes') ?? 5;
    final dhikrReminderMinutes = dhikrReminderIntervals.contains(
      savedDhikrMinutes,
    )
        ? savedDhikrMinutes
        : 5;

    final wirdHour = prefs.getInt('wird_hour') ?? 6;
    final wirdMinute = prefs.getInt('wird_minute') ?? 0;
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

    // Repair/re-register all enabled schedules whenever the app starts.
    // The Android AlarmManager alarms are the actual delivery mechanism; this
    // is only a health/recovery pass.
    final health = await NotificationHealthChecker.instance.check();
    if (!health.readyForExactScheduling) {
      NotificationSchedulerLogger.info(
        'startup recovery skipped: notifications=${health.notificationsGranted} '
        'exactAlarm=${health.exactAlarmGranted} '
        'pending=${health.pendingCount}',
      );
      return;
    }

    if (enableMorning) {
      try {
        await _service.scheduleMorning(
          TimeOfDay(hour: morningHour, minute: morningMinute),
        );
      } catch (e, stack) {
        NotificationSchedulerLogger.error(
          type: 'startup:morning',
          id: NotificationService.morningNotificationId,
          error: e,
          stackTrace: stack,
        );
      }
    }

    if (enableEvening) {
      try {
        await _service.scheduleEvening(
          TimeOfDay(hour: eveningHour, minute: eveningMinute),
        );
      } catch (e, stack) {
        NotificationSchedulerLogger.error(
          type: 'startup:evening',
          id: NotificationService.eveningNotificationId,
          error: e,
          stackTrace: stack,
        );
      }
    }

    if (enableWird) {
      try {
        await DailyWirdNotificationService.schedule(
          TimeOfDay(hour: wirdHour, minute: wirdMinute),
        );
      } catch (e, stack) {
        NotificationSchedulerLogger.error(
          type: 'startup:daily_wird',
          id: DailyWirdNotificationService.notificationId,
          error: e,
          stackTrace: stack,
        );
      }
    }

    if (enableDhikrReminder) {
      try {
        await _service.scheduleDhikrReminder(dhikrReminderMinutes);
      } catch (e, stack) {
        NotificationSchedulerLogger.error(
          type: 'startup:dhikr_reminder',
          id: NotificationService.dhikrReminderNotificationId,
          error: e,
          stackTrace: stack,
        );
      }
    }
  }

  Future<void> setMorningTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('morning_hour', time.hour);
    await prefs.setInt('morning_minute', time.minute);

    emit(state.copyWith(morningTime: time));

    if (state.enableMorning) {
      try {
        await _service.cancel(NotificationService.morningNotificationId);
        await _service.scheduleMorning(time);
      } catch (e, stack) {
        NotificationSchedulerLogger.error(type: 'update:morning', id: NotificationService.morningNotificationId, error: e, stackTrace: stack);
      }
    }
  }

  Future<void> setEveningTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('evening_hour', time.hour);
    await prefs.setInt('evening_minute', time.minute);

    emit(state.copyWith(eveningTime: time));

    if (state.enableEvening) {
      try {
        await _service.cancel(NotificationService.eveningNotificationId);
        await _service.scheduleEvening(time);
      } catch (e, stack) {
        NotificationSchedulerLogger.error(type: 'update:evening', id: NotificationService.eveningNotificationId, error: e, stackTrace: stack);
      }
    }
  }

  Future<void> toggleMorning(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    if (!value) {
      await prefs.setBool('enable_morning', false);
      await _service.cancel(NotificationService.morningNotificationId);
      emit(state.copyWith(enableMorning: false));
      return;
    }

    try {
      final permissionGranted = await _service.requestNotificationPermission();
      if (!permissionGranted) {
        await prefs.setBool('enable_morning', false);
        emit(state.copyWith(enableMorning: false));
        return;
      }

      final exactGranted = await _service.requestExactAlarmPermission();
      if (!exactGranted) {
        await prefs.setBool('enable_morning', false);
        emit(state.copyWith(enableMorning: false));
        return;
      }

      await _service.scheduleMorning(state.morningTime);
      await prefs.setBool('enable_morning', true);
      emit(state.copyWith(enableMorning: true));
    } catch (e, stack) {
      NotificationSchedulerLogger.error(type: 'enable:morning', id: NotificationService.morningNotificationId, error: e, stackTrace: stack);
      await prefs.setBool('enable_morning', false);
      emit(state.copyWith(enableMorning: false));
    }
  }

  Future<void> toggleEvening(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    if (!value) {
      await prefs.setBool('enable_evening', false);
      await _service.cancel(NotificationService.eveningNotificationId);
      emit(state.copyWith(enableEvening: false));
      return;
    }

    try {
      final permissionGranted = await _service.requestNotificationPermission();
      if (!permissionGranted) {
        await prefs.setBool('enable_evening', false);
        emit(state.copyWith(enableEvening: false));
        return;
      }

      final exactGranted = await _service.requestExactAlarmPermission();
      if (!exactGranted) {
        await prefs.setBool('enable_evening', false);
        emit(state.copyWith(enableEvening: false));
        return;
      }

      await _service.scheduleEvening(state.eveningTime);
      await prefs.setBool('enable_evening', true);
      emit(state.copyWith(enableEvening: true));
    } catch (e, stack) {
      NotificationSchedulerLogger.error(type: 'enable:evening', id: NotificationService.eveningNotificationId, error: e, stackTrace: stack);
      await prefs.setBool('enable_evening', false);
      emit(state.copyWith(enableEvening: false));
    }
  }

  Future<void> toggleDailyWird(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    if (!value) {
      await prefs.setBool('enable_wird', false);
      await DailyWirdNotificationService.cancel();
      emit(state.copyWith(enableDailyWird: false));
      return;
    }

    try {
      final permissionGranted = await _service.requestNotificationPermission();
      if (!permissionGranted) {
        await prefs.setBool('enable_wird', false);
        emit(state.copyWith(enableDailyWird: false));
        return;
      }

      final exactGranted = await _service.requestExactAlarmPermission();
      if (!exactGranted) {
        await prefs.setBool('enable_wird', false);
        emit(state.copyWith(enableDailyWird: false));
        return;
      }

      await DailyWirdNotificationService.schedule(state.dailyWirdTime);
      await prefs.setBool('enable_wird', true);
      emit(state.copyWith(enableDailyWird: true));
    } catch (e, stack) {
      NotificationSchedulerLogger.error(type: 'enable:daily_wird', id: DailyWirdNotificationService.notificationId, error: e, stackTrace: stack);
      await prefs.setBool('enable_wird', false);
      emit(state.copyWith(enableDailyWird: false));
    }
  }

  Future<void> changeDailyWirdTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('wird_hour', time.hour);
    await prefs.setInt('wird_minute', time.minute);

    emit(state.copyWith(dailyWirdTime: time));

    if (state.enableDailyWird) {
      try {
        await DailyWirdNotificationService.cancel();
        await DailyWirdNotificationService.schedule(time);
      } catch (e, stack) {
        NotificationSchedulerLogger.error(type: 'update:daily_wird', id: DailyWirdNotificationService.notificationId, error: e, stackTrace: stack);
      }
    }
  }

  Future<void> toggleDhikrReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    if (!value) {
      await prefs.setBool('enable_dhikr_reminder', false);
      await _service.cancelDhikrReminder();
      await _service.cancel(
        NotificationService.dhikrReminderImmediateNotificationId,
      );
      emit(state.copyWith(enableDhikrReminder: false));
      return;
    }

    try {
      final permissionGranted =
      await _service.requestDhikrReminderPermissions();
      if (!permissionGranted) {
        await prefs.setBool('enable_dhikr_reminder', false);
        emit(state.copyWith(enableDhikrReminder: false));
        return;
      }

      await _service.scheduleDhikrReminder(state.dhikrReminderMinutes);
      await _service.showDhikrReminderNow();

      await prefs.setBool('enable_dhikr_reminder', true);
      await prefs.setInt(
        'dhikr_reminder_minutes',
        state.dhikrReminderMinutes,
      );

      emit(state.copyWith(enableDhikrReminder: true));
    } catch (e, stack) {
      NotificationSchedulerLogger.error(type: 'enable:dhikr_reminder', id: NotificationService.dhikrReminderNotificationId, error: e, stackTrace: stack);
      await prefs.setBool('enable_dhikr_reminder', false);
      emit(state.copyWith(enableDhikrReminder: false));
    }
  }

  Future<void> setDhikrReminderMinutes(int minutes) async {
    if (!dhikrReminderIntervals.contains(minutes)) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dhikr_reminder_minutes', minutes);
    emit(state.copyWith(dhikrReminderMinutes: minutes));

    if (state.enableDhikrReminder) {
      try {
        await _service.scheduleDhikrReminder(minutes);
      } catch (e, stack) {
        NotificationSchedulerLogger.error(type: 'update:dhikr_reminder', id: NotificationService.dhikrReminderNotificationId, error: e, stackTrace: stack);
      }
    }
  }
}
