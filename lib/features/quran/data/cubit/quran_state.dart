
import 'package:equatable/equatable.dart';

import '../../domain/entities/ayah_entity.dart';
import '../../domain/entities/mushaf_page_group_entity.dart';
import '../../domain/entities/surah_entity.dart';

/// Base state for Quran feature
abstract class QuranState extends Equatable {
  const QuranState();

  @override
  List<Object?> get props => [];
}

/// Initial state - nothing loaded yet
class QuranInitial extends QuranState {}

/// Loading state - data is being fetched
class QuranLoading extends QuranState {}

/// All Surahs loaded successfully
class QuranLoaded extends QuranState {
  final List<SurahEntity> surahs;
  final List<SurahEntity>? filteredSurahs;
  final String? searchQuery;

  const QuranLoaded({
    required this.surahs,
    this.filteredSurahs,
    this.searchQuery,
  });




  /// Get the list to display (filtered or all)
  List<SurahEntity> get displaySurahs => filteredSurahs ?? surahs;

  @override
  List<Object?> get props => [surahs, filteredSurahs, searchQuery];
}




/// Single Surah loaded
class SurahLoaded extends QuranState {
  final SurahEntity surah;
  final int? selectedAyahNumber;

  const SurahLoaded({
    required this.surah,
    this.selectedAyahNumber,
  });

  @override
  List<Object?> get props => [surah, selectedAyahNumber];
}


class SurahPagesLoaded extends QuranState {
  final SurahEntity surah;
  final MushafPageGroupEntity pageGroup;
  final int? selectedAyahNumber;

  const SurahPagesLoaded({
    required this.surah,
    required this.pageGroup,
    this.selectedAyahNumber,
  });

  SurahPagesLoaded copyWith({int? selectedAyahNumber}) {
    return SurahPagesLoaded(
      surah: surah,
      pageGroup: pageGroup,
      selectedAyahNumber: selectedAyahNumber ?? this.selectedAyahNumber,
    );
  }

  @override
  List<Object?> get props => [surah, pageGroup, selectedAyahNumber];
}



/// Error state
class QuranError extends QuranState {
  final String message;

  const QuranError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Search state - results found
class SearchResultsLoaded extends QuranState {
  final List<AyahEntity> results;
  final String query;

  const SearchResultsLoaded({
    required this.results,
    required this.query,
  });

  @override
  List<Object?> get props => [results, query];
}

/// Bookmarks loaded
class BookmarksLoaded extends QuranState {
  final List<AyahEntity> bookmarks;

  const BookmarksLoaded(this.bookmarks);

  @override
  List<Object?> get props => [bookmarks];
}

/// Bookmark toggled
class BookmarkToggled extends QuranState {
  final bool isBookmarked;
  final int surahNumber;
  final int ayahNumber;

  const BookmarkToggled({
    required this.isBookmarked,
    required this.surahNumber,
    required this.ayahNumber,
  });

  @override
  List<Object?> get props => [isBookmarked, surahNumber, ayahNumber];
}

/// Last read loaded
class LastReadLoaded extends QuranState {
  final int surahNumber;
  final int ayahNumber;

  const LastReadLoaded({
    required this.surahNumber,
    required this.ayahNumber,
  });

  @override
  List<Object?> get props => [surahNumber, ayahNumber];
}

/// Reading progress updated
class ProgressUpdated extends QuranState {
  final int surahNumber;
  final double progress;

  const ProgressUpdated({
    required this.surahNumber,
    required this.progress,
  });

  @override
  List<Object?> get props => [surahNumber, progress];
}