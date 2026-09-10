import '../entities/lecture.dart';
import '../entities/lecture_playlist.dart';
import '../entities/sheikh.dart';

class LatestLecturesPage {
  final List<Lecture> lectures;
  final String? nextPageToken;
  final bool hasMore;

  const LatestLecturesPage({
    required this.lectures,
    required this.nextPageToken,
    required this.hasMore,
  });
}

class SearchLecturesPage {
  final List<Lecture> lectures;
  final String? nextPageToken;
  final bool hasMore;

  const SearchLecturesPage({
    required this.lectures,
    required this.nextPageToken,
    required this.hasMore,
  });
}

abstract class LecturesRepository {
  Future<LatestLecturesPage> getLatestLectures({
    String? pageToken,
    bool forceRefresh = false,
  });

  Future<List<Lecture>> getLecturesBySheikh(String channelId);

  Future<List<Sheikh>> getFeaturedSheikhs({
    bool forceRefresh = false,
  });

  /// Backward-compatible first-page search.
  Future<List<Lecture>> searchLectures(String query);

  /// Paginated search used by the category screen.
  Future<SearchLecturesPage> searchLecturesPage({
    required String query,
    String? pageToken,
    String? category,
    String? userQuery,
  });

  Future<List<LecturePlaylist>> getSheikhPlaylists(String channelId);

  Future<PlaylistLecturesPage> getPlaylistLectures(
    String playlistId, {
    String? pageToken,
  });
}
