import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/lecture.dart';
import '../../domain/entities/sheikh.dart';
import '../../domain/repositories/lectures_repository.dart';
import '../../domain/services/islamic_search_validator.dart';
import 'lectures_state.dart';

class LecturesCubit extends Cubit<LecturesState> {
  final LecturesRepository repository;

  static List<Sheikh>? _cachedSheikhs;
  static List<Lecture>? _cachedLatest;
  static DateTime? _cacheTime;
  static const _cacheDuration = Duration(minutes: 15);

  int _categoryRequestId = 0;
  int _searchRequestId = 0;
  Future<void>? _dashboardLoadInFlight;
  Timer? _categorySearchDebounce;

  LecturesCubit({required this.repository}) : super(const LecturesState());

  bool get _isCacheValid {
    if (_cacheTime == null) return false;
    return DateTime.now().difference(_cacheTime!) < _cacheDuration;
  }

  Future<void> loadDashboard({bool forceRefresh = false}) async {
    // Never start duplicate dashboard loads. This is especially important
    // when the screen is rebuilt or revisited while the previous request is
    // still running.
    final inFlight = _dashboardLoadInFlight;
    if (inFlight != null) {
      return inFlight;
    }

    // If this Cubit already has dashboard data, keep it visible. The user
    // should never see the dashboard disappear just because we are checking
    // for fresher data.
    if (!forceRefresh &&
        state.latest.isNotEmpty &&
        state.sheikhs.isNotEmpty &&
        _isCacheValid) {
      return;
    }

    if (!forceRefresh && _isCacheValid && _cachedSheikhs != null) {
      emit(
        state.copyWith(
          status: LecturesStatus.success,
          sheikhs: _cachedSheikhs!,
          latest: _cachedLatest ?? const [],
          clearError: true,
        ),
      );
      return;
    }

    final future = _fetchDashboard(forceRefresh: forceRefresh);
    _dashboardLoadInFlight = future;

    try {
      await future;
    } finally {
      if (identical(_dashboardLoadInFlight, future)) {
        _dashboardLoadInFlight = null;
      }
    }
  }

  Future<void> _fetchDashboard({bool forceRefresh = false}) async {
    final hasVisibleDashboard = state.latest.isNotEmpty || state.sheikhs.isNotEmpty;

    // Keep old/cached content on screen while refreshing. A refresh should
    // update the dashboard in place, never replace it with a skeleton.
    emit(
      state.copyWith(
        status: hasVisibleDashboard ? LecturesStatus.success : LecturesStatus.loading,
        clearError: true,
        hasMoreLatest: state.hasMoreLatest,
        isLoadingMore: false,
      ),
    );

    try {
      final results = await Future.wait([
        repository.getLatestLectures(forceRefresh: forceRefresh),
        repository.getFeaturedSheikhs(forceRefresh: forceRefresh),
      ]);

      final latestPage = results[0] as LatestLecturesPage;
      final sheikhs = results[1] as List<Sheikh>;

      _cachedSheikhs = sheikhs;
      _cachedLatest = latestPage.lectures;
      _cacheTime = DateTime.now();

      emit(
        state.copyWith(
          status: LecturesStatus.success,
          latest: latestPage.lectures,
          sheikhs: sheikhs,
          hasMoreLatest: latestPage.hasMore,
          latestNextPageToken: latestPage.nextPageToken,
          isLoadingMore: false,
          clearError: true,
        ),
      );
    } catch (e) {
      debugPrint('Lectures dashboard error: $e');

      if (_cachedSheikhs != null) {
        emit(
          state.copyWith(
            status: LecturesStatus.success,
            sheikhs: _cachedSheikhs!,
            latest: _cachedLatest ?? const [],
            errorMessage: 'تم عرض البيانات المخزنة مؤقتاً',
            clearError: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: LecturesStatus.failure,
            errorMessage: 'تعذر تحميل المحاضرات حاليًا',
          ),
        );
      }
    }
  }


