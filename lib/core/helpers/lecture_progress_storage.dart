import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/lectures/domain/entities/lecture.dart';

class LectureProgressStorage {
  static const String _lastLectureKey =
      'last_listened_lecture';

  static String progressKey(String lectureId) =>
      'lecture_progress_$lectureId';

  // ============================================================
  // Save Last Lecture
  // ============================================================

  static Future<void> saveLastLecture({
    required SharedPreferences preferences,
    required Lecture lecture,
  }) async {
    final data = {
      'id': lecture.id,
      'title': lecture.title,
      'description': lecture.description,
      'channelId': lecture.channelId,
      'channelName': lecture.channelName,
      'thumbnailUrl': lecture.thumbnailUrl,

      // Convert DateTime -> String
      'publishedAt':
      lecture.publishedAt.toIso8601String(),

      // Convert Duration -> milliseconds
      'duration':
      lecture.duration.inMilliseconds,
    };

    await preferences.setString(
      _lastLectureKey,
      jsonEncode(data),
    );
  }

  // ============================================================
  // Get Last Lecture
  // ============================================================

  static Lecture? getLastLecture(
      SharedPreferences preferences,
      ) {
    final raw =
    preferences.getString(_lastLectureKey);

    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final json =
      jsonDecode(raw) as Map<String, dynamic>;

      return Lecture(
        id: json['id'] as String,

        title: json['title'] as String,

        description:
        json['description'] as String,

        channelId:
        json['channelId'] as String,

        channelName:
        json['channelName'] as String,

        thumbnailUrl:
        json['thumbnailUrl'] as String,

        // String -> DateTime
        publishedAt:
        DateTime.parse(
          json['publishedAt'] as String,
        ),

        // milliseconds -> Duration
        duration:
        Duration(
          milliseconds:
          (json['duration'] as num)
              .toInt(),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  // ============================================================
  // Get Saved Progress
  // ============================================================

  static LectureProgressData? getProgress(
      SharedPreferences preferences,
      String lectureId,
      ) {
    final raw = preferences.getString(
      progressKey(lectureId),
    );

    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final parts = raw.split('|');

      if (parts.length < 3) {
        return null;
      }

      final position =
      double.tryParse(parts[0]);

      final duration =
      double.tryParse(parts[1]);

      final completed =
          parts[2] == 'true';

      if (position == null ||
          duration == null) {
        return null;
      }

      return LectureProgressData(
        position: position,
        duration: duration,
        completed: completed,
      );
    } catch (_) {
      return null;
    }
  }
}

// ============================================================
// Progress Model
// ============================================================

class LectureProgressData {
  final double position;
  final double duration;
  final bool completed;

  const LectureProgressData({
    required this.position,
    required this.duration,
    required this.completed,
  });

  double get percentage {
    if (duration <= 0) {
      return 0;
    }

    return (position / duration)
        .clamp(0.0, 1.0);
  }

  int get percentageInt =>
      (percentage * 100).round();
}