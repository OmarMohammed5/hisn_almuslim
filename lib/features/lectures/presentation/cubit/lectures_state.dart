import 'package:equatable/equatable.dart';

import '../../domain/entities/lecture.dart';
import '../../domain/entities/lecture_progress.dart';
import '../../domain/entities/sheikh.dart';

enum LecturesStatus {
  initial,
  loading,
  success,
  empty,
  invalidQuery,
  failure,
}

class LecturesState extends Equatable {
  final LecturesStatus status;
  final List<Lecture> latest;
  final List<Sheikh> sheikhs;
  final List<Lecture> searchResults;
  final String? errorMessage;
  final String searchQuery;
  final LectureProgress? continueProgress;
  final Lecture? continueLecture;

  final bool isLoadingMore;
  final bool hasMoreLatest;
  final String? latestNextPageToken;

  final bool isLoadingMoreCategory;
  final bool hasMoreCategory;
  final String? categoryNextPageToken;
  final String? activeCategory;

  const LecturesState({
    this.status = LecturesStatus.initial,
    this.latest = const [],
    this.sheikhs = const [],
    this.searchResults = const [],
    this.errorMessage,
    this.searchQuery = '',
    this.continueProgress,
    this.continueLecture,
    this.isLoadingMore = false,
    this.hasMoreLatest = true,
    this.latestNextPageToken,
    this.isLoadingMoreCategory = false,
    this.hasMoreCategory = false,
    this.categoryNextPageToken,
    this.activeCategory,
  });

  LecturesState copyWith({
    LecturesStatus? status,
    List<Lecture>? latest,
    List<Sheikh>? sheikhs,
    List<Lecture>? searchResults,
    String? errorMessage,
    bool clearError = false,
    String? searchQuery,
    LectureProgress? continueProgress,
    bool clearContinue = false,
    Lecture? continueLecture,
    bool? isLoadingMore,
    bool? hasMoreLatest,
    String? latestNextPageToken,
    bool clearLatestNextPageToken = false,
    bool? isLoadingMoreCategory,
    bool? hasMoreCategory,
    String? categoryNextPageToken,
    bool clearCategoryNextPageToken = false,
    String? activeCategory,
    bool clearActiveCategory = false,
  }) {
    return LecturesState(
      status: status ?? this.status,
      latest: latest ?? this.latest,
      sheikhs: sheikhs ?? this.sheikhs,
      searchResults: searchResults ?? this.searchResults,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      continueProgress: clearContinue
          ? null
          : continueProgress ?? this.continueProgress,
      continueLecture: clearContinue
          ? null
          : continueLecture ?? this.continueLecture,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreLatest: hasMoreLatest ?? this.hasMoreLatest,
      latestNextPageToken: clearLatestNextPageToken
          ? null
          : latestNextPageToken ?? this.latestNextPageToken,
      isLoadingMoreCategory:
          isLoadingMoreCategory ?? this.isLoadingMoreCategory,
      hasMoreCategory: hasMoreCategory ?? this.hasMoreCategory,
      categoryNextPageToken: clearCategoryNextPageToken
          ? null
          : categoryNextPageToken ?? this.categoryNextPageToken,
      activeCategory: clearActiveCategory
          ? null
          : activeCategory ?? this.activeCategory,
    );
  }

  @override
  List<Object?> get props => [
        status,
        latest,
        sheikhs,
        searchResults,
        errorMessage,
        searchQuery,
        continueProgress,
        continueLecture,
        isLoadingMore,
        hasMoreLatest,
        latestNextPageToken,
        isLoadingMoreCategory,
        hasMoreCategory,
        categoryNextPageToken,
        activeCategory,
      ];
}
