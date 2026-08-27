import 'package:hisn_almuslim/features/islamic_quiz/domain/entities/answer_entity.dart';

class AnswerModel {
  final String answer;
  final bool isCorrect;

  const AnswerModel({required this.answer, required this.isCorrect});

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      answer: json['answer'] as String,
      isCorrect: json['t'] == 1,
    );
  }

  AnswerEntity toEntity() {
    return AnswerEntity(answer: answer, isCorrect: isCorrect);
  }
}
