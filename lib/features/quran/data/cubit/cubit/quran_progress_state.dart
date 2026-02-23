abstract class QuranProgressState {}

class QuranProgressInitial extends QuranProgressState {}

class QuranReadingProgress extends QuranProgressState {
  final int pagesPerDay;
  final int completedPages;
  final int remainingPages;
  final int remainingDays;
  final int currentPage;
  final String currentSurahName;

  QuranReadingProgress({
    required this.pagesPerDay,
    required this.completedPages,
    required this.remainingPages,
    required this.remainingDays,
    this.currentPage = 0,
    this.currentSurahName = '',
  });

  QuranReadingProgress copyWith({int? currentPage, String? currentSurahName}) {
    return QuranReadingProgress(
      pagesPerDay: pagesPerDay,
      completedPages: completedPages,
      remainingPages: remainingPages,
      remainingDays: remainingDays,
      currentPage: currentPage ?? this.currentPage,
      currentSurahName: currentSurahName ?? this.currentSurahName,
    );
  }
}
