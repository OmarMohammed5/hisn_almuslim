import 'package:dartz/dartz.dart';
import '../../domain/entities/prophet_story.dart';

abstract class StoriesRepository {
  Future<Either<String, List<ProphetStory>>> getStories();
}