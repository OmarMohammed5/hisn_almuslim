import 'package:hisn_almuslim/features/hadith/books/bukhary/data/models/chapter.dart';

class ChaptersResponse {
  final List<Chapter> chapters;

  ChaptersResponse({required this.chapters});

  factory ChaptersResponse.fromJson(Map<String, dynamic> json) {
    return ChaptersResponse(
      chapters: (json['chapters'] as List)
          .map((e) => Chapter.fromJson(e))
          .toList(),
    );
  }
}
