import 'package:hisn_almuslim/features/islamic_quiz/data/datasources/quiz_progress_local_data_source.dart';
import 'package:hisn_almuslim/features/islamic_quiz/domain/repositories/quiz_progress_repository.dart';

class QuizProgressRepositoryImpl implements QuizProgressRepository {
  final QuizProgressLocalDataSource localDataSource;

  QuizProgressRepositoryImpl({required this.localDataSource});

  @override
  Future<Map<String, dynamic>?> getLevelProgress({
    required String topicSlug,
    required int levelNumber,
  }) {
    return localDataSource.getLevelProgress(
      topicSlug: topicSlug,
      levelNumber: levelNumber,
    );
  }

  @override
  Future<void> saveLevelResult({
    required String topicSlug,
    required int levelNumber,
    required int score,
    required int stars,
    required bool passed,
  }) {
    return localDataSource.saveLevelResult(
      topicSlug: topicSlug,
      levelNumber: levelNumber,
      score: score,
      stars: stars,
      passed: passed,
    );
  }
}
