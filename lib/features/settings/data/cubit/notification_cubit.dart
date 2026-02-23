import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/service/wird_notification.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/notification_state.dart';
import 'package:hisn_almuslim/core/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState());

  final NotificationService _service = NotificationService.service;

  // Load saved preferences
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final enableMorning = prefs.getBool('enable_morning') ?? false;
    final enableEvening = prefs.getBool('enable_evening') ?? false;
    final enableWird = prefs.getBool("enable_wird") ?? false;

    //  Load Saved times for Wird
    final wirdHour = prefs.getInt('wird_hour') ?? 6;
    final wirdMinute = prefs.getInt('wird_minute') ?? 0;
    // Load saved times
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
      ),
    );

    if (enableMorning) {
      await _service.scheduleMorning(state.morningTime);
    }
    if (enableEvening) {
      await _service.scheduleEvening(state.eveningTime);
    }
    if (enableWird) {
      await DailyWirdNotificationService.schedule(
        TimeOfDay(hour: wirdHour, minute: wirdMinute),
      );
    }
  }

  // Change Morning Time
  Future<void> setMorningTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('morning_hour', time.hour);
    await prefs.setInt('morning_minute', time.minute);

    emit(state.copyWith(morningTime: time));

    // Reschedule notification with new time
    if (state.enableMorning) {
      await _service.cancel(1);
      await _service.scheduleMorning(time);
    }
  }

  // Change Evening Time
  Future<void> setEveningTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('evening_hour', time.hour);
    await prefs.setInt('evening_minute', time.minute);

    emit(state.copyWith(eveningTime: time));

    // Reschedule notification with new time
    if (state.enableEvening) {
      await _service.cancel(2);
      await _service.scheduleEvening(time);
    }
  }

  //
  // Toggle Morning
  Future<void> toggleMorning(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enable_morning', value);

    emit(state.copyWith(enableMorning: value));

    if (value) {
      await _service.scheduleMorning(state.morningTime);
    } else {
      await _service.cancel(1);
    }
  }

  // Toggle Evening
  Future<void> toggleEvening(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enable_evening', value);

    emit(state.copyWith(enableEvening: value));

    if (value) {
      await _service.scheduleEvening(state.eveningTime);
    } else {
      await _service.cancel(2);
    }
  }

  // Quran Dialy Wird
  void toggleDailyWird(bool value) async {
    emit(state.copyWith(enableDailyWird: value));
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("enable_wird", value);
    if (value) {
      await DailyWirdNotificationService.schedule(state.dailyWirdTime);
    } else {
      await DailyWirdNotificationService.cancel();
    }
  }

  // Change Dialy Wird Time
  Future<void> changeDailyWirdTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('wird_hour', time.hour);
    await prefs.setInt('wird_minute', time.minute);

    emit(state.copyWith(dailyWirdTime: time));

    if (state.enableDailyWird) {
      await DailyWirdNotificationService.cancel();
      await DailyWirdNotificationService.schedule(time);
    }
  }
}
