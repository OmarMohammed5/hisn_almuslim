import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisn_almuslim/core/models/content_item.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/core/routing/route_transitions.dart';
import 'package:hisn_almuslim/features/radio/presentation/cubit/radio_cubit.dart';
import 'package:hisn_almuslim/features/stories/domain/entities/prophet_story.dart';
import 'package:hisn_almuslim/features/stories/ui/cubit/stories_cubit.dart';
import 'package:hisn_almuslim/features/stories/ui/screens/stories_screen.dart';
import 'package:hisn_almuslim/features/stories/ui/screens/story_details_screen.dart';

import '../../features/adhan/data/cubit/adhan_cubit.dart';
import '../../features/al azkar/data/cubit/azkar_cubit.dart';
import '../../features/al azkar/evening azkar/screen/evening_azkar_screen.dart';
import '../../features/al azkar/morning azkar/screen/morning_azkar_screen.dart';
import '../../features/asma allah/data/cubit/asma_allah_cubit.dart';
import '../../features/asma allah/screen/asma_allah_screen.dart';
import '../../features/hadith/books/bukhary/data/cubit/chapters_cubit.dart';
import '../../features/hadith/books/bukhary/data/models/chapter.dart';
import '../../features/hadith/books/bukhary/screen/fehres_sahih_bukhary.dart';
import '../../features/hadith/books/bukhary/screen/sahih_bukhary_details.dart';
import '../../features/hadith/books/muslim/data/cubit/sahih_muslim_cubit.dart';
import '../../features/hadith/books/muslim/data/model/chapter_sahih_muslim.dart';
import '../../features/hadith/books/muslim/screen/fehres_sahih_muslim.dart';
import '../../features/hadith/books/muslim/screen/sahih_muslim_details.dart';
import '../../features/hadith/books/nawawi/data/cubit/hadith_cubit.dart';
import '../../features/hadith/books/nawawi/screen/fehres_hadith_nawawi.dart';
import '../../features/hadith/books/nawawi/screen/hadith_nawawi.dart';
import '../../features/hadith/books/reyad al salehin/data/cubit/reyad_al_saliheen_cubit.dart';
import '../../features/hadith/books/reyad al salehin/data/model/chapter_reyad_al_saliheen.dart';
import '../../features/hadith/books/reyad al salehin/screen/fehres_reyad_al_saliheen.dart';
import '../../features/hadith/books/reyad al salehin/screen/reyad_al_saliheen_details.dart';
import '../../features/hadith/hadith_screen.dart';
import '../../features/hisn al-muslim/screen/hisn_al_muslim_screen.dart';
import '../../features/hisn al-muslim/screen/zekr_details_screen.dart';
import '../../features/home/screen/home_screen.dart';
import '../../features/jami dua/data/cubit/dead dua/dead_dua_cubit.dart';
import '../../features/jami dua/data/cubit/etiquette dua/etiquette_dua_cubit.dart';
import '../../features/jami dua/data/cubit/hajj and omra/hajj_dua_cubit.dart';
import '../../features/jami dua/data/cubit/last ten duas/last_ten_duas_cubit.dart';
import '../../features/jami dua/data/cubit/quran & sunnah dua/cubit/dua_cubit.dart';
import '../../features/jami dua/data/models/hajj_items.dart';
import '../../features/jami dua/screen/dead_dua_screen.dart';
import '../../features/jami dua/screen/dua_screen.dart';
import '../../features/jami dua/screen/etiquette_dua_screen.dart';
import '../../features/jami dua/screen/hajj_and_omra_details.dart';
import '../../features/jami dua/screen/hajj_and_omra_screen.dart';
import '../../features/jami dua/screen/last_ten_duas_screen.dart';
import '../../features/jami dua/screen/quran_dua_screen.dart';
import '../../features/jami dua/screen/sunnah_dua_screen.dart';
import '../../features/quran/data/cubit/ayah_highlight_cubit.dart';
import '../../features/quran/data/cubit/cubit/quran_progress_cubit.dart';
import '../../features/quran/data/cubit/cubit/search_cubit.dart';
import '../../features/quran/data/cubit/quran_cubit.dart';
import '../../features/quran/data/cubit/reading_progress_cubit.dart';
import '../../features/quran/screen/quran_bookmarks_page.dart';
import '../../features/quran/screen/quran_home_page.dart';
import '../../features/quran/screen/quran_search_page.dart';
import '../../features/quran/screen/quran_tafsir_page.dart';
import '../../features/quran/screen/quran_surah_page.dart';
import '../../features/quran_audio/data/models/reciter_model.dart';
import '../../features/quran_audio/data/models/surah_audio_model.dart';
import '../../features/quran_audio/logic/audio_player_cubit.dart';
import '../../features/quran_audio/logic/quran_audio_cubit.dart';
import '../../features/quran_audio/ui/screens/audio_player_screen.dart';
import '../../features/quran_audio/ui/screens/quran.dart';
import '../../features/quran_audio/ui/screens/quran_audio_home_screen.dart';
import '../../features/radio/presentation/screens/radio_screen.dart';
import '../../features/settings/data/cubit/notification_cubit.dart';
import '../../features/settings/data/cubit/theme_cubit.dart';
import '../../features/settings/screen/settings_screen.dart';
import '../../features/tasbeeh/screen/zekr_allah_screen.dart';
import '../../features/welcome/screen/welcome_screen.dart';
import '../../splash.dart';
import '../di/dependency_injection.dart';

