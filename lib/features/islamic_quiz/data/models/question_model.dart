import '../../domain/entities/question_entity.dart';
import 'answer_model.dart';

class QuestionModel {
  final int id;
  final String question;
  final String sourceLink;
  final List<AnswerModel> answers;

  const QuestionModel({
    required this.id,
    required this.question,
    required this.sourceLink,
    required this.answers,
  });

  static QuestionModel? fromJson(Map<String, dynamic> json) {
    // Validate question
    final question = json['q'];

    if (question is! String || question.trim().isEmpty) {
      return null;
    }

    // Validate answers
    final rawAnswers = json['answers'];

    if (rawAnswers is! List) {
      return null;
    }

    // Get only valid answers
    final validAnswers = rawAnswers
        .whereType<Map<String, dynamic>>()
        .where((answer) {
          final answerText = answer['answer'];

          return answerText is String && answerText.trim().isNotEmpty;
        })
        .map((answer) => AnswerModel.fromJson(answer))
        .toList();

    // Our quiz requires exactly 3 answers
    if (validAnswers.length != 3) {
      return null;
    }

    // There must be exactly one correct answer
    final correctAnswers = validAnswers
        .where((answer) => answer.isCorrect)
        .length;

    if (correctAnswers != 1) {
      return null;
    }

    return QuestionModel(
      id: json['id'] as int,
      question: question,
      sourceLink: json['link'] as String? ?? '',
      answers: validAnswers,
    );
  }

  QuestionEntity toEntity() {
    return QuestionEntity(
      id: id,
      question: question,
      link: sourceLink,
      answers: answers.map((answer) => answer.toEntity()).toList(),
    );
  }
}
