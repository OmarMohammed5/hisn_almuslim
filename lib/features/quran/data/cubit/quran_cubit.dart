
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/di/dependency_injection.dart' as di;
import '../../domain/mapper/mushaf_page_mapper.dart';
import '../../domain/repositories/quran_repository.dart';
import 'quran_state.dart';

/// Cubit for managing Quran feature state
class QuranCubit extends Cubit<QuranState> {
  final QuranRepository _repository;

  QuranCubit({QuranRepository? repository})
      : _repository = repository ?? di.sl<QuranRepository>(),
        super(QuranInitial());

  // ============ SURAH METHODS ============

  /// Loads all Surahs
  Future<void> loadAllSurahs() async {
    try {
      // Don't reload if already loaded
      if (state is QuranLoaded && (state as QuranLoaded).surahs.isNotEmpty) {
        return;
      }

      emit( QuranLoading());
      final surahs = await _repository.getAllSurahs();
      emit(QuranLoaded(surahs: surahs));
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  /// Loads a specific Surah by number
  Future<void> loadSurah(int surahNumber) async {
    try {
      emit( QuranLoading());
      final surah = await _repository.getSurahByNumber(surahNumber);

      emit(SurahLoaded(surah: surah));

      // Update reading progress
      await _repository.saveLastRead(surahNumber, 1);
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }


  /// This is what the paged reader screen should call — NOT loadSurah.
  Future<void> loadSurahPaged(int surahNumber, {int? initialAyahNumber}) async {
    try {
      emit(QuranLoading());
      final surah = await _repository.getSurahByNumber(surahNumber);
      final pageGroup = MushafPageMapper.mapSurahToPages(surah);

      emit(SurahPagesLoaded(
        surah: surah,
        pageGroup: pageGroup,
        selectedAyahNumber: initialAyahNumber,
      ));

      await _repository.saveLastRead(surahNumber, initialAyahNumber ?? 1);
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  /// Updates the currently highlighted Ayah without re-fetching or
  /// re-mapping the Surah.
  void selectAyah(int ayahNumberInSurah) {
    final current = state;
    if (current is SurahPagesLoaded) {
      emit(current.copyWith(selectedAyahNumber: ayahNumberInSurah));
    }
  }

  /// Loads a specific Ayah
  Future<void> loadAyah(int surahNumber, int ayahNumber) async {
    try {
      emit( QuranLoading());
      final ayah = await _repository.getAyahByNumber(surahNumber, ayahNumber);

      // Update last read
      await _repository.saveLastRead(surahNumber, ayahNumber);

      // Show Surah with selected Ayah
      final surah = await _repository.getSurahByNumber(surahNumber);
      emit(SurahLoaded(
        surah: surah,
        selectedAyahNumber: ayahNumber,
      ));
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  // ============ SEARCH METHODS ============

  /// Searches for Ayahs matching the query
  Future<void> searchAyahs(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchResultsLoaded(results: [], query: query));
      return;
    }

    try {
      emit( QuranLoading());
      final results = await _repository.searchAyahs(query);
      emit(SearchResultsLoaded(results: results, query: query));
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  /// Clears search and shows all Surahs
  Future<void> clearSearch() async {
    if (state is QuranLoaded) {
      // If we already have all Surahs, just show them
      final currentState = state as QuranLoaded;
      emit(QuranLoaded(
        surahs: currentState.surahs,
        filteredSurahs: null,
        searchQuery: null,
      ));
    } else {
      // Otherwise load all
      await loadAllSurahs();
    }
  }

  /// Filters Surahs by revelation type
  Future<void> filterSurahsByType(String type) async {
    try {
      if (state is QuranLoaded) {
        final currentState = state as QuranLoaded;
        final filtered = await _repository.getSurahsByRevelationType(type);
        emit(QuranLoaded(
          surahs: currentState.surahs,
          filteredSurahs: filtered,
          searchQuery: 'Type: $type',
        ));
      } else {
        // If not loaded, load first then filter
        await loadAllSurahs();
        await filterSurahsByType(type);
      }
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  // ============ BOOKMARK METHODS ============

  /// Toggles bookmark for a specific Ayah
  Future<void> toggleBookmark(int surahNumber, int ayahNumber) async {
    try {
      final isBookmarked = await _repository.isBookmarked(surahNumber, ayahNumber);

      if (isBookmarked) {
        await _repository.removeBookmark(surahNumber, ayahNumber);
        emit(BookmarkToggled(
          isBookmarked: false,
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
        ));
      } else {
        await _repository.saveBookmark(surahNumber, ayahNumber);
        emit(BookmarkToggled(
          isBookmarked: true,
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
        ));
      }
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  /// Loads all bookmarks
  Future<void> loadBookmarks() async {
    try {
      emit( QuranLoading());
      final bookmarks = await _repository.getBookmarks();
      emit(BookmarksLoaded(bookmarks));
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  /// Checks if an Ayah is bookmarked
  Future<bool> isBookmarked(int surahNumber, int ayahNumber) async {
    try {
      return await _repository.isBookmarked(surahNumber, ayahNumber);
    } catch (e) {
      return false;
    }
  }

  // ============ READING PROGRESS METHODS ============

  /// Loads the last read position
  Future<void> loadLastRead() async {
    try {
      final lastRead = await _repository.getLastRead();
      if (lastRead != null) {
        emit(LastReadLoaded(
          surahNumber: lastRead['surahNumber']!,
          ayahNumber: lastRead['ayahNumber']!,
        ));
      }
    } catch (e) {
      // Silently fail - last read is not critical
    }
  }

  /// Updates reading progress for a Surah
  Future<void> updateProgress(int surahNumber, int ayahNumber) async {
    try {
      final success = await _repository.updateSurahProgress(surahNumber, ayahNumber);
      if (success) {
        final progress = await _repository.getSurahProgress(surahNumber);
        emit(ProgressUpdated(
          surahNumber: surahNumber,
          progress: progress,
        ));
      }
    } catch (e) {
      // Silently fail - progress tracking is not critical
    }
  }

  // ============ NAVIGATION HELPERS ============

  /// Navigates to the next Surah
  Future<void> goToNextSurah(int currentSurahNumber) async {
    if (currentSurahNumber < 114) {
      await loadSurah(currentSurahNumber + 1);
    }
  }

  /// Navigates to the previous Surah
  Future<void> goToPreviousSurah(int currentSurahNumber) async {
    if (currentSurahNumber > 1) {
      await loadSurah(currentSurahNumber - 1);
    }
  }

  /// Navigates to the next Ayah in current Surah
  Future<void> goToNextAyah(int surahNumber, int currentAyahNumber) async {
    final surah = await _repository.getSurahByNumber(surahNumber);
    if (currentAyahNumber < surah.totalAyahs) {
      await loadAyah(surahNumber, currentAyahNumber + 1);
    }
  }

  /// Navigates to the previous Ayah in current Surah
  Future<void> goToPreviousAyah(int surahNumber, int currentAyahNumber) async {
    if (currentAyahNumber > 1) {
      await loadAyah(surahNumber, currentAyahNumber - 1);
    }
  }

  // ============ RESET METHODS ============

  /// Resets the state to initial
  void reset() {
    emit( QuranInitial());
  }

  /// Clears all cached data
  void clearCache() {
    _repository.clearCache();
    emit( QuranInitial());
  }


  // lib/features/quran/presentation/cubit/quran_cubit.dart

// أضف هذه الميثودات في الـ QuranCubit

  // ============ SEARCH METHODS (المطورة) ============
  Future<void> searchSurahs(String query) async {
    if (query.trim().isEmpty) {
      emit(QuranLoaded(
        surahs: (state as QuranLoaded?)?.surahs ?? [],
        filteredSurahs: null,
        searchQuery: null,
      ));
      return;
    }

    try {
      final currentState = state;

      if (currentState is QuranLoaded) {
        final allSurahs = currentState.surahs;

        final normalizedQuery = normalizeArabic(query);

        final filtered = allSurahs.where((surah) {
          final arabicName =
          normalizeArabic(surah.displayName);

          final arabicSimple =
          normalizeArabic(surah.displayNameSimplified);

          final english =
          surah.englishName.toLowerCase();

          return arabicName.contains(normalizedQuery) ||
              arabicSimple.contains(normalizedQuery) ||
              english.contains(query.toLowerCase()) ||
              surah.number.toString() == query.trim();
        }).toList();

        emit(QuranLoaded(
          surahs: allSurahs,
          filteredSurahs: filtered,
          searchQuery: query,
        ));
      } else {
        await loadAllSurahs();
        await searchSurahs(query);
      }
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  /// Advanced search in Ayahs text
  Future<void> searchInAyahs(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchResultsLoaded(results: [], query: query));
      return;
    }

    try {
      emit(QuranLoading());
      final results = await _repository.searchAyahs(query);
      emit(SearchResultsLoaded(results: results, query: query));
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  /// Get search suggestions based on query
  List<String> getSearchSuggestions(String query) {
    if (query.trim().isEmpty) return [];

    final currentState = state;
    if (currentState is! QuranLoaded) return [];

    final suggestions = <String>[];
    final queryLower = query.trim().toLowerCase();

    for (final surah in currentState.surahs) {
      if (surah.displayName.contains(query) && suggestions.length < 5) {
        suggestions.add(surah.displayName);
      }
      if (surah.englishName.toLowerCase().contains(queryLower) && suggestions.length < 5) {
        suggestions.add(surah.englishName);
      }
    }

    return suggestions;
  }

  String normalizeArabic(String text) {
    return text
        .trim()
        .toLowerCase()
    // إزالة التشكيل
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
    // توحيد الألف
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
    // الياء والألف المقصورة
        .replaceAll('ى', 'ي')
    // التاء المربوطة
        .replaceAll('ة', 'ه');
  }

}