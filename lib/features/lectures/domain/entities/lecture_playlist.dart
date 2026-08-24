import 'lecture.dart';

class LecturePlaylist {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final int itemCount;

  const LecturePlaylist({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.itemCount,
  });
}

class PlaylistLecturesPage {
  final List<Lecture> lectures;
  final String? nextPageToken;
  final bool hasMore;

  const PlaylistLecturesPage({
    required this.lectures,
    required this.nextPageToken,
    required this.hasMore,
  });
}
