import 'package:hisn_almuslim/features/islamic_quiz/domain/entities/answer_entity.dart';

class QuestionEntity {
  final int id;
  final String question;
  final String link;
  final List<AnswerEntity> answers;

  QuestionEntity({
    required this.id,
    required this.question,
    required this.link,
    required this.answers,
  });
}
