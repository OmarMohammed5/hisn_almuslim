import 'package:hisn_almuslim/features/hadith/books/bukhary/data/models/hadith.dart';

class Chapter {
  final int chapterId;
  final int hadithsCount;
  final String chapterTitle;
  final List<HadithSahih> hadiths;

  Chapter({
    required this.chapterId,
    required this.hadithsCount,
    required this.chapterTitle,
    required this.hadiths,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterId: json['chapter_id'] ?? 0,
      hadithsCount: json['hadiths_count'] ?? 0,
      chapterTitle: json['chapter_title'] ?? "",
      hadiths: (json['hadiths'] as List)
          .map((e) => HadithSahih.fromJson(e))
          .toList(),
    );
  }
}
