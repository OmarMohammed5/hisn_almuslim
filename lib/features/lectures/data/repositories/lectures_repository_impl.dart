import '../../domain/entities/lecture.dart';
import '../../domain/entities/lecture_playlist.dart';
import '../../domain/entities/sheikh.dart';
import '../../domain/repositories/lectures_repository.dart';
import '../../domain/services/islamic_search_validator.dart';
import '../datasources/lectures_local_data_source.dart';
import '../datasources/youtube_remote_data_source.dart' hide LatestLecturesPage;

class LecturesRepositoryImpl
    implements LecturesRepository {
  final YoutubeRemoteDataSource remote;
  final LecturesLocalDataSource local;

  const LecturesRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<LatestLecturesPage> getLatestLectures({
    String? pageToken,
  }) async {
    try {
      final remoteData =
      await remote.getLatestLectures(
        pageToken: pageToken,
      );

      if (pageToken == null &&
          remoteData.lectures.isNotEmpty) {
        await local.cacheLatest(
          remoteData.lectures,
        );
      }

      return LatestLecturesPage(
        lectures: remoteData.lectures,
        nextPageToken:
        remoteData.nextPageToken,
        hasMore: remoteData.hasMore,
      );
    } catch (_) {
      if (pageToken == null) {
        final cached =
        local.getCachedLatest();

        return LatestLecturesPage(
          lectures: cached,
          nextPageToken: null,
          hasMore: false,
        );
      }

      rethrow;
    }
  }

  @override
  Future<List<Lecture>> getLecturesBySheikh(
      String channelId,
      ) {
    return remote.getLecturesByChannel(
      channelId,
    );
  }

  @override
  Future<List<Sheikh>> getFeaturedSheikhs() async {
    try {
      final remoteData =
      await remote.getFeaturedSheikhs();

      if (remoteData.isNotEmpty) {
        await local.cacheSheikhs(
          remoteData,
        );

        return remoteData;
      }
    } catch (_) {}

    return local.getCachedSheikhs();
  }

  @override
  Future<List<Lecture>> searchLectures(
      String query,
      ) async {
    final results =
    await remote.searchLectures(query);

    return results
        .where(
          (lecture) =>
          IslamicSearchValidator
              .isRelevantResult(
            title: lecture.title,
            description: lecture.description,
            channelName: lecture.channelName,
          ),
    )
        .toList(growable: false);
  }

  @override
  Future<List<LecturePlaylist>>
  getSheikhPlaylists(
      String channelId,
      ) {
    return remote.getSheikhPlaylists(
      channelId,
    );
  }

  @override
  Future<PlaylistLecturesPage>
  getPlaylistLectures(
      String playlistId, {
        String? pageToken,
      }) {
    return remote.getPlaylistLectures(
      playlistId,
      pageToken: pageToken,
    );
  }
}
