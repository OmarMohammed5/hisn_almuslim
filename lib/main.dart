import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hisn_almuslim/core/routing/app_router.dart';
import 'package:hisn_almuslim/core/service/notification_service.dart';
import 'package:hisn_almuslim/core/service/wird_notification.dart';
import 'package:hisn_almuslim/features/quran_audio/data/services/app_audio_handler.dart';
import 'package:hisn_almuslim/features/quran_audio/data/services/app_audio_player_service.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/theme_cubit.dart';
import 'package:hisn_almuslim/hisn_al_muslim_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'core/di/dependency_injection.dart';
import 'features/settings/data/cubit/notification_cubit.dart';

late final AppAudioHandler audioHandler;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // SETUP DEPENDENCY INJECTION
  await setupLocator();


  tzdata.initializeTimeZones();
  await _setDeviceTimeZone();

  // Initialize notifications
  await NotificationService.service.init();
  await DailyWirdNotificationService.init();

  // Initialize audio service
  audioHandler = await AudioService.init(
    builder: () => AppAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.hisnalmuslim.audio',
      androidNotificationChannelName: 'Quran Audio Playback',
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidNotificationOngoing: false,
      androidStopForegroundOnPause: false,
    ),
  );
  AudioPlayerService.instance.attachHandler(audioHandler);


  // Get SharedPreferences from locator
  final prefs = sl<SharedPreferences>();
  final seenWelcome = prefs.getBool('seen_onboarding') ?? false;

  // ========== RUN APP ==========
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),
        // NotificationCubit
        BlocProvider<NotificationCubit>(create: (_) => sl<NotificationCubit>()),
      ],
      child: HisnAlMuslimApp(
        // seenWelcomeScreen: seenWelcome,
        appRouter: AppRouter(),
      ),
    ),
  );
}

Future<void> _setDeviceTimeZone() async {
  try {
    final  TimezoneInfo timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
  } catch (e) {
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
  }
}