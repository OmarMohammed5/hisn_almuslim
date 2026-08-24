import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/lecture_playlist.dart';
import '../models/lecture_model.dart';
import '../models/sheikh_model.dart';
import '../models/youtube_channel_config.dart';

class YoutubeApiException implements Exception {
  final String message;

  const YoutubeApiException(this.message);

  @override
  String toString() => 'YoutubeApiException: $message';
}

class LatestLecturesPage {
  final List<LectureModel> lectures;



  final String? nextPageToken;

  final bool hasMore;

  const LatestLecturesPage({
    required this.lectures,
    required this.nextPageToken,
    required this.hasMore,
  });
}

class YoutubeRemoteDataSource {
  final http.Client client;
  final String apiKey;

  static const _baseUrl =
      'https://www.googleapis.com/youtube/v3';

  const YoutubeRemoteDataSource({
    required this.client,
    required this.apiKey,
  });

  Future<Map<String, dynamic>> _get(
      String path,
      Map<String, String> params,
      ) async {
    if (apiKey.isEmpty) {
      throw const YoutubeApiException(
        'YouTube API key is missing. Start the app with '
            '--dart-define=YOUTUBE_API_KEY=...',
      );
    }

    final uri = Uri.parse('$_baseUrl/$path').replace(
      queryParameters: {
        ...params,
        'key': apiKey,
      },
    );

    final response = await client.get(uri);

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      String details = 'HTTP ${response.statusCode}';

      try {
        final body =
        jsonDecode(response.body)
        as Map<String, dynamic>;

        final error =
        body['error'] as Map<String, dynamic>?;

        final errors =
        error?['errors'] as List<dynamic>?;

        final first = errors?.isNotEmpty == true
            ? errors!.first as Map<String, dynamic>
            : null;

        details = first?['reason'] as String? ??
            error?['message'] as String? ??
            details;
      } catch (_) {}

      throw YoutubeApiException(details);
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const YoutubeApiException(
        'Invalid YouTube API response.',
      );
    }

