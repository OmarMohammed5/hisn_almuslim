import 'package:dartz/dartz.dart';
import '../../data/repositories/stories_repository.dart';
import '../entities/prophet_story.dart';

class GetProphetStories {
  final StoriesRepository repository;

  GetProphetStories({required this.repository});

  Future<Either<String, List<ProphetStory>>> call() {
    return repository.getStories();
  }
}