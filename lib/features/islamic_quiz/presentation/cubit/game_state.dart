import '../../domain/entities/question_entity.dart';

enum QuizGameStatus { initial, playing, answered, completed, error }

class QuizGameState {
  final QuizGameStatus status;
  final List<QuestionEntity> questions;
  final int currentIndex;
  final int correctAnswers;
  final int wrongAnswers;
  final int? selectedAnswerIndex;
  final bool? isAnswerCorrect;
  final int score;
  final int stars;
  final bool passed;
  final String? errorMessage;

  const QuizGameState({
    required this.status,
    this.questions = const [],
    this.currentIndex = 0,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.selectedAnswerIndex,
    this.isAnswerCorrect,
    this.score = 0,
    this.stars = 0,
    this.passed = false,
    this.errorMessage,
  });

  QuestionEntity? get currentQuestion {
    if (questions.isEmpty || currentIndex >= questions.length) {
      return null;
    }

    return questions[currentIndex];
  }

  double get progress {
    if (questions.isEmpty) return 0;

    return (currentIndex + 1) / questions.length;
  }

  QuizGameState copyWith({
    QuizGameStatus? status,
    List<QuestionEntity>? questions,
    int? currentIndex,
    int? correctAnswers,
    int? wrongAnswers,
    int? selectedAnswerIndex,
    bool clearSelectedAnswer = false,
    bool? isAnswerCorrect,
    bool clearAnswerResult = false,
    int? score,
    int? stars,
    bool? passed,
    String? errorMessage,
  }) {
    return QuizGameState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      selectedAnswerIndex: clearSelectedAnswer
          ? null
          : selectedAnswerIndex ?? this.selectedAnswerIndex,
      isAnswerCorrect: clearAnswerResult
          ? null
          : isAnswerCorrect ?? this.isAnswerCorrect,
      score: score ?? this.score,
      stars: stars ?? this.stars,
      passed: passed ?? this.passed,
      errorMessage: errorMessage,
    );
  }
}