    return decoded;
  }

  Future<_ChannelSnapshot> _getChannel(
      YoutubeChannelConfig config,
      ) async {
    final data = await _get(
      'channels',
      {
        'part': 'snippet,contentDetails,statistics',
        if (config.channelId != null)
          'id': config.channelId!,
        if (config.handle != null)
          'forHandle': config.handle!,
      },
    );

    final items =
        data['items'] as List<dynamic>? ?? const [];

    if (items.isEmpty) {
      throw YoutubeApiException(
        'Channel not found: '
            '${config.channelId ?? config.handle}',
      );
    }

    final item = items.first as Map<String, dynamic>;

    final snippet =
        item['snippet'] as Map<String, dynamic>? ??
            const {};

    final contentDetails =
        item['contentDetails']
        as Map<String, dynamic>? ??
            const {};

    final related =
        contentDetails['relatedPlaylists']
        as Map<String, dynamic>? ??
            const {};

    final statistics =
        item['statistics']
        as Map<String, dynamic>? ??
            const {};

    return _ChannelSnapshot(
      id: item['id'] as String? ?? '',
      name: snippet['title'] as String? ?? config.name,
      thumbnailUrl:
      _thumbnail(snippet['thumbnails']),
      uploadsPlaylistId:
      related['uploads'] as String? ?? '',
      subscriberCount:
      int.tryParse(
        statistics['subscriberCount']
        as String? ??
            '',
      ) ??
          0,
      videoCount:
      int.tryParse(
        statistics['videoCount'] as String? ??
            '',
      ) ??
          0,
    );
  }

  Future<List<SheikhModel>> getFeaturedSheikhs() async {
    final result = <SheikhModel>[];

    for (final config in featuredYoutubeChannels) {
      try {
        final channel = await _getChannel(config);

        result.add(
          SheikhModel(
            id: channel.id,
            name: channel.name,
            channelId: channel.id,
            thumbnailUrl: channel.thumbnailUrl,
            subscriberCount:
            channel.subscriberCount,
            videoCount: channel.videoCount,
          ),
        );
      } catch (_) {
        // One broken channel must not break
        // the whole section.
      }
    }

    return result;
  }

  Future<LatestLecturesPage> getLatestLectures({
    String? pageToken,
    int perChannel = 8,
  }) async {
    final all = <LectureModel>[];

    Map<String, dynamic> tokens = {};

    if (pageToken != null &&
        pageToken.trim().isNotEmpty) {
      try {
        final decoded =
        jsonDecode(pageToken);

        if (decoded is Map<String, dynamic>) {
          tokens = decoded;
        }
      } catch (_) {
        tokens = {};
      }
    }

    final nextTokens = <String, String>{};

    for (final config in featuredYoutubeChannels) {
      try {
        final channel = await _getChannel(config);

        if (channel.uploadsPlaylistId.isEmpty) {
          continue;
        }

        final currentToken =
        tokens[channel.id] as String?;

        final playlistData = await _get(
          'playlistItems',
          {
            'part': 'snippet,contentDetails',
            'playlistId':
            channel.uploadsPlaylistId,
            'maxResults': '$perChannel',
            if (currentToken != null &&
                currentToken.isNotEmpty)
              'pageToken': currentToken,
          },
        );

        final channelNextToken =
        playlistData['nextPageToken']
        as String?;

        if (channelNextToken != null &&
            channelNextToken.isNotEmpty) {
          nextTokens[channel.id] =
              channelNextToken;
        }

        final items =
            playlistData['items']
            as List<dynamic>? ??
                const [];

        final ids = <String>[];

        final baseById =
        <String, Map<String, dynamic>>{};

        for (final raw in items) {
          final item =
          raw as Map<String, dynamic>;

          final contentDetails =
              item['contentDetails']
              as Map<String, dynamic>? ??
                  const {};

          final snippet =
              item['snippet']
              as Map<String, dynamic>? ??
                  const {};

          final id =
              contentDetails['videoId']
              as String? ??
                  ((snippet['resourceId']
                  as Map<String, dynamic>?)
                  ?['videoId']
                  as String? ??
                      '');

          if (id.isEmpty) continue;

          ids.add(id);
          baseById[id] = snippet;
        }

        if (ids.isEmpty) continue;

        final videosData = await _get(
          'videos',
          {
            'part': 'snippet,contentDetails',
            'id': ids.join(','),
          },
        );

        final videos =
            videosData['items']
            as List<dynamic>? ??
                const [];

        for (final raw in videos) {
          final video =
          raw as Map<String, dynamic>;

          final id =
              video['id'] as String? ?? '';

          if (id.isEmpty) continue;

          final snippet =
              video['snippet']
              as Map<String, dynamic>? ??
                  baseById[id] ??
                  const {};

          final contentDetails =
              video['contentDetails']
              as Map<String, dynamic>? ??
                  const {};

          all.add(
            LectureModel(
              id: id,
              title:
              snippet['title'] as String? ??
                  '',
              description:
              snippet['description']
              as String? ??
                  '',
              channelId: channel.id,
              channelName: channel.name,
              thumbnailUrl:
              _thumbnail(
                snippet['thumbnails'],
              ),
              publishedAt:
              DateTime.tryParse(
                snippet['publishedAt']
                as String? ??
                    '',
              ) ??
                  DateTime
                      .fromMillisecondsSinceEpoch(
                    0,
                  ),
              duration: _parseIsoDuration(
                contentDetails['duration']
                as String? ??
                    'PT0S',
              ),
            ),
          );
        }
      } catch (_) {
        // Continue with the other channels.
      }
    }

    all.sort(
          (a, b) => b.publishedAt
          .compareTo(a.publishedAt),
    );

    final seen = <String>{};

    final unique = all
        .where((lecture) =>
        seen.add(lecture.id))
        .toList(growable: false);

    final encodedNextToken =
    nextTokens.isEmpty
        ? null
        : jsonEncode(nextTokens);

    return LatestLecturesPage(
      lectures: unique,
      nextPageToken: encodedNextToken,
      hasMore: nextTokens.isNotEmpty,
    );
  }

  Future<List<LectureModel>> getLecturesByChannel(
      String channelId, {
        int maxResults = 20,
      }) async {
    final channelData = await _get(
      'channels',
      {
        'part': 'snippet,contentDetails',
        'id': channelId,
      },
    );

    final items =
        channelData['items']
        as List<dynamic>? ??
            const [];

    if (items.isEmpty) return const [];

    final channel =
    items.first as Map<String, dynamic>;

    final snippet =
        channel['snippet']
        as Map<String, dynamic>? ??
            const {};

    final contentDetails =
        channel['contentDetails']
        as Map<String, dynamic>? ??
            const {};

    final related =
        contentDetails['relatedPlaylists']
        as Map<String, dynamic>? ??
            const {};

    final uploads =
        related['uploads'] as String? ?? '';

    if (uploads.isEmpty) return const [];

    final playlistData = await _get(
      'playlistItems',
      {
        'part': 'snippet,contentDetails',
        'playlistId': uploads,
        'maxResults': '$maxResults',
      },
    );

    final playlistItems =
        playlistData['items']
        as List<dynamic>? ??
            const [];

    final ids = playlistItems
        .map((raw) {
      final item =
      raw as Map<String, dynamic>;

      final cd =
          item['contentDetails']
          as Map<String, dynamic>? ??
              const {};

      final sn =
          item['snippet']
          as Map<String, dynamic>? ??
              const {};

      return cd['videoId'] as String? ??
          ((sn['resourceId']
          as Map<String, dynamic>?)
          ?['videoId']
          as String? ??
              '');
    })
        .where((id) => id.isNotEmpty)
        .toList();

    if (ids.isEmpty) return const [];

    return _getVideoModels(
      ids,
      channelId: channelId,
      channelName:
      snippet['title'] as String? ?? '',
    );
  }

  Future<List<LecturePlaylist>>
  getSheikhPlaylists(
      String channelId,
      ) async {
    final data = await _get(
      'playlists',
      {
        'part': 'snippet,contentDetails',
        'channelId': channelId,
        'maxResults': '50',
      },
    );

    final items =
        data['items'] as List<dynamic>? ??
            const [];

    return items
        .map((raw) {
      final item =
      raw as Map<String, dynamic>;

      final snippet =
          item['snippet']
          as Map<String, dynamic>? ??
              const {};

      final contentDetails =
          item['contentDetails']
          as Map<String, dynamic>? ??
              const {};

      return LecturePlaylist(
        id: item['id'] as String? ?? '',
        title:
        snippet['title'] as String? ?? '',
        description:
        snippet['description']
        as String? ??
            '',
        thumbnailUrl:
        _thumbnail(
          snippet['thumbnails'],
        ),
        itemCount:
        (contentDetails['itemCount']
        as num?)
            ?.toInt() ??
            0,
      );
    })
        .where(
          (playlist) =>
      playlist.id.isNotEmpty &&
          playlist.title.trim().isNotEmpty,
    )
        .toList(growable: false);
  }

  Future<PlaylistLecturesPage>
  getPlaylistLectures(
      String playlistId, {
        String? pageToken,
      }) async {
    final data = await _get(
      'playlistItems',
      {
        'part': 'snippet,contentDetails',
        'playlistId': playlistId,
        'maxResults': '20',
        if (pageToken != null &&
            pageToken.isNotEmpty)
          'pageToken': pageToken,
      },
    );

    final items =
        data['items'] as List<dynamic>? ??
            const [];

    final nextPageToken =
    data['nextPageToken'] as String?;

    final ids = <String>[];

    String channelId = '';
    String channelName = '';

    for (final raw in items) {
      final item =
      raw as Map<String, dynamic>;

      final snippet =
          item['snippet']
          as Map<String, dynamic>? ??
              const {};

      final contentDetails =
          item['contentDetails']
          as Map<String, dynamic>? ??
              const {};

      channelId =
          snippet['videoOwnerChannelId']
          as String? ??
              channelId;

      channelName =
          snippet['videoOwnerChannelTitle']
          as String? ??
              channelName;

      final videoId =
          contentDetails['videoId']
          as String? ??
              ((snippet['resourceId']
              as Map<String, dynamic>?)
              ?['videoId']
              as String? ??
                  '');

      if (videoId.isNotEmpty) {
        ids.add(videoId);
      }
    }

    if (ids.isEmpty) {
      return PlaylistLecturesPage(
        lectures: const [],
        nextPageToken: nextPageToken,
        hasMore: nextPageToken != null &&
            nextPageToken.isNotEmpty,
      );
    }

    final lectures =
    await _getVideoModels(
      ids,
      channelId: channelId,
      channelName: channelName,
    );

    return PlaylistLecturesPage(
      lectures: lectures,
      nextPageToken: nextPageToken,
      hasMore: nextPageToken != null &&
          nextPageToken.isNotEmpty,
    );
  }

  Future<List<LectureModel>> searchLectures(
      String query,
      ) async {
    final trimmed = query.trim();

    if (trimmed.isEmpty) return const [];

    final searchData = await _get(
      'search',
      {
        'part': 'snippet',
        'q': trimmed,
        'type': 'video',
        'maxResults': '15',
        'relevanceLanguage': 'ar',
        'safeSearch': 'moderate',
      },
    );

    final items =
        searchData['items'] as List<dynamic>? ??
            const [];

    final ids = <String>[];

    final fallback =
    <String, Map<String, dynamic>>{};

    for (final raw in items) {
      final item =
      raw as Map<String, dynamic>;

      final id =
          (item['id']
          as Map<String, dynamic>?)
          ?['videoId']
          as String? ??
              '';

      if (id.isEmpty) continue;

      ids.add(id);

      fallback[id] =
          item['snippet']
          as Map<String, dynamic>? ??
              const {};
    }

    if (ids.isEmpty) return const [];

    final videos =
    await _getVideoModels(ids);

    return videos.map((lecture) {
      final sn = fallback[lecture.id];

      if (sn == null) return lecture;

      return LectureModel(
        id: lecture.id,
        title: lecture.title.isEmpty
            ? sn['title'] as String? ?? ''
            : lecture.title,
        description: lecture.description,
        channelId: lecture.channelId,
        channelName:
        lecture.channelName.isEmpty
            ? sn['channelTitle']
        as String? ??
            ''
            : lecture.channelName,
        thumbnailUrl:
        lecture.thumbnailUrl.isEmpty
            ? _thumbnail(
          sn['thumbnails'],
        )
            : lecture.thumbnailUrl,
        publishedAt: lecture.publishedAt,
        duration: lecture.duration,
      );
    }).toList(growable: false);
  }

  Future<List<LectureModel>> _getVideoModels(
      List<String> ids, {
        String channelId = '',
        String channelName = '',
      }) async {
    final data = await _get(
      'videos',
      {
        'part': 'snippet,contentDetails',
        'id': ids.join(','),
      },
    );

    final items =
        data['items'] as List<dynamic>? ??
            const [];

    return items.map((raw) {
      final item =
      raw as Map<String, dynamic>;

      final snippet =
          item['snippet']
          as Map<String, dynamic>? ??
              const {};

      final contentDetails =
          item['contentDetails']
          as Map<String, dynamic>? ??
              const {};

      return LectureModel(
        id: item['id'] as String? ?? '',
        title:
        snippet['title'] as String? ?? '',
        description:
        snippet['description']
        as String? ??
            '',
        channelId: channelId.isEmpty
            ? snippet['channelId']
        as String? ??
            ''
            : channelId,
        channelName: channelName.isEmpty
            ? snippet['channelTitle']
        as String? ??
            ''
            : channelName,
        thumbnailUrl:
        _thumbnail(
          snippet['thumbnails'],
        ),
        publishedAt:
        DateTime.tryParse(
          snippet['publishedAt']
          as String? ??
              '',
        ) ??
            DateTime
                .fromMillisecondsSinceEpoch(
              0,
            ),
        duration: _parseIsoDuration(
          contentDetails['duration']
          as String? ??
              'PT0S',
        ),
      );
    }).toList(growable: false);
  }

  static String _thumbnail(
      dynamic thumbnails,
      ) {
    if (thumbnails
    is! Map<String, dynamic>) {
      return '';
    }

    for (final key in const [
      'maxres',
      'high',
      'medium',
      'default',
    ]) {
      final item = thumbnails[key];

      if (item is Map<String, dynamic>) {
        final url = item['url'] as String?;

        if (url != null && url.isNotEmpty) {
          return url;
        }
      }
    }

    return '';
  }

  static Duration _parseIsoDuration(
      String value,
      ) {
    final match = RegExp(
      r'^PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?$',
    ).firstMatch(value);

    if (match == null) {
      return Duration.zero;
    }

    final hours =
        int.tryParse(match.group(1) ?? '') ?? 0;

    final minutes =
        int.tryParse(match.group(2) ?? '') ?? 0;

    final seconds =
        int.tryParse(match.group(3) ?? '') ?? 0;

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }
}

class _ChannelSnapshot {
  final String id;
  final String name;
  final String thumbnailUrl;
  final String uploadsPlaylistId;
  final int subscriberCount;
  final int videoCount;

  const _ChannelSnapshot({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.uploadsPlaylistId,
    required this.subscriberCount,
    required this.videoCount,
  });
}
