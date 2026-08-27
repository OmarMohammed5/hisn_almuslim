import 'package:hisn_almuslim/features/islamic_quiz/data/datasources/quiz_local_data_source.dart';
import 'package:hisn_almuslim/features/islamic_quiz/domain/entities/quiz_database_entity.dart';
import 'package:hisn_almuslim/features/islamic_quiz/domain/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository{
  final QuizLocalDataSource localDataSource;

  QuizRepositoryImpl({
  required this.localDataSource
  });

  @override
  Future<QuizDatabaseEntity> getQuizDatabase()async{
    final model = await localDataSource.loadQuizDatabase();

    return model.toEntity();
  }


}