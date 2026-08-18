import 'package:equatable/equatable.dart';
import 'ayah_entity.dart';

class SurahEntity extends Equatable {
  final int number;
  final String name;
  final String nameSimplified;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final String? surahInfo;
  final String? surahInfoFromBook;
  final String? surahNames;
  final String? surahNamesFromBook;
  final List<AyahEntity> ayahs;

  const SurahEntity({
    required this.number,
    required this.name,
    required this.nameSimplified,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    this.surahInfo,
    this.surahInfoFromBook,
    this.surahNames,
    this.surahNamesFromBook,
    required this.ayahs,
  });

  String get displayName => name;
  String get displayNameSimplified => nameSimplified;
  bool get isMeccan => revelationType.toLowerCase() == 'meccan';
  bool get isMadani => revelationType.toLowerCase() == 'madani';
  int get totalAyahs => ayahs.length;


  // ====== الحصول على رابط الصوت لآية معينة ======
  String getAudioUrlForAyah(int ayahNumber) {
    final ayah = ayahs.firstWhere(
          (a) => a.number == ayahNumber,
      orElse: () => throw Exception('Ayah not found'),
    );
    return ayah.audioUrl;
  }

  @override
  List<Object?> get props => [
    number,
    name,
    nameSimplified,
    englishName,
    englishNameTranslation,
    revelationType,
    surahInfo,
    surahInfoFromBook,
    surahNames,
    surahNamesFromBook,
    ayahs,
  ];
}