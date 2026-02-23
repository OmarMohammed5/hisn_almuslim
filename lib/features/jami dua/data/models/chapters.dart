import 'package:hisn_almuslim/features/jami%20dua/data/models/dua_chapter.dart';

class Chapters {
  final List<DuaChapter> chapter;

  Chapters(this.chapter);

  factory Chapters.fromJson(Map<String, dynamic> json) {
    return Chapters(
      (json['chapters'] as List? ?? [])
          .map((e) => DuaChapter.fromJson(e))
          .toList(),
    );
  }
}
