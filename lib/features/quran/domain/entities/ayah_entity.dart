import 'package:equatable/equatable.dart';

class AyahEntity extends Equatable {
  final int number;
  final String text;
  final String textSimplified;
  final String audioUrl;
  final List<String> audioSecondary;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int pageInSurah;
  final int ruku;
  final int hizbQuarter;
  final bool isSajdah;
  final String codeV2;

  const AyahEntity({
    required this.number,
    required this.text,
    required this.textSimplified,
    required this.audioUrl,
    required this.audioSecondary,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.pageInSurah,
    required this.ruku,
    required this.hizbQuarter,
    required this.isSajdah,
    required this.codeV2,
  });

  // ====== رابط الصوت الأساسي ======
  String get primaryAudioUrl => audioUrl;

  // ====== رابط الصوت الاحتياطي (جودة أقل) ======
  String? get secondaryAudioUrl => audioSecondary.isNotEmpty ? audioSecondary.first : null;

  // ====== الحصول على رابط الصوت الصحيح ======
  String get effectiveAudioUrl {
    // 1. استخدم الرابط الأساسي
    if (audioUrl.isNotEmpty && audioUrl.endsWith('.mp3')) {
      return audioUrl;
    }

    // 2. استخدم الرابط الاحتياطي
    if (audioSecondary.isNotEmpty && audioSecondary.first.endsWith('.mp3')) {
      return audioSecondary.first;
    }

    // 3. استخدم رابط من الـ JSON مع رقم السورة والآية
    // هنحتاج رقم السورة هنا - هتعديه من برا
    return audioUrl;
  }


  @override
  List<Object?> get props => [
    number,
    text,
    textSimplified,
    audioUrl,
    audioSecondary,
    numberInSurah,
    juz,
    manzil,
    page,
    pageInSurah,
    ruku,
    hizbQuarter,
    isSajdah,
    codeV2,
  ];
}