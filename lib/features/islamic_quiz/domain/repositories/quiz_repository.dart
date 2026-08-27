import 'package:hisn_almuslim/features/islamic_quiz/domain/entities/quiz_database_entity.dart';

abstract class QuizRepository {
  Future<QuizDatabaseEntity> getQuizDatabase();
}