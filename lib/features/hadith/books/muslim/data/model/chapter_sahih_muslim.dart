import 'package:hisn_almuslim/features/hadith/books/muslim/data/model/hadith_muslim.dart';

class ChapterSahihMuslim {
  final int chapterId;
  final int chapterCount;
  final String chapterTitle;
  final List<HadithMuslim> hadiths;

  ChapterSahihMuslim({
    required this.chapterId,
    required this.chapterCount,
    required this.chapterTitle,
    required this.hadiths,
  });

  factory ChapterSahihMuslim.fromJson(Map<String, dynamic> json) {
    return ChapterSahihMuslim(
      chapterId: json['chapter_id'] ?? 0,
      chapterCount: json['hadiths_count'] ?? 0,
      chapterTitle: json['chapter_title'] ?? " ",
      hadiths: (json['hadiths'] as List)
          .map((e) => HadithMuslim.fromJson(e))
          .toList(),
    );
  }
}
