import 'package:hisn_almuslim/features/jami%20dua/data/models/dua.dart';

class DuaChapter {
  final int chapterId;
  final String chapterTitle;
  final int duasCount;
  final List<Dua> dua;

  DuaChapter({
    required this.chapterId,
    required this.chapterTitle,
    required this.duasCount,
    required this.dua,
  });

  factory DuaChapter.fromJson(Map<String, dynamic> json) {
    return DuaChapter(
      chapterId: json['chapter_id'] ?? 0,
      chapterTitle: json['chapter_title'] ?? " ",
      duasCount: json['duas_count'] ?? 0,
      dua: (json['duas'] as List? ?? []).map((e) => Dua.fromJson(e)).toList(),
    );
  }
}
