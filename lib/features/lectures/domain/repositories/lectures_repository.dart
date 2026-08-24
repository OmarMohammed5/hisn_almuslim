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

abstract class LecturesRepository {
  Future<LatestLecturesPage> getLatestLectures({
    String? pageToken,
  });

  Future<List<Lecture>> getLecturesBySheikh(
      String channelId,
      );

  Future<List<Sheikh>> getFeaturedSheikhs();

  Future<List<Lecture>> searchLectures(
      String query,
      );

  Future<List<LecturePlaylist>>
  getSheikhPlaylists(
      String channelId,
      );

  Future<PlaylistLecturesPage>
  getPlaylistLectures(
      String playlistId, {
        String? pageToken,
      });
}
