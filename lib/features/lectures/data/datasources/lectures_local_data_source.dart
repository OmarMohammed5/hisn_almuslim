import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/lecture_model.dart';
import '../models/sheikh_model.dart';

class LecturesLocalDataSource {
  final SharedPreferences preferences;

  const LecturesLocalDataSource(this.preferences);

  static const _latestKey = 'lectures_latest_cache_v1';
  static const _sheikhsKey = 'lectures_sheikhs_cache_v1';

  Future<void> cacheLatest(
      List<LectureModel> lectures,
      ) async {
    await preferences.setString(
      _latestKey,
      jsonEncode(
        lectures.map((e) => e.toJson()).toList(),
      ),
    );
  }

  List<LectureModel> getCachedLatest() {
    final raw = preferences.getString(_latestKey);

    if (raw == null || raw.isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(LectureModel.fromJson)
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  Future<void> cacheSheikhs(
      List<SheikhModel> sheikhs,
      ) async {
    await preferences.setString(
      _sheikhsKey,
      jsonEncode(
        sheikhs.map((e) => e.toJson()).toList(),
      ),
    );
  }

  List<SheikhModel> getCachedSheikhs() {
    final raw = preferences.getString(_sheikhsKey);

    if (raw == null || raw.isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(SheikhModel.fromJson)
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }
}
