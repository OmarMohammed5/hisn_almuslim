// States
import 'package:hisn_almuslim/features/quran/data/models/surah_model.dart';

abstract class QuranState {}

class QuranInitial extends QuranState {}

class QuranLoading extends QuranState {}

class SurahOpened extends QuranState {
  final int page;

  SurahOpened(this.page);
}

class QuranLoaded extends QuranState {
  final List<SurahModel> surahs;
  final List<SurahModel> filteredSurahs;
  QuranLoaded(this.surahs, this.filteredSurahs);
}

class QuranError extends QuranState {
  final String message;
  QuranError(this.message);
}
