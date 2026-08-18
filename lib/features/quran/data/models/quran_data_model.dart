// lib/features/quran/data/models/quran_data_model.dart

import 'package:equatable/equatable.dart';
import 'surah_model.dart';

class QuranDataModel extends Equatable {
  final List<SurahModel> surahs;

  const QuranDataModel({
    required this.surahs,
  });

  factory QuranDataModel.fromJson(Map<String, dynamic> json) {
    final surahsList = json['surahs'] as List<dynamic>? ?? [];
    return QuranDataModel(
      surahs: surahsList
          .map((surah) => SurahModel.fromJson(surah as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surahs': surahs.map((surah) => surah.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [surahs];
}