import 'package:hisn_almuslim/features/hadith/books/muslim/data/model/chapter_sahih_muslim.dart';

class SahihMuslimResponse {
  final List<ChapterSahihMuslim> chapters;

  SahihMuslimResponse({required this.chapters});

  factory SahihMuslimResponse.fromJson(Map<String, dynamic> json) {
    return SahihMuslimResponse(
      chapters: (json['chapters'] as List)
          .map((e) => ChapterSahihMuslim.fromJson(e))
          .toList(),
    );
  }
}
