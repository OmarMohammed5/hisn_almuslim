import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:hisn_almuslim/core/utils/arabic_utils.dart';
import 'dart:convert';
import 'package:hisn_almuslim/features/quran/data/cubit/quran_state.dart';
import 'package:hisn_almuslim/features/quran/data/models/surah_model.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit() : super(QuranInitial());

  List<SurahModel> _surahs = [];

  List<SurahModel> get surahs => _surahs;

  Future<void> loadSurahs() async {
    try {
      emit(QuranLoading());

      // Reading the Json from assets
      final String jsonString = await rootBundle.loadString(
        'assets/json/quran_index.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);

      _surahs = jsonData.map((json) => SurahModel.fromJson(json)).toList();

      emit(QuranLoaded(_surahs, _surahs));
    } catch (e) {
      emit(QuranError('حدث خطأ في تحميل البيانات: $e'));
    }
  }

  SurahModel? getSurahByIndex(int index) {
    if (index >= 0 && index < _surahs.length) {
      return _surahs[index];
    }
    return null;
  }

  int getLastPageOfSurah(int surahIndex) {
    if (surahIndex < _surahs.length - 1) {
      return _surahs[surahIndex + 1].startPage - 1;
    }
    return 604;
  }

  void searchSurahs(String query) {
    /// if The user cleared the search field , show all Surahs
    if (state is! QuranLoaded) return;

    final filtered = ArabicSearchUtils.search<SurahModel>(
      list: _surahs,
      query: query,
      getText: (surah) => surah.name,
    );

    emit(QuranLoaded(_surahs, filtered));
  }

  void openSurah(int page) {
    emit(SurahOpened(page));
  }

  /// 🧹 Clean the Search
  void clearSearch() {
    if (state is! QuranLoaded) return;

    emit(QuranLoaded(_surahs, _surahs));
  }
}
