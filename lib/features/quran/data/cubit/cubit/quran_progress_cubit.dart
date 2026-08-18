// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hisn_almuslim/features/quran/data/models/quran_storage.dart';
// import 'package:hisn_almuslim/features/quran/data/models/last_page_storage.dart';
// import 'package:hisn_almuslim/features/quran/data/models/surah_model.dart';
// import 'quran_progress_state.dart';
//
// class QuranProgressCubit extends Cubit<QuranProgressState> {
//   // Number of pages in mushaf (604 pages)
//   static const int totalPages = 604;
//   final QuranStorage khatmaStorage;
//   int _pagesPerDay = 0;
//   int _completedPages = 0;
//   int _currentPage = 0;
//   QuranProgressCubit(this.khatmaStorage) : super(QuranProgressInitial());
//
//   // Update the current page which the user stop where
//   String _currentSurahName = '';
//
//   String _getSurahName(int page, List<SurahModel> surahs) {
//     for (int i = surahs.length - 1; i >= 0; i--) {
//       if (surahs[i].startPage <= page) return surahs[i].name;
//     }
//     return '';
//   }
//
//   void updateCurrentPage(int page, List<SurahModel> surahs) {
//     _currentPage = page;
//     _currentSurahName = _getSurahName(page, surahs);
//     LastPageStorage.savePage(page);
//     if (state is QuranReadingProgress) {
//       emit(
//         (state as QuranReadingProgress).copyWith(
//           currentPage: page,
//           currentSurahName: _currentSurahName,
//         ),
//       );
//     }
//   }
//
//   // Mark today's pages as completed and update progress
//   void markTodayCompleted() {
//     _completedPages += _pagesPerDay;
//
//     if (_completedPages > totalPages) {
//       _completedPages = totalPages;
//     }
//
//     // Save Progress
//     khatmaStorage.saveReading(
//       pagesPerDay: _pagesPerDay,
//       completedPages: _completedPages,
//     );
//     _emitProgress();
//   }
//
//   // To Save the current khatma progress
//   Future<void> loadSavedProgress() async {
//     final data = await khatmaStorage.loadReading();
//
//     if (data == null) return;
//
//     final pagesPerDay = data['pagesPerDay']!;
//     final completedPages = data['completedPages']!;
//     _currentPage = await LastPageStorage.loadPage();
//     _pagesPerDay = pagesPerDay;
//     _completedPages = completedPages;
//
//     _emitProgress();
//   }
//
//   // Mark today's pages as not completed (e.g. if user missed a day)
//   void _emitProgress() {
//     final remainingPages = totalPages - _completedPages;
//     final remainingDays = _pagesPerDay == 0
//         ? 0
//         : (remainingPages / _pagesPerDay).ceil();
//
//     emit(
//       QuranReadingProgress(
//         pagesPerDay: _pagesPerDay,
//         completedPages: _completedPages,
//         remainingPages: remainingPages,
//         remainingDays: remainingDays,
//         currentPage: _currentPage,
//         currentSurahName: _currentSurahName,
//       ),
//     );
//   }
// }
