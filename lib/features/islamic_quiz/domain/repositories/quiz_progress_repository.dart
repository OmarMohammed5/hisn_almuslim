abstract class QuizProgressRepository {
  Future<void> saveLevelResult({
    required String topicSlug,
    required int levelNumber,
    required int score,
    required int stars,
    required bool passed,
  });

  Future<Map<String, dynamic>?> getLevelProgress({
    required String topicSlug,
    required int levelNumber,
  });
}