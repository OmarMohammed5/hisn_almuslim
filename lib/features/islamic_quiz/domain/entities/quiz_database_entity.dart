import 'main_category_entity.dart';

class QuizDatabaseEntity {
  final String description;
  final List<MainCategoryEntity> categories;

  const QuizDatabaseEntity({
    required this.description,
    required this.categories,
  });
}