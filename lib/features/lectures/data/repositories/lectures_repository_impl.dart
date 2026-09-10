import '../../domain/entities/lecture.dart';
import '../../domain/entities/lecture_playlist.dart';
import '../../domain/entities/sheikh.dart';
import '../../domain/repositories/lectures_repository.dart';
import '../../domain/services/islamic_search_validator.dart';
import '../datasources/lectures_local_data_source.dart';
import '../datasources/youtube_remote_data_source.dart';

class LecturesRepositoryImpl implements LecturesRepository {
  final YoutubeRemoteDataSource remote;
  final LecturesLocalDataSource local;

  static const _searchCacheDuration = Duration(minutes: 30);
  static const _maxSearchCacheEntries = 24;

  final Map<String, _SearchCacheEntry> _searchCache = {};
  final Map<String, Future<SearchLecturesPage>> _searchInFlight = {};

  LecturesRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<LatestLecturesPage> getLatestLectures({
    String? pageToken,
    bool forceRefresh = false,
  }) async {
    final isFirstPage = pageToken == null || pageToken.trim().isEmpty;

    if (isFirstPage && !forceRefresh && local.isLatestFresh()) {
      return LatestLecturesPage(
        lectures: local.getCachedLatest(),
        nextPageToken: null,
        hasMore: false,
      );
    }

    try {
      final remoteData = await remote.getLatestLectures(pageToken: pageToken);

      if (isFirstPage && remoteData.lectures.isNotEmpty) {
        await local.cacheLatest(remoteData.lectures);
      }

      return LatestLecturesPage(
        lectures: remoteData.lectures,
        nextPageToken: remoteData.nextPageToken,
        hasMore: remoteData.hasMore,
      );
    } catch (_) {
      if (isFirstPage) {
        return LatestLecturesPage(
          lectures: local.getCachedLatest(),
          nextPageToken: null,
          hasMore: false,
        );
      }
      rethrow;
    }
  }

  @override
  Future<List<Lecture>> getLecturesBySheikh(String channelId) {
    return remote.getLecturesByChannel(channelId);
  }

  @override
  Future<List<Sheikh>> getFeaturedSheikhs({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && local.isSheikhsFresh()) {
      return local.getCachedSheikhs();
    }

    try {
      final remoteData = await remote.getFeaturedSheikhs();

      if (remoteData.isNotEmpty) {
        await local.cacheSheikhs(remoteData);
        return remoteData;
      }
    } catch (_) {}

    return local.getCachedSheikhs();
  }

  @override
  Future<List<Lecture>> searchLectures(String query) async {
    final page = await searchLecturesPage(query: query);
    return page.lectures;
  }

  @override
  Future<SearchLecturesPage> searchLecturesPage({
    required String query,
    String? pageToken,
    String? category,
    String? userQuery,
  }) {
    final normalizedQuery = _normalize(query);
    final normalizedToken = pageToken?.trim() ?? '';

    if (normalizedQuery.isEmpty) {
      return Future.value(
        const SearchLecturesPage(
          lectures: [],
          nextPageToken: null,
          hasMore: false,
        ),
      );
    }

    final normalizedCategory = _normalize(category ?? '');
    final normalizedUserQuery = _normalize(userQuery ?? '');
    final key = '$normalizedCategory::$normalizedUserQuery::$normalizedQuery::$normalizedToken';
    final cached = _searchCache[key];
    if (cached != null &&
        DateTime.now().difference(cached.fetchedAt) <=
            _searchCacheDuration) {
      return Future.value(cached.page);
    }

    final inFlight = _searchInFlight[key];
    if (inFlight != null) return inFlight;

    final future = _fetchAndCacheSearchPage(
      query: normalizedQuery,
      pageToken: normalizedToken.isEmpty ? null : normalizedToken,
      key: key,
      category: category,
      userQuery: userQuery,
    );

    _searchInFlight[key] = future;

    return future.whenComplete(() {
      _searchInFlight.remove(key);
    });
  }

  Future<SearchLecturesPage> _fetchAndCacheSearchPage({
    required String query,
    required String? pageToken,
    required String key,
    String? category,
    String? userQuery,
  }) async {
    final remotePage = await remote.searchLecturesPage(
      query,
      pageToken: pageToken,
    );

    final filtered = remotePage.lectures
        .where((lecture) {
          if (category != null && category.trim().isNotEmpty) {
            return IslamicSearchValidator.isRelevantResultForCategory(
              category: category,
              title: lecture.title,
              description: lecture.description,
              channelName: lecture.channelName,
              query: userQuery ?? query,
            );
          }

          return IslamicSearchValidator.isRelevantResult(
            title: lecture.title,
            description: lecture.description,
            channelName: lecture.channelName,
          );
        })
        .toList(growable: false);

    final page = SearchLecturesPage(
      lectures: filtered,
      nextPageToken: remotePage.nextPageToken,
      hasMore: remotePage.hasMore,
    );

    _searchCache[key] = _SearchCacheEntry(
      fetchedAt: DateTime.now(),
      page: page,
    );

    while (_searchCache.length > _maxSearchCacheEntries) {
      _searchCache.remove(_searchCache.keys.first);
    }

    return page;
  }

  @override
  Future<List<LecturePlaylist>> getSheikhPlaylists(String channelId) {
    return remote.getSheikhPlaylists(channelId);
  }

  @override
  Future<PlaylistLecturesPage> getPlaylistLectures(
    String playlistId, {
    String? pageToken,
  }) {
    return remote.getPlaylistLectures(
      playlistId,
      pageToken: pageToken,
    );
  }

  static String _normalize(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}

class _SearchCacheEntry {
  final DateTime fetchedAt;
  final SearchLecturesPage page;

  const _SearchCacheEntry({
    required this.fetchedAt,
    required this.page,
  });
}
