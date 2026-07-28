import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/service/wird_notification.dart';
import 'package:hisn_almuslim/features/adhan/data/cubit/adhan_cubit.dart';
import 'package:hisn_almuslim/features/al%20azkar/data/cubit/azkar_cubit.dart';
import 'package:hisn_almuslim/features/asma%20allah/data/cubit/asma_allah_cubit.dart';
import 'package:hisn_almuslim/features/asma%20allah/data/repo/asma_repositiry.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/dead%20dua/dead_dua_cubit.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/etiquette%20dua/etiquette_dua_cubit.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/hajj%20and%20omra/hajj_dua_cubit.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/last%20ten%20duas/last_ten_duas_cubit.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/quran%20&%20sunnah%20dua/cubit/dua_cubit.dart';
import 'package:hisn_almuslim/features/quran/data/cubit/cubit/quran_progress_cubit.dart';
import 'package:hisn_almuslim/features/quran/data/cubit/cubit/search_cubit.dart';
import 'package:hisn_almuslim/features/quran/data/cubit/quran_cubit.dart';
import 'package:hisn_almuslim/features/quran/data/models/quran_storage.dart';
import 'package:hisn_almuslim/features/quran_audio/data/quran_audio_module.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/notification_cubit.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/theme_cubit.dart';
import 'package:hisn_almuslim/core/service/notification_service.dart';
import 'package:hisn_almuslim/features/hadith/books/bukhary/data/cubit/chapters_cubit.dart';
import 'package:hisn_almuslim/features/hadith/books/muslim/data/cubit/sahih_muslim_cubit.dart';
import 'package:hisn_almuslim/features/hadith/books/nawawi/data/cubit/hadith_cubit.dart';
import 'package:hisn_almuslim/features/hadith/books/reyad%20al%20salehin/data/cubit/reyad_al_saliheen_cubit.dart';
import 'package:hisn_almuslim/hisn_al_muslim_app.dart';
// import 'package:hisn_almuslim/firebase_options.dart';
import 'package:hisn_almuslim/splash.dart';
import 'package:hisn_almuslim/core/theme/app_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
// import 'package:firebase_core/firebase_core.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatformP
  // );
  tzdata.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

  await NotificationService.service.init();
  await DailyWirdNotificationService.init();
  final prefs = await SharedPreferences.getInstance();
  final seenWelcome = prefs.getBool('seen_onboarding') ?? false;

  final khatmaStorage = QuranStorage();
  final asmaRepo = AsmaRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (create) => AzkarCubit()),
        BlocProvider(create: (create) => ThemeCubit()),
        BlocProvider(create: (context) => NotificationCubit()..load()),
        BlocProvider(create: (context) => SearchCubit()),
        BlocProvider(create: (context) => QuranCubit()..loadSurahs()),
        BlocProvider(create: (context) => HadithCubit()..loadHadiths()),
        BlocProvider(create: (context) => ChaptersCubit()..loadChapters()),
        BlocProvider(
          create: (context) => SahihMuslimCubit()..loadSahihMuslim(),
        ),
        BlocProvider(
          create: (context) => ReyadAlSaliheenCubit()..loadReyadAlSaliheen(),
        ),
        BlocProvider(
          create: (context) => EtiquetteDuaCubit()..loadEtiquetteDua(),
        ),
        BlocProvider(create: (context) => DuaCubit()..loadDua()),

        BlocProvider(create: (context) => HajjDuaCubit()..loadHajjDua()),
        BlocProvider(create: (context) => DeadDuaCubit()..loadDuaDead()),
        BlocProvider(
          create: (context) => LastTenDuasCubit()..loadLastTenDuas(),
        ),
        BlocProvider(create: (context) => AdhanCubit()..loadPrayerTimes()),
        BlocProvider(
          create: (context) =>
              QuranProgressCubit(khatmaStorage)..loadSavedProgress(),
        ),
        BlocProvider(
          create: (context) => AsmaAllahCubit(asmaRepo)..loadNames(),
        ),

        // Quran Audio
        BlocProvider(
          create: (context) => QuranAudioModule.createCubit()..loadReciters(),
        ),
      ],
      child: HisnAlMuslimApp(seenWelcomeScreen: seenWelcome),
    ),
  );
}
