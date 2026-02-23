import 'package:hisn_almuslim/features/hadith/books/reyad%20al%20salehin/data/model/reyad_al_saliheen.dart';

class ChapterReyadAlSaliheen {
  final int chapterId;
  final int hadithsCount;
  final String chapterTitle;
  final List<ReyadAlSaliheen> hadiths;

  ChapterReyadAlSaliheen({
    required this.chapterId,
    required this.hadithsCount,
    required this.chapterTitle,
    required this.hadiths,
  });

  factory ChapterReyadAlSaliheen.fromJson(Map<String, dynamic> json) {
    return ChapterReyadAlSaliheen(
      chapterId: json['chapter_id'] ?? 0,
      hadithsCount: json['hadiths_count'] ?? 0,
      chapterTitle: json['chapter_title'] ?? " ",
      hadiths: (json['hadiths'] as List)
          .map((e) => ReyadAlSaliheen.fromJson(e))
          .toList(),
    );
  }
}
