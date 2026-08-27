import 'question_entity.dart';

class LevelEntity {
  final int levelNumber;
  final List<QuestionEntity> questions;

  const LevelEntity({
    required this.levelNumber,
    required this.questions,
  });
}