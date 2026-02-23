import 'package:hisn_almuslim/features/jami%20dua/data/models/hajj_items.dart';

class HajjChapter {
  final int chapterId;
  final String chapterTitle;
  final List<HajjItems> items;

  HajjChapter({
    required this.chapterId,
    required this.chapterTitle,
    required this.items,
  });

  factory HajjChapter.fromJson(Map<String, dynamic> json) {
    return HajjChapter(
      chapterId: json['chapter_id'] ?? 0,
      chapterTitle: json['chapter_title'],
      items: (json['items'] as List? ?? [])
          .map((e) => HajjItems.fromJson(e))
          .toList(),
    );
  }
}
