import 'package:dartz/dartz.dart';
import 'package:hisn_almuslim/features/stories/data/repositories/stories_repository.dart';
import '../../domain/entities/prophet_story.dart';
import '../datasources/stories_local_data_source.dart';

class StoriesRepositoryImpl implements StoriesRepository {
  final StoriesLocalDataSource localDataSource;

  StoriesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<String, List<ProphetStory>>> getStories() async {
    try {
      final models = await localDataSource.getStories();
      final stories = models.map((model) => model.toDomain()).toList();
      return Right(stories);
    } catch (e) {
      return Left(e.toString());
    }
  }
}