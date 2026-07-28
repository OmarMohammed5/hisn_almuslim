// features/quran_audio/data/models/surah_model.dart

import 'package:equatable/equatable.dart';

/// Model representing a Surah
class SurahAudioModel extends Equatable {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final int versesCount;

  const SurahAudioModel({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.versesCount,
  });

  @override
  List<Object?> get props => [number, nameArabic, nameEnglish, versesCount];
}