  Future<void> loadMoreLatest() async {
    if (state.isLoadingMore || !state.hasMoreLatest) return;

    emit(state.copyWith(isLoadingMore: true, clearError: true));

    try {
      final page = await repository.getLatestLectures(
        pageToken: state.latestNextPageToken,
      );

      final existingIds = state.latest.map((e) => e.id).toSet();
      final newLectures = page.lectures
          .where((lecture) => !existingIds.contains(lecture.id))
          .toList(growable: false);

      emit(
        state.copyWith(
          latest: [...state.latest, ...newLectures],
          isLoadingMore: false,
          hasMoreLatest: page.hasMore,
          latestNextPageToken: page.nextPageToken,
        ),
      );
    } catch (e) {
      debugPrint('Load more lectures error: $e');
      emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage: 'تعذر تحميل المزيد من المحاضرات',
        ),
      );
    }
  }

  Future<void> loadBySheikh(String channelId) async {
    try {
      final lectures = await repository.getLecturesBySheikh(channelId);
      emit(
        state.copyWith(
          status: lectures.isEmpty
              ? LecturesStatus.empty
              : LecturesStatus.success,
          searchResults: lectures,
          searchQuery: '',
          clearError: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: LecturesStatus.failure,
          errorMessage: 'تعذر تحميل محاضرات الشيخ',
        ),
      );
    }
  }

  /// Kept for compatibility with any other caller. The main lectures screen
  /// no longer exposes global search; category search is handled below.
  Future<void> search(String query) async {
    final trimmed = _normalize(query);

    if (trimmed.isEmpty) {
      clearSearch();
      return;
    }

    if (trimmed.length < 3) {
      emit(
        state.copyWith(
          status: LecturesStatus.invalidQuery,
          searchQuery: trimmed,
          searchResults: const [],
          errorMessage: 'اكتب 3 أحرف على الأقل للبحث.',
        ),
      );
      return;
    }

    if (!IslamicSearchValidator.isIslamicQuery(trimmed)) {
      emit(
        state.copyWith(
          status: LecturesStatus.invalidQuery,
          searchQuery: trimmed,
          searchResults: const [],
          errorMessage:
              'البحث ده مش تابع للمحتوى الديني. جرّب كلمة مرتبطة بالمحاضرات الإسلامية.',
        ),
      );
      return;
    }

    final requestId = ++_searchRequestId;
    emit(
      state.copyWith(
        status: LecturesStatus.loading,
        searchQuery: trimmed,
        clearError: true,
      ),
    );

    try {
      final page = await repository.searchLecturesPage(
        query: IslamicSearchValidator.enrichQuery(trimmed),
      );

      if (isClosed || requestId != _searchRequestId) return;

      emit(
        state.copyWith(
          status: page.lectures.isEmpty
              ? LecturesStatus.empty
              : LecturesStatus.success,
          searchQuery: trimmed,
          searchResults: page.lectures,
          clearError: true,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('YouTube Search Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!isClosed && requestId == _searchRequestId) {
        emit(
          state.copyWith(
            status: LecturesStatus.failure,
            searchQuery: trimmed,
            errorMessage: 'تعذر تنفيذ البحث الآن، حاول مرة أخرى.',
          ),
        );
      }
    }
  }

  void onCategorySearchChanged({
    required String category,
    required String query,
  }) {
    _categorySearchDebounce?.cancel();

    final trimmedQuery = _normalize(query);
    final trimmedCategory = _normalize(category);

    if (trimmedQuery.isEmpty) {
      // The SearchField calls onChanged('') when its clear button is pressed.
      // Restore the category after a short debounce, avoiding an API call for
      // every character while the user is typing.
      _categorySearchDebounce = Timer(
        const Duration(milliseconds: 250),
        () {
          if (!isClosed) {
            searchCategory(category);
          }
        },
      );
      return;
    }

    if (trimmedQuery.length < 3) {
      ++_categoryRequestId;
      emit(
        state.copyWith(
          status: LecturesStatus.invalidQuery,
          searchQuery: trimmedQuery,
          searchResults: const [],
          hasMoreCategory: false,
          clearCategoryNextPageToken: true,
          activeCategory: trimmedCategory,
          errorMessage: 'اكتب 3 أحرف على الأقل للبحث.',
        ),
      );
      return;
    }

    if (!IslamicSearchValidator.isQueryAllowedInCategory(
      category: trimmedCategory,
      query: trimmedQuery,
    )) {
      ++_categoryRequestId;
      emit(
        state.copyWith(
          status: LecturesStatus.invalidQuery,
          searchQuery: trimmedQuery,
          searchResults: const [],
          hasMoreCategory: false,
          clearCategoryNextPageToken: true,
          activeCategory: trimmedCategory,
          errorMessage:
              'البحث ده مش تابع لقسم ${category.trim()}. جرّب كلمة مرتبطة بالقسم.',
        ),
      );
      return;
    }

    _categorySearchDebounce = Timer(
      const Duration(milliseconds: 650),
      () {
        if (!isClosed) {
          searchInCategory(
            category: category,
            query: query,
          );
        }
      },
    );
  }

  Future<void> searchInCategory({
    required String category,
    required String query,
  }) async {
    _categorySearchDebounce?.cancel();

    final trimmedQuery = _normalize(query);
    final trimmedCategory = _normalize(category);

    if (trimmedCategory.isEmpty) return;

    if (trimmedQuery.isNotEmpty && trimmedQuery.length < 3) {
      ++_categoryRequestId;
      emit(
        state.copyWith(
          status: LecturesStatus.invalidQuery,
          searchQuery: trimmedQuery,
          searchResults: const [],
          hasMoreCategory: false,
          clearCategoryNextPageToken: true,
          activeCategory: trimmedCategory,
          errorMessage: 'اكتب 3 أحرف على الأقل للبحث.',
        ),
      );
      return;
    }

    if (trimmedQuery.isNotEmpty &&
        !IslamicSearchValidator.isQueryAllowedInCategory(
          category: trimmedCategory,
          query: trimmedQuery,
        )) {
      ++_categoryRequestId;
      emit(
        state.copyWith(
          status: LecturesStatus.invalidQuery,
          searchQuery: trimmedQuery,
          searchResults: const [],
          hasMoreCategory: false,
          clearCategoryNextPageToken: true,
          activeCategory: trimmedCategory,
          errorMessage:
              'البحث ده مش تابع للمحتوى الديني. جرّب كلمة مرتبطة بالمحاضرات الإسلامية.',
        ),
      );
      return;
    }

    final requestId = ++_categoryRequestId;
    final enrichedQuery = IslamicSearchValidator.enrichCategoryQuery(
      category: trimmedCategory,
      query: trimmedQuery,
    );

    emit(
      state.copyWith(
        status: LecturesStatus.loading,
        searchQuery: trimmedQuery,
        searchResults: const [],
        hasMoreCategory: true,
        clearCategoryNextPageToken: true,
        isLoadingMoreCategory: false,
        activeCategory: trimmedCategory,
        clearError: true,
      ),
    );

    try {
      final page = await repository.searchLecturesPage(
        query: enrichedQuery,
        category: trimmedCategory,
        userQuery: trimmedQuery,
      );

      if (isClosed || requestId != _categoryRequestId) return;

      emit(
        state.copyWith(
          status: page.lectures.isEmpty
              ? LecturesStatus.empty
              : LecturesStatus.success,
          searchQuery: trimmedQuery,
          searchResults: page.lectures,
          hasMoreCategory: page.hasMore,
          categoryNextPageToken: page.nextPageToken,
          isLoadingMoreCategory: false,
          activeCategory: trimmedCategory,
          clearError: true,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Category Search Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!isClosed && requestId == _categoryRequestId) {
        emit(
          state.copyWith(
            status: LecturesStatus.failure,
            searchQuery: trimmedQuery,
            errorMessage: 'تعذر تحميل المحاضرات الآن، حاول مرة أخرى.',
            isLoadingMoreCategory: false,
          ),
        );
      }
    }
  }

  Future<void> searchCategory(String category) {
    return searchInCategory(category: category, query: '');
  }

  Future<void> loadMoreCategory() async {
    if (state.isLoadingMoreCategory || !state.hasMoreCategory) return;
    if (state.categoryNextPageToken == null ||
        state.categoryNextPageToken!.isEmpty) {
      return;
    }

    final activeCategory = state.activeCategory?.trim();
    if (activeCategory == null || activeCategory.isEmpty) return;

    final currentQuery = state.searchQuery.trim();
    final searchText = currentQuery.isEmpty
        ? activeCategory
        : '$activeCategory $currentQuery';
    final enrichedQuery = IslamicSearchValidator.enrichCategoryQuery(
      category: activeCategory,
      query: currentQuery.isEmpty ? activeCategory : currentQuery,
    );
    final requestId = _categoryRequestId;

    emit(state.copyWith(isLoadingMoreCategory: true, clearError: true));

    try {
      final page = await repository.searchLecturesPage(
        query: enrichedQuery,
        pageToken: state.categoryNextPageToken,
        category: activeCategory,
        userQuery: currentQuery,
      );

      if (isClosed || requestId != _categoryRequestId) return;

      final existingIds = state.searchResults.map((e) => e.id).toSet();
      final newLectures = page.lectures
          .where((lecture) => !existingIds.contains(lecture.id))
          .toList(growable: false);

      emit(
        state.copyWith(
          status: LecturesStatus.success,
          searchResults: [...state.searchResults, ...newLectures],
          hasMoreCategory: page.hasMore,
          categoryNextPageToken: page.nextPageToken,
          isLoadingMoreCategory: false,
          clearError: true,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Category Pagination Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!isClosed && requestId == _categoryRequestId) {
        emit(
          state.copyWith(
            isLoadingMoreCategory: false,
            errorMessage: 'تعذر تحميل المزيد من المحاضرات.',
          ),
        );
      }
    }
  }

  void retrySearch() {
    final category = state.activeCategory;
    if (category != null && category.isNotEmpty) {
      searchInCategory(category: category, query: state.searchQuery);
    } else if (state.searchQuery.isNotEmpty) {
      search(state.searchQuery);
    }
  }

  void clearSearch() {
    ++_searchRequestId;
    ++_categoryRequestId;

    emit(
      state.copyWith(
        status: LecturesStatus.initial,
        searchQuery: '',
        searchResults: const [],
        hasMoreCategory: false,
        isLoadingMoreCategory: false,
        clearCategoryNextPageToken: true,
        clearActiveCategory: true,
        clearError: true,
      ),
    );
  }

  @override
  Future<void> close() {
    _categorySearchDebounce?.cancel();
    return super.close();
  }

  static String _normalize(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
