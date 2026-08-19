import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/prophet_story.dart';
import '../../domain/usecases/get_prophet_stories.dart';
import 'stories_state.dart';

class StoriesCubit extends Cubit<StoriesState> {
  final GetProphetStories getProphetStories;

  StoriesCubit({
    required this.getProphetStories,
  }) : super(StoriesInitial());

  // ============================================================
  // LOAD STORIES
  // ============================================================

  Future<void> loadStories() async {
    emit(StoriesLoading());

    final result = await getProphetStories();

    result.fold(
          (error) {
        emit(
          StoriesError(message: error),
        );
      },
          (stories) {
        emit(
          StoriesLoaded(
            stories: stories,
            filteredStories: stories,
          ),
        );
      },
    );
  }

  // ============================================================
  // SEARCH STORIES
  // ============================================================

  void searchStories(String query) {
    final currentState = state;

    if (currentState is! StoriesLoaded) {
      return;
    }

    final normalizedQuery = _normalizeArabic(query);

    // ==========================================================
    // EMPTY SEARCH
    // ==========================================================

    if (normalizedQuery.isEmpty) {
      emit(
        currentState.copyWith(
          filteredStories: currentState.stories,
          clearSearchQuery: true,
        ),
      );

      return;
    }

    // ==========================================================
    // SPLIT QUERY INTO WORDS
    // ==========================================================

    final queryWords = normalizedQuery
        .split(' ')
        .where((word) => word.isNotEmpty)
        .toList();

    // ==========================================================
    // RANK STORIES
    // ==========================================================

    final rankedStories = <_RankedStory>[];

    for (final story in currentState.stories) {
      final prophet = _normalizeArabic(story.prophet);
      final storyText = _normalizeArabic(story.story);

      final score = _calculateScore(
        prophet: prophet,
        storyText: storyText,
        query: normalizedQuery,
        queryWords: queryWords,
      );

      // Only include matching stories
      if (score > 0) {
        rankedStories.add(
          _RankedStory(
            story: story,
            score: score,
          ),
        );
      }
    }

    // ==========================================================
    // SORT BY RELEVANCE
    // Highest score first
    // ==========================================================

    rankedStories.sort(
          (a, b) => b.score.compareTo(a.score),
    );

    // IMPORTANT:
    // Explicitly convert to List<ProphetStory>
    final List<ProphetStory> filteredStories = rankedStories
        .map<ProphetStory>(
          (item) => item.story,
    )
        .toList();

    // ==========================================================
    // EMIT RESULTS
    // ==========================================================

    emit(
      currentState.copyWith(
        filteredStories: filteredStories,
        searchQuery: query.trim(),
      ),
    );
  }

  // ============================================================
  // CALCULATE SEARCH SCORE
  // ============================================================

  int _calculateScore({
    required String prophet,
    required String storyText,
    required String query,
    required List<String> queryWords,
  }) {
    int score = 0;

    // ==========================================================
    // 1. EXACT PROPHET NAME
    // ==========================================================

    if (prophet == query) {
      score += 1000;
    }

    // ==========================================================
    // 2. PROPHET NAME STARTS WITH QUERY
    // ==========================================================

    else if (prophet.startsWith(query)) {
      score += 800;
    }

    // ==========================================================
    // 3. PROPHET NAME CONTAINS QUERY
    // ==========================================================

    else if (prophet.contains(query)) {
      score += 600;
    }

    // ==========================================================
    // 4. MULTI-WORD SEARCH IN PROPHET NAME
    // ==========================================================

    for (final word in queryWords) {
      if (prophet == word) {
        score += 500;
      } else if (prophet.startsWith(word)) {
        score += 350;
      } else if (prophet.contains(word)) {
        score += 200;
      }
    }

    // ==========================================================
    // 5. EXACT QUERY INSIDE STORY
    // ==========================================================

    if (storyText.contains(query)) {
      score += 100;
    }

    // ==========================================================
    // 6. INDIVIDUAL QUERY WORDS INSIDE STORY
    // ==========================================================

    for (final word in queryWords) {
      if (storyText.contains(word)) {
        score += 20;
      }
    }

    return score;
  }

  // ============================================================
  // CLEAR SEARCH
  // ============================================================

  void clearSearch() {
    final currentState = state;

    if (currentState is! StoriesLoaded) {
      return;
    }

    emit(
      currentState.copyWith(
        filteredStories: currentState.stories,
        clearSearchQuery: true,
      ),
    );
  }

  // ============================================================
  // ARABIC NORMALIZATION
  // ============================================================

  String _normalizeArabic(String text) {
    return text
        .trim()
        .toLowerCase()

    // --------------------------------------------------------
    // Arabic Tashkeel
    // --------------------------------------------------------

        .replaceAll(
      RegExp(
        r'[\u064B-\u065F\u0670\u06D6-\u06ED]',
      ),
      '',
    )

    // --------------------------------------------------------
    // Tatweel
    // --------------------------------------------------------

        .replaceAll('ـ', '')

    // --------------------------------------------------------
    // Alif normalization
    // أ إ آ ٱ → ا
    // --------------------------------------------------------

        .replaceAll(
      RegExp(r'[أإآٱ]'),
      'ا',
    )

    // --------------------------------------------------------
    // Ya normalization
    // ى → ي
    // --------------------------------------------------------

        .replaceAll('ى', 'ي')

    // --------------------------------------------------------
    // Waw normalization
    // ؤ → و
    // --------------------------------------------------------

        .replaceAll('ؤ', 'و')

    // --------------------------------------------------------
    // Ya with Hamza
    // ئ → ي
    // --------------------------------------------------------

        .replaceAll('ئ', 'ي')

    // --------------------------------------------------------
    // Ta Marbuta
    // ة → ه
    // --------------------------------------------------------

        .replaceAll('ة', 'ه')

    // --------------------------------------------------------
    // Normalize multiple spaces
    // --------------------------------------------------------

        .replaceAll(
      RegExp(r'\s+'),
      ' ',
    );
  }
}

// ================================================================
// RANKED STORY
// ================================================================

class _RankedStory {
  final ProphetStory story;
  final int score;

  const _RankedStory({
    required this.story,
    required this.score,
  });
}