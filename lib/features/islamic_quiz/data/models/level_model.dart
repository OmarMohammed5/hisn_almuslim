import 'package:hisn_almuslim/features/islamic_quiz/domain/entities/level_entity.dart';

import 'question_model.dart';

class LevelModel {
  final int levelNumber;
  final List<QuestionModel> questions;

  const LevelModel({required this.levelNumber, required this.questions});

  LevelEntity toEntity() {
    return LevelEntity(
        levelNumber: levelNumber,
        questions: questions.map((question)=> question.toEntity()).toList(),
    );
  }
}
