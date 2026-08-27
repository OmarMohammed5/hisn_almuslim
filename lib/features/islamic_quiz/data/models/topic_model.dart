import '../../domain/entities/topic_entity.dart';
import 'level_model.dart';
import 'question_model.dart';

class TopicModel {
  final String name;
  final String slug;
  final List<LevelModel> levels;

  const TopicModel({
    required this.name,
    required this.slug,
    required this.levels,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    final levelsData = json['levelsData'] as Map<String, dynamic>;

    final levels = <LevelModel>[];

    levelsData.forEach((key, value) {
      final levelNumber = int.parse(key.replaceFirst('level', ''));

      final questions = (value as List)
          .whereType<Map<String, dynamic>>()
          .map(QuestionModel.fromJson)
          .whereType<QuestionModel>()
          .toList();

      levels.add(LevelModel(levelNumber: levelNumber, questions: questions));
    });

    levels.sort((a, b) => a.levelNumber.compareTo(b.levelNumber));

    return TopicModel(
      name: json['name'] as String,
      slug: json['slug'] as String,
      levels: levels,
    );
  }

  TopicEntity toEntity() {
    return TopicEntity(
      name: name,
      slug: slug,
      levels: levels.map((level) => level.toEntity()).toList(),
    );
  }
}
