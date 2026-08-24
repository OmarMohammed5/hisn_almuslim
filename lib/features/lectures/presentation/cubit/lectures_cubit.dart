import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/sheikh.dart';
import '../../domain/repositories/lectures_repository.dart';
import '../../domain/services/islamic_search_validator.dart';
import 'lectures_state.dart';

class LecturesCubit extends Cubit<LecturesState> {
  final LecturesRepository repository;

  Timer? _searchDebounce;

  LecturesCubit({
    required this.repository,
  }) : super(const LecturesState());

  Future<void> loadDashboard() async {
    emit(
      state.copyWith(
        status: LecturesStatus.loading,
        clearError: true,
        latest: const [],
        hasMoreLatest: true,
        latestNextPageToken: null,
        isLoadingMore: false,
      ),
    );

    try {
      final results = await Future.wait([
        repository.getLatestLectures(),
        repository.getFeaturedSheikhs(),
      ]);

      final latestPage =
      results[0] as LatestLecturesPage;

      emit(
        state.copyWith(
          status: LecturesStatus.success,
          latest: latestPage.lectures,
          sheikhs:
          results[1] as List<Sheikh>,
          hasMoreLatest:
          latestPage.hasMore,
          latestNextPageToken:
          latestPage.nextPageToken,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      debugPrint(
        'Lectures dashboard error: $e',
      );

      emit(
        state.copyWith(
          status: LecturesStatus.failure,
          errorMessage:
          'تعذر تحميل المحاضرات حاليًا',
        ),
      );
    }
  }

  Future<void> loadMoreLatest() async {
    if (state.isLoadingMore ||
        !state.hasMoreLatest) {
      return;
    }

    emit(
      state.copyWith(
        isLoadingMore: true,
        clearError: true,
      ),
    );

    try {
      final page =
      await repository.getLatestLectures(
        pageToken:
        state.latestNextPageToken,
      );

      final existingIds =
      state.latest.map((e) => e.id).toSet();

      final newLectures = page.lectures
          .where(
            (lecture) =>
        !existingIds.contains(
          lecture.id,
        ),
      )
          .toList(growable: false);

      emit(
        state.copyWith(
          latest: [
            ...state.latest,
            ...newLectures,
          ],
          isLoadingMore: false,
          hasMoreLatest: page.hasMore,
          latestNextPageToken:
          page.nextPageToken,
        ),
      );
    } catch (e) {
      debugPrint(
        'Load more lectures error: $e',
      );

      emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage:
          'تعذر تحميل المزيد من المحاضرات',
        ),
      );
    }
  }

  Future<void> loadBySheikh(
      String channelId,
      ) async {
    try {
      final lectures =
      await repository.getLecturesBySheikh(
        channelId,
      );

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
          errorMessage:
          'تعذر تحميل محاضرات الشيخ',
        ),
      );
    }
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();

    _searchDebounce?.cancel();

    if (trimmed.isEmpty) {
      emit(
        state.copyWith(
          status: LecturesStatus.initial,
          searchQuery: '',
          searchResults: const [],
          clearError: true,
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
          'يمكنك البحث فقط عن المحاضرات والدروس والمحتوى الإسلامي.',
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        status: LecturesStatus.loading,
        searchQuery: trimmed,
        clearError: true,
      ),
    );

    _searchDebounce = Timer(
      const Duration(milliseconds: 450),
          () async {
        try {
          final results =
          await repository.searchLectures(
            IslamicSearchValidator.enrichQuery(
              trimmed,
            ),
          );

          if (!isClosed) {
            emit(
              state.copyWith(
                status: results.isEmpty
                    ? LecturesStatus.empty
                    : LecturesStatus.success,
                searchQuery: trimmed,
                searchResults: results,
                clearError: true,
              ),
            );
          }
        } catch (e, stackTrace) {
          debugPrint(
            'YouTube Search Error: $e',
          );

          debugPrintStack(
            stackTrace: stackTrace,
          );

          if (!isClosed) {
            emit(
              state.copyWith(
                status: LecturesStatus.failure,
                searchQuery: trimmed,
                errorMessage:
                'تعذر تنفيذ البحث الآن، حاول مرة أخرى.',
              ),
            );
          }
        }
      },
    );
  }


  Future<void> searchInCategory({
    required String category,
    required String query,
  }) async {
    final trimmedQuery = query.trim();
    final trimmedCategory = category.trim();

    _searchDebounce?.cancel();

    // ============================================
    // Empty search
    // ============================================

    if (trimmedQuery.isEmpty) {
      await searchCategory(
        trimmedCategory,
      );

      return;
    }

    // ============================================
    // Validate user query
    // ============================================

    if (!IslamicSearchValidator.isIslamicQuery(
      trimmedQuery,
    )) {
      emit(
        state.copyWith(
          status:
          LecturesStatus.invalidQuery,
          searchQuery: trimmedQuery,
          searchResults: const [],
          errorMessage:
          'يمكنك البحث فقط عن المحاضرات والدروس والمحتوى الإسلامي.',
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        status:
        LecturesStatus.loading,
        searchQuery: trimmedQuery,
        clearError: true,
      ),
    );

    _searchDebounce = Timer(
      const Duration(milliseconds: 450),
          () async {
        try {
          // ========================================
          // Category + User Query
          // ========================================

          final combinedQuery =
              '$trimmedCategory $trimmedQuery';

          final enrichedQuery =
          IslamicSearchValidator.enrichQuery(
            combinedQuery,
          );

          final results =
          await repository.searchLectures(
            enrichedQuery,
          );

          if (!isClosed) {
            emit(
              state.copyWith(
                status: results.isEmpty
                    ? LecturesStatus.empty
                    : LecturesStatus.success,
                searchQuery: trimmedQuery,
                searchResults: results,
                clearError: true,
              ),
            );
          }
        } catch (e, stackTrace) {
          debugPrint(
            'Category Search Error: $e',
          );

          debugPrintStack(
            stackTrace: stackTrace,
          );

          if (!isClosed) {
            emit(
              state.copyWith(
                status:
                LecturesStatus.failure,
                searchQuery: trimmedQuery,
                errorMessage:
                'تعذر تنفيذ البحث الآن، حاول مرة أخرى.',
              ),
            );
          }
        }
      },
    );
  }



  Future<void> searchCategory(
      String category,
      ) async {
    final trimmedCategory =
    category.trim();

    if (trimmedCategory.isEmpty) {
      return;
    }

    emit(
      state.copyWith(
        status:
        LecturesStatus.loading,
        searchQuery: '',
        clearError: true,
      ),
    );

    try {
      final results =
      await repository.searchLectures(
        IslamicSearchValidator.enrichQuery(
          trimmedCategory,
        ),
      );

      if (!isClosed) {
        emit(
          state.copyWith(
            status: results.isEmpty
                ? LecturesStatus.empty
                : LecturesStatus.success,
            searchQuery: '',
            searchResults: results,
            clearError: true,
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint(
        'Category Loading Error: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!isClosed) {
        emit(
          state.copyWith(
            status:
            LecturesStatus.failure,
            errorMessage:
            'تعذر تحميل محتوى التصنيف.',
          ),
        );
      }
    }
  }

  void retrySearch() {
    if (state.searchQuery.isNotEmpty) {
      search(state.searchQuery);
    }
  }

  void clearSearch() {
    _searchDebounce?.cancel();

    emit(
      state.copyWith(
        status: LecturesStatus.initial,
        searchQuery: '',
        searchResults: const [],
        clearError: true,
      ),
    );
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
