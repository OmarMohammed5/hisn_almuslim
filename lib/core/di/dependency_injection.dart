import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hisn_almuslim/core/service/notification_service.dart';
import 'package:hisn_almuslim/core/service/wird_notification.dart';
import 'package:hisn_almuslim/features/quran/data/models/quran_storage.dart';
import 'package:hisn_almuslim/features/asma%20allah/data/repo/asma_repositiry.dart';

// Repositories
import 'package:hisn_almuslim/features/quran_audio/data/repos/quran_audio_repository.dart';
import 'package:hisn_almuslim/features/quran_audio/data/repos/quran_audio_repository_impl.dart';

import 'package:hisn_almuslim/features/al%20azkar/data/cubit/azkar_cubit.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/theme_cubit.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/notification_cubit.dart';
import 'package:hisn_almuslim/features/quran/data/cubit/cubit/search_cubit.dart';
import 'package:hisn_almuslim/features/quran/data/cubit/quran_cubit.dart';
import 'package:hisn_almuslim/features/quran/data/cubit/cubit/quran_progress_cubit.dart';
import 'package:hisn_almuslim/features/hadith/books/bukhary/data/cubit/chapters_cubit.dart';
import 'package:hisn_almuslim/features/hadith/books/muslim/data/cubit/sahih_muslim_cubit.dart';
import 'package:hisn_almuslim/features/hadith/books/nawawi/data/cubit/hadith_cubit.dart';
import 'package:hisn_almuslim/features/hadith/books/reyad%20al%20salehin/data/cubit/reyad_al_saliheen_cubit.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/dead%20dua/dead_dua_cubit.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/etiquette%20dua/etiquette_dua_cubit.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/hajj%20and%20omra/hajj_dua_cubit.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/last%20ten%20duas/last_ten_duas_cubit.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/quran%20&%20sunnah%20dua/cubit/dua_cubit.dart';
import 'package:hisn_almuslim/features/asma%20allah/data/cubit/asma_allah_cubit.dart';
import 'package:hisn_almuslim/features/adhan/data/cubit/adhan_cubit.dart';
import 'package:hisn_almuslim/features/quran_audio/logic/quran_audio_cubit.dart';
import 'package:hisn_almuslim/features/quran_audio/logic/audio_player_cubit.dart';

