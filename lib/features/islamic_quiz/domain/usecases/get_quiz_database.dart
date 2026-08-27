import 'package:hisn_almuslim/features/islamic_quiz/domain/entities/quiz_database_entity.dart';
import 'package:hisn_almuslim/features/islamic_quiz/domain/repositories/quiz_repository.dart';

class GetQuizDatabase {
  final QuizRepository repository;

  GetQuizDatabase({required this.repository});

  Future<QuizDatabaseEntity> call(){
    return repository.getQuizDatabase();
  }
}