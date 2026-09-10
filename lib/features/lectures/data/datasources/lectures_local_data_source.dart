import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/lecture_model.dart';
import '../models/sheikh_model.dart';

class LecturesLocalDataSource {
  final SharedPreferences preferences;

  const LecturesLocalDataSource(this.preferences);

  static const _latestKey = 'lectures_latest_cache_v2';
  static const _sheikhsKey = 'lectures_sheikhs_cache_v2';
  static const _cachedAtKey = 'cachedAt';

  Future<void> cacheLatest(List<LectureModel> lectures) async {
    await preferences.setString(
      _latestKey,
      jsonEncode({
        _cachedAtKey: DateTime.now().toUtc().toIso8601String(),
        'items': lectures.map((e) => e.toJson()).toList(),
      }),
    );
  }

  List<LectureModel> getCachedLatest() {
    final raw = preferences.getString(_latestKey);
    if (raw == null || raw.isEmpty) return const [];

    try {
      final decoded = jsonDecode(raw);

      // Backward compatibility with the old cache format.
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(LectureModel.fromJson)
            .toList(growable: false);
      }

      if (decoded is! Map<String, dynamic>) return const [];

      final items = decoded['items'];
      if (items is! List) return const [];

      return items
          .whereType<Map<String, dynamic>>()
          .map(LectureModel.fromJson)
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  bool isLatestFresh({
    Duration maxAge = const Duration(hours: 6),
  }) {
    return _isFresh(_latestKey, maxAge);
  }

  Future<void> cacheSheikhs(List<SheikhModel> sheikhs) async {
    await preferences.setString(
      _sheikhsKey,
      jsonEncode({
        _cachedAtKey: DateTime.now().toUtc().toIso8601String(),
        'items': sheikhs.map((e) => e.toJson()).toList(),
      }),
    );
  }

  List<SheikhModel> getCachedSheikhs() {
    final raw = preferences.getString(_sheikhsKey);
    if (raw == null || raw.isEmpty) return const [];

    try {
      final decoded = jsonDecode(raw);

      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(SheikhModel.fromJson)
            .toList(growable: false);
      }

      if (decoded is! Map<String, dynamic>) return const [];

      final items = decoded['items'];
      if (items is! List) return const [];

      return items
          .whereType<Map<String, dynamic>>()
          .map(SheikhModel.fromJson)
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  bool isSheikhsFresh({
    Duration maxAge = const Duration(hours: 24),
  }) {
    return _isFresh(_sheikhsKey, maxAge);
  }

  bool _isFresh(String key, Duration maxAge) {
    final raw = preferences.getString(key);
    if (raw == null || raw.isEmpty) return false;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return false;

      final value = decoded[_cachedAtKey];
      if (value is! String) return false;

      final cachedAt = DateTime.tryParse(value);
      if (cachedAt == null) return false;

      return DateTime.now().toUtc().difference(cachedAt) <= maxAge;
    } catch (_) {
      return false;
    }
  }
}
