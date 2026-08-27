import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class QuizProgressLocalDataSource {
  static const String _progressKey = 'islamic_quiz_progress';

  final SharedPreferencesAsync preferences;

  QuizProgressLocalDataSource({required this.preferences});

  Future<Map<String, dynamic>> getProgress() async {
    final value = await preferences.getString(_progressKey);

    if (value == null || value.isEmpty) {
      return {};
    }

    return jsonDecode(value) as Map<String, dynamic>;
  }

  Future<void> saveLevelResult({
    required String topicSlug,
    required int levelNumber,
    required int score,
    required int stars,
    required bool passed,
  }) async {
    final progress = await getProgress();

    final topicProgress = Map<String, dynamic>.from(
      progress[topicSlug] as Map? ?? {},
    );

    final levelKey = 'level_$levelNumber';

    final oldLevel = Map<String, dynamic>.from(
      topicProgress[levelKey] as Map? ?? {},
    );

    final oldBestScore = (oldLevel['bestScore'] as num?)?.toInt() ?? 0;

    final oldStars = (oldLevel['stars'] as num?)?.toInt() ?? 0;

    topicProgress[levelKey] = {
      'bestScore': score > oldBestScore ? score : oldBestScore,
      'stars': stars > oldStars ? stars : oldStars,
      'passed': (oldLevel['passed'] == true) || passed,
    };

    progress[topicSlug] = topicProgress;

    await preferences.setString(_progressKey, jsonEncode(progress));
  }

  Future<Map<String, dynamic>?> getLevelProgress({
    required String topicSlug,
    required int levelNumber,
  }) async {
    final progress = await getProgress();

    final topicProgress = Map<String, dynamic>.from(
      progress[topicSlug] as Map? ?? {},
    );

    final levelProgress = topicProgress['level_$levelNumber'];

    if (levelProgress == null) {
      return null;
    }

    return Map<String, dynamic>.from(levelProgress as Map);
  }
}