import '../../features/quran/data/cubit/ayah_highlight_cubit.dart';
import '../../features/quran/data/cubit/reading_progress_cubit.dart';
import '../../features/quran/data/datasource/ayah_highlight_data_source.dart';
import '../../features/quran/data/datasource/quran_local_data_source.dart';
import '../../features/quran/data/datasource/quran_local_data_source_impl.dart';
import '../../features/quran/data/datasource/reading_progress_local_data_source.dart';
import '../../features/quran/data/datasource/reading_progress_local_data_source_impl.dart';
import '../../features/quran/domain/repositories/quran_repository.dart';
import '../../features/quran/domain/repositories/quran_repository_impl.dart';
import '../../features/quran/domain/repositories/reading_progress_repository.dart';
import '../../features/quran/domain/repositories/reading_progress_repository_impl.dart';
import '../../features/quran_audio/data/services/app_audio_player_service.dart';
import '../../features/radio/data/datasources/radio_local_data_source.dart';
import '../../features/radio/data/repositories/radio_repository_impl.dart';
import '../../features/radio/domain/repositories/radio_repository.dart';
import '../../features/radio/presentation/cubit/radio_cubit.dart';
import '../../features/stories/data/datasources/stories_local_data_source.dart';
import '../../features/stories/data/repositories/stories_repository.dart';
import '../../features/stories/data/repositories/stories_repository_impl.dart';
import '../../features/stories/domain/usecases/get_prophet_stories.dart';
import '../../features/stories/ui/cubit/stories_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  // ========== Register Async Singletons ==========
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);


  // 1. Register Local Data Source
  sl.registerLazySingleton<QuranLocalDataSource>(
        () => QuranLocalDataSourceImpl(),
  );

  // 2. Register Repository Implementation
  sl.registerLazySingleton<QuranRepository>(
        () => QuranRepositoryImpl(
      localDataSource: sl<QuranLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<ReadingProgressLocalDataSource>(
        () => ReadingProgressLocalDataSourceImpl(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<ReadingProgressRepository>(
        () => ReadingProgressRepositoryImpl(
      localDataSource: sl<ReadingProgressLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<ReadingProgressCubit>(
        () => ReadingProgressCubit(repository: sl<ReadingProgressRepository>())
      ..loadAllProgress(),
  );

  sl.registerLazySingleton<AyahHighlightLocalDataSource>(
        () => AyahHighlightLocalDataSource(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<AyahHighlightCubit>(
        () => AyahHighlightCubit(localDataSource: sl<AyahHighlightLocalDataSource>())
      ..loadAll(),
  );

  // ========== Services
  sl.registerLazySingleton<NotificationService>(
        () => NotificationService.service,
  );
  sl.registerLazySingleton<DailyWirdNotificationService>(
        () => DailyWirdNotificationService(),
  );

  // ========== Storage ==========
  sl.registerLazySingleton<QuranStorage>(() => QuranStorage());

  // ========== Repositories ==========
  sl.registerLazySingleton<AsmaRepository>(() => AsmaRepository());
  sl.registerLazySingleton<QuranAudioRepository>(
        () => QuranAudioRepositoryImpl(),
  );

  // ========== Cubits (Factory
  sl.registerFactory<ThemeCubit>(() => ThemeCubit());
  sl.registerFactory<NotificationCubit>(() => NotificationCubit()..load());

  sl.registerFactory<AzkarCubit>(() => AzkarCubit());
  sl.registerFactory<SearchCubit>(() => SearchCubit());
  // sl.registerFactory<QuranCubit>(() => QuranCubit()..loadSurahs());
  sl.registerFactory<QuranCubit>(
        () => QuranCubit(repository: sl<QuranRepository>()),
  );
  sl.registerFactory<HadithCubit>(() => HadithCubit()..loadHadiths());
  sl.registerFactory<ChaptersCubit>(() => ChaptersCubit()..loadChapters());
  sl.registerFactory<SahihMuslimCubit>(
        () => SahihMuslimCubit()..loadSahihMuslim(),
  );
  sl.registerFactory<ReyadAlSaliheenCubit>(
        () => ReyadAlSaliheenCubit()..loadReyadAlSaliheen(),
  );
  sl.registerFactory<EtiquetteDuaCubit>(
        () => EtiquetteDuaCubit()..loadEtiquetteDua(),
  );
  sl.registerFactory<DuaCubit>(() => DuaCubit()..loadDua());
  sl.registerFactory<HajjDuaCubit>(() => HajjDuaCubit()..loadHajjDua());
  sl.registerFactory<DeadDuaCubit>(() => DeadDuaCubit()..loadDuaDead());
  sl.registerFactory<LastTenDuasCubit>(
        () => LastTenDuasCubit()..loadLastTenDuas(),
  );
  sl.registerFactory<AdhanCubit>(() => AdhanCubit()..loadPrayerTimes());
  // sl.registerFactory<QuranProgressCubit>(
  //       () => QuranProgressCubit(sl<QuranStorage>())..loadSavedProgress(),
  // );
  sl.registerFactory<AsmaAllahCubit>(
        () => AsmaAllahCubit(sl<AsmaRepository>())..loadNames(),
  );
  sl.registerFactory<QuranAudioCubit>(
        () => QuranAudioCubit(repository: sl<QuranAudioRepository>())..loadReciters(),
  );
  sl.registerSingleton<AudioPlayerCubit>( AudioPlayerCubit());


  /// Prophet Stories
  sl.registerLazySingleton<StoriesLocalDataSource>(
        () => StoriesLocalDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<StoriesRepository>(
        () => StoriesRepositoryImpl(
      localDataSource: sl<StoriesLocalDataSource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetProphetStories>(
        () => GetProphetStories(
      repository: sl<StoriesRepository>(),
    ),
  );

  // Cubit (Factory - creates new instance each time)
  sl.registerFactory<StoriesCubit>(
        () => StoriesCubit(
      getProphetStories: sl<GetProphetStories>(),
    ),
  );  _preloadQuranData();


  /// Radio Station

  sl.registerLazySingleton<RadioLocalDataSource>(
        () => RadioLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<RadioRepository>(
        () => RadioRepositoryImpl(
      localDataSource: sl(),
      audioPlayerService: AudioPlayerService.instance,
    ),
  );

  sl.registerFactory<RadioCubit>(
        () => RadioCubit(
      repository: sl(),
    ),
  );


}


/// Preloads the Quran data in the background
void _preloadQuranData() {
  try {
    final repository = sl<QuranRepository>();
    // Preload asynchronously without blocking
    repository.preloadQuran();
  } catch (e) {
    // Silently fail - data will load when needed
    print('Failed to preload Quran data: $e');
  }
}

// RESET METHOD (For Testing)

/// Resets all dependencies (useful for testing)
void resetDependencies() {
  sl.reset();
}
