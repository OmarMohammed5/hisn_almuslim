import 'package:equatable/equatable.dart';
import 'ayah_model.dart';

class SurahModel extends Equatable {
  final int number;
  final String name;
  final String nameTextEmlaey;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final String? surahInfo;
  final String? surahInfoFromBook;
  final String? surahNames;
  final String? surahNamesFromBook;
  final List<AyahModel> ayahs;

  const SurahModel({
    required this.number,
    required this.name,
    required this.nameTextEmlaey,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    this.surahInfo,
    this.surahInfoFromBook,
    this.surahNames,
    this.surahNamesFromBook,
    required this.ayahs,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    final ayahsList = json['ayahs'] as List<dynamic>? ?? [];

    return SurahModel(
      number: json['number'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameTextEmlaey: json['name_text_emlaey'] as String? ?? '',
      englishName: json['englishName'] as String? ?? '',
      englishNameTranslation: json['englishNameTranslation'] as String? ?? '',
      revelationType: json['revelationType'] as String? ?? '',
      surahInfo: _parseString(json['surahInfo']),
      surahInfoFromBook: _parseString(json['surahInfoFromBook']),
      surahNames: _parseString(json['surahNames']),
      surahNamesFromBook: _parseString(json['surahNamesFromBook']),
      ayahs: ayahsList
          .map((ayah) => AyahModel.fromJson(ayah as Map<String, dynamic>))
          .toList(),
    );
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is int) return value.toString();
    if (value is double) return value.toString();
    if (value is bool) return value.toString();
    if (value is Map) return value.toString();
    if (value is List) return value.join(', ');
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'name_text_emlaey': nameTextEmlaey,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'revelationType': revelationType,
      'surahInfo': surahInfo,
      'surahInfoFromBook': surahInfoFromBook,
      'surahNames': surahNames,
      'surahNamesFromBook': surahNamesFromBook,
      'ayahs': ayahs.map((ayah) => ayah.toJson()).toList(),
    };
  }

  // Helper getters
  String get displayName => name;
  String get displayNameSimplified => nameTextEmlaey;
  bool get isMeccan => revelationType.toLowerCase() == 'meccan';
  bool get isMadani => revelationType.toLowerCase() == 'madani';
  int get totalAyahs => ayahs.length;

  @override
  List<Object?> get props => [
    number,
    name,
    nameTextEmlaey,
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