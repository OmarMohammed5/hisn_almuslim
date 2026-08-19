import 'package:equatable/equatable.dart';

import '../../domain/entities/prophet_story.dart';

abstract class StoriesState extends Equatable {
  const StoriesState();

  @override
  List<Object?> get props => [];
}

// ============================================================
// INITIAL
// ============================================================

class StoriesInitial extends StoriesState {}

// ============================================================
// LOADING
// ============================================================

class StoriesLoading extends StoriesState {}

// ============================================================
// LOADED
// ============================================================

class StoriesLoaded extends StoriesState {
  final List<ProphetStory> stories;
  final List<ProphetStory> filteredStories;
  final String? searchQuery;

  const StoriesLoaded({
    required this.stories,
    required this.filteredStories,
    this.searchQuery,
  });

  StoriesLoaded copyWith({
    List<ProphetStory>? stories,
    List<ProphetStory>? filteredStories,
    String? searchQuery,

    // Used when we explicitly want to set searchQuery to null.
    bool clearSearchQuery = false,
  }) {
    return StoriesLoaded(
      stories: stories ?? this.stories,
      filteredStories: filteredStories ?? this.filteredStories,

      searchQuery: clearSearchQuery
          ? null
          : searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    stories,
    filteredStories,
    searchQuery,
  ];
}

// ============================================================
// ERROR
// ============================================================

class StoriesError extends StoriesState {
  final String message;

  const StoriesError({
    required this.message,
  });

  @override
  List<Object?> get props => [
    message,
  ];
}