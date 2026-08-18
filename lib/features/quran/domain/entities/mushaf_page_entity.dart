// lib/features/quran/domain/entities/mushaf_page_entity.dart

import 'package:equatable/equatable.dart';

import 'ayah_entity.dart';

/// Represents one real Mushaf page, grouping all Ayahs that belong to it.
/// Used by the reader to render page-by-page instead of one giant Surah block.
class MushafPageEntity extends Equatable {
  final int pageNumber;
  final int juz;
  final int hizbQuarter;
  final int surahNumber;
  final String surahName;
  final List<AyahEntity> ayahs;

  const MushafPageEntity({
    required this.pageNumber,
    required this.juz,
    required this.hizbQuarter,
    required this.surahNumber,
    required this.surahName,
    required this.ayahs,
  });

  bool get isEmpty => ayahs.isEmpty;

  /// True when this page contains a Sajdah ayah.
  bool get hasSajdah => ayahs.any((ayah) => ayah.isSajdah);

  /// First ayah number in this page (numberInSurah, not global).
  int get firstAyahNumberInSurah =>
      ayahs.isNotEmpty ? ayahs.first.numberInSurah : 0;

  /// Last ayah number in this page (numberInSurah, not global).
  int get lastAyahNumberInSurah =>
      ayahs.isNotEmpty ? ayahs.last.numberInSurah : 0;

  @override
  List<Object?> get props => [
    pageNumber,
    juz,
    hizbQuarter,
    surahNumber,
    surahName,
    ayahs,
  ];
}