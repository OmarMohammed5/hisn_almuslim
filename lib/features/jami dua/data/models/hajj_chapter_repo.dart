import 'package:hisn_almuslim/features/jami%20dua/data/models/hajj_chapter.dart';

class HajjChapterRepo {
  final List<HajjChapter> chapters;

  HajjChapterRepo({required this.chapters});

  factory HajjChapterRepo.fromJson(Map<String, dynamic> json) {
    return HajjChapterRepo(
      chapters: (json['chapters'] as List? ?? [])
          .map((e) => HajjChapter.fromJson(e))
          .toList(),
    );
  }
}
