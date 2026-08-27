import '../../domain/entities/quiz_database_entity.dart';
import 'main_category_model.dart';

class QuizDatabaseModel {
  final String description;
  final List<MainCategoryModel> categories;

  const QuizDatabaseModel({
    required this.description,
    required this.categories,
  });

  factory QuizDatabaseModel.fromJson(Map<String, dynamic> json) {
    return QuizDatabaseModel(
      description: json['description'] as String,
      categories: (json['mainCategories'] as List)
          .map(
            (category) =>
                MainCategoryModel.fromJson(category as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  QuizDatabaseEntity toEntity() {
    return QuizDatabaseEntity(
      description: description,
      categories: categories
          .map((category) => category.toEntity())
          .toList(),
    );
  }
}
