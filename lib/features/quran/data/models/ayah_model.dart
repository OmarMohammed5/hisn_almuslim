import 'package:equatable/equatable.dart';

class AyahModel extends Equatable {
  final int number;
  final String text;
  final String ayaTextEmlaey;
  final String audio;
  final List<String> audioSecondary;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int pageInSurah;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;
  final String codeV2;

  const AyahModel({
    required this.number,
    required this.text,
    required this.ayaTextEmlaey,
    required this.audio,
    required this.audioSecondary,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.pageInSurah,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
    required this.codeV2,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {



    return AyahModel(
      number: json['number'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      ayaTextEmlaey: json['aya_text_emlaey'] as String? ?? '',
      audio: json['audio'] as String? ?? '',
      audioSecondary: (json['audioSecondary'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      numberInSurah: json['numberInSurah'] as int? ?? 0,
      juz: json['juz'] as int? ?? 0,
      manzil: json['manzil'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      pageInSurah: json['pageInSurah'] as int? ?? 0,
      ruku: json['ruku'] as int? ?? 0,
      hizbQuarter: json['hizbQuarter'] as int? ?? 0,
      // ====== استخدام parseBool لتفادي المشاكل ======
      sajda: _parseBool(json['sajda']),
      codeV2: json['code_v2'] as String? ?? '',
    );
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == 'true' || lower == '1' || lower == 'yes';
    }
    if (value is Map) return false;
    if (value is List) return false;
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'text': text,
      'aya_text_emlaey': ayaTextEmlaey,
      'audio': audio,
      'audioSecondary': audioSecondary,
      'numberInSurah': numberInSurah,
      'juz': juz,
      'manzil': manzil,
      'page': page,
      'pageInSurah': pageInSurah,
      'ruku': ruku,
      'hizbQuarter': hizbQuarter,
      'sajda': sajda,
      'code_v2': codeV2,
    };
  }

  // Helper getters
  String get displayText => text;
  String get displayTextSimplified => ayaTextEmlaey;
  bool get isSajdah => sajda;

  @override
  List<Object?> get props => [
    number,
    text,
    ayaTextEmlaey,
    audio,
    audioSecondary,
    numberInSurah,
    juz,
    manzil,
    page,
    pageInSurah,
    ruku,
    hizbQuarter,
    sajda,
    codeV2,
  ];
}