class AppRouter {
  final bool seenWelcomeScreen;

  AppRouter(this.seenWelcomeScreen);

  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
    // ============ SPLASH & WELCOME ============
      case AppRoutes.splash:
        return slidePageRoute(
          settings: settings,
          child:  Splash(seenWelcomeScreen: seenWelcomeScreen),
        );

      case AppRoutes.welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );

    // ============ HOME ============
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: sl<QuranCubit>()),
              // BlocProvider.value(value: sl<QuranProgressCubit>()),
              BlocProvider.value(value: sl<AdhanCubit>()),
              BlocProvider.value(value: sl<RadioCubit>()),

            ],
            child:  HomeScreen(),
          ),
        );

    // ============ Radio Station  ============
      case AppRoutes.radio:
        return slidePageRoute(
            settings: settings,
            child: BlocProvider.value(
                value: sl<RadioCubit>(),
              child: const RadioScreen(),
            ),
        );

    // ============ AZKAR ============
      case AppRoutes.morningAzkar:
        final initialIndex = arguments is int
            ? arguments
            : null;

        return slidePageRoute(
          settings: settings,
          child: MorningAzkarScreen(
            initialIndex: initialIndex,
          ),
        );

      case AppRoutes.eveningAzkar:
        return slidePageRoute(
          settings: settings,
          child: const EveningAzkarScreen(),
        );

     // Hisn Al Muslim

      case AppRoutes.hisnAlMuslim:
    return slidePageRoute(
      settings: settings,
    child: MultiBlocProvider(
    providers: [
    BlocProvider.value(
    value: sl<AzkarCubit>()..getAzkar(),),
      BlocProvider.value(value: sl<SearchCubit>()),
    ],
    child: const HisnAlmuslimScreen(),
    ),
    );

      case AppRoutes.zekrDetails:
        final args = arguments as Map<String, dynamic>;
        final zekr = args['zekr'] as Zekr;
        final initialIndex = args['initialIndex'] as int? ?? 0;
        return slidePageRoute(
          settings: settings,
          child: ZekrDetailsScreen(
            zekr: zekr,
            initialIndex: initialIndex,
          ),
        );

    // ============ ASMA ALLAH ============
      case AppRoutes.asmaAllah:
        return slidePageRoute(
          settings: settings,
          child: BlocProvider(
            create: (_)=> sl<AsmaAllahCubit>()..loadNames(),
            child: const AsmaAllahScreen(),
          ),
        );

    // ============ HADITHS ============
      case AppRoutes.hadith:
        return slidePageRoute(
          settings: settings,
          child:  const HadithScreen(),
        );

      case AppRoutes.fehresSahihBukhary:
        return slidePageRoute(
          settings: settings,
          child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl<SearchCubit>()),
          BlocProvider.value(value: sl<ChaptersCubit>()),
        ],
        child: const FehresSahihBukhary(),
          ),
        );

      case AppRoutes.sahihBukharyDetails:
        final chapter = arguments as Chapter;
        return slidePageRoute(
          settings: settings,
          child: SahihBukharyDetails(chapterSahihBukhary: chapter),
        );

      case AppRoutes.fehresSahihMuslim:
        return slidePageRoute(
          settings: settings,
          child: MultiBlocProvider(
    providers: [
      BlocProvider.value(value: sl<SearchCubit>()),
      BlocProvider.value(value: sl<SahihMuslimCubit>()),
    ],
         child: const FehresSahihMuslim(),
          ),
        );

      case AppRoutes.sahihMuslimDetails:
        final chapter = arguments as ChapterSahihMuslim;
        return slidePageRoute(
          settings: settings,
          child: SahihMuslimDetails(chapterSahihMuslim: chapter),
        );

      case AppRoutes.fehresReyqdAlSaliheen:
        return slidePageRoute(
          settings: settings,
          child: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<SearchCubit>()),
        BlocProvider.value(value: sl<ReyadAlSaliheenCubit>()),
    ],
      child: const FehresReyadAlSaliheen(),
          ),
        );

      case AppRoutes.reyadAlSaliheenDetails:
        final chapter = arguments as ChapterReyadAlSaliheen;
        return slidePageRoute(
          settings: settings,
          child: ReyadAlSaliheenDetails(
            chapterReyadAlSaliheen: chapter,
          ),
        );

      case AppRoutes.fehresHadithNawawi:
        return slidePageRoute(
          settings: settings,
      child: MultiBlocProvider(
    providers: [
      BlocProvider.value(value: sl<SearchCubit>()),
      BlocProvider.value(value: sl<HadithCubit>()),
    ],
      child: const FehresHadithNawawi(),
    ),
    );

      case AppRoutes.hadithNawawi:
        final id = arguments as int;
        return slidePageRoute(
          settings: settings,
          child: BlocProvider.value(
            value:  sl<HadithCubit>(),
              child: HadithNawawi(id: id)),
        );

    // ============ JAMI DUA ============
      case AppRoutes.dua:
        return slidePageRoute(
          settings: settings,
          child: const DuaScreen(),
        );

      case AppRoutes.deadDua:
        return slidePageRoute(
          settings: settings,
          child: BlocProvider.value(
            value: sl<DeadDuaCubit>(),
            child: const DeadDuaScreen(),
          ),
        );

      case AppRoutes.etiquetteDua:
        return slidePageRoute(
          settings: settings,
          child: BlocProvider.value(
            value: sl<EtiquetteDuaCubit>()..loadEtiquetteDua(),
            child: const EtiquetteDuaScreen(),
          ),
        );

      case AppRoutes.hajjAndOmraDua:
        return slidePageRoute(
          settings: settings,
          child: BlocProvider.value(
            value: sl<HajjDuaCubit>(),
            child: const HajjAndOmraScreen(),
          ),
        );

      case AppRoutes.hajjAndOmraDuaDetails:
        final args = arguments as Map<String, dynamic>;
        final title = args['title'] as String;
        final hajjItems = args['hajjItems'] as List<HajjItems>;
        return slidePageRoute(
          settings: settings,
          child: BlocProvider.value(
            value: sl<HajjDuaCubit>(),
            child: HajjAndOmraDetails(
              hajjItems: hajjItems,
              title: title,
            ),
          ),
        );

      case AppRoutes.lastTenDuas:
        return slidePageRoute(
          settings: settings,
          child: BlocProvider.value(
            value: sl<LastTenDuasCubit>(),
            child: const LastTenDuasScreen(),
          ),
        );

      case AppRoutes.quranDua:
        return slidePageRoute(
          settings: settings,
          child:  BlocProvider.value(
            value: sl<DuaCubit>(),
              child: const QuranDuaScreen()),
        );

      case AppRoutes.sunnahDua:
        return slidePageRoute(
          settings: settings,
          child: BlocProvider.value(
              value: sl<DuaCubit>(),
              child: const SunnahDuaScreen()),
        );

    // ============ QURAN ============

      case AppRoutes.quran:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: sl<AyahHighlightCubit>(),
            child: Quran(),
          ),
        );

      case AppRoutes.quranHome:
        return slidePageRoute(
          settings: settings,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: sl<QuranCubit>()),
              BlocProvider.value(value: sl<ReadingProgressCubit>()),
              BlocProvider.value(value: sl<AyahHighlightCubit>()),

            ],
            child: const QuranHomePage(),
          ),
        );


      case AppRoutes.quranSurah:
        final args = arguments as Map<String, dynamic>;
        final surahNumber = args['surahNumber'] as int;
        final ayahNumber = args['ayahNumber'] as int?;
        return slidePageRoute(
          settings: settings,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: sl<QuranCubit>()),
              BlocProvider.value(value: sl<ReadingProgressCubit>()),
              BlocProvider.value(value: sl<AyahHighlightCubit>()),
            ],
            child: QuranSurahPage(
              surahNumber: surahNumber,
              initialAyahNumber: ayahNumber,
            ),
          ),
        );

      case AppRoutes.quranTafsir:
        final args = arguments as Map<String, dynamic>;
        return slidePageRoute(
          settings: settings,
          child: BlocProvider.value(
            value: sl<QuranCubit>(),
            child: QuranTafsirPage(
              ayahNumber: args['ayahNumber'] as int,
              ayahText: args['ayahText'] as String,
              tafsirText: args['tafsirText'] as String,
              tafsirSource: args['tafsirSource'] as String? ?? 'تفسير ابن كثير',
            ),
          ),
        );

    // ============ QURAN AUDIO ============
      case AppRoutes.quranAudioHome:
        return slidePageRoute(
          settings: settings,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: sl<QuranAudioCubit>(),),
              BlocProvider.value(value: sl<AudioPlayerCubit>()),
          ],
            child: const QuranAudioHomeScreen(),
          ),
        );

      case AppRoutes.playerAudio:
        final args = arguments as Map<String, dynamic>;
        final surah = args['surah'] as SurahAudioModel;
        final reciter = args['reciter'] as ReciterModel;
        final audioUrl = args['audioUrl'] as String;
        final surahs = args['surahs'] as List<SurahAudioModel>? ?? const[];

        return slidePageRoute(
          settings: settings,
          child: BlocProvider.value(
            value: sl<AudioPlayerCubit>(),
            child: AudioPlayerScreen(
              surah: surah,
              reciter: reciter,
              audioUrl: audioUrl,
              surahs: surahs,
            ),
          ),
        );

    // ============ SETTINGS ============
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: sl<ThemeCubit>()),
              BlocProvider.value(value: sl<NotificationCubit>()),
            ],
            child: const SettingsScreen(),
          ),
        );

    // ============ TASBEEH ============
      case AppRoutes.zekrAllah:
        return slidePageRoute(
          settings : settings,
          child: const ZekrAllahScreen(),
        );

    // ============ TASBEEH ============

      case AppRoutes.stories:
        return slidePageRoute(
          settings : settings,
          child: BlocProvider.value(
            value: sl<StoriesCubit>(),
              child: const StoriesScreen()),
        );

      case AppRoutes.stories:
        final story = arguments as ProphetStory;
        final allStories = arguments as List<ProphetStory>;
        final currentIndex = arguments as int;

        return slidePageRoute(
          settings : settings,
          child: BlocProvider.value(
              value: sl<StoriesCubit>(),
              child:  StoryDetailsScreen(
                  story: story,
                  allStories: allStories,
                  currentIndex: currentIndex
              )
          ),
        );

      default:
        return null;
    }
  }
}