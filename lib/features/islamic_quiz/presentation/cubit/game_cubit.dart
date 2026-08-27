import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/level_entity.dart';
import '../../domain/repositories/quiz_progress_repository.dart';
import 'game_state.dart';

class QuizGameCubit extends Cubit<QuizGameState> {
  final QuizProgressRepository progressRepository;

  QuizGameCubit({required this.progressRepository})
    : super(const QuizGameState(status: QuizGameStatus.initial));

  late String _topicSlug;
  late int _levelNumber;

  void startGame({required String topicSlug, required LevelEntity level}) {
    _topicSlug = topicSlug;
    _levelNumber = level.levelNumber;

    final questions = List.of(level.questions);

    emit(QuizGameState(status: QuizGameStatus.playing, questions: questions));
  }

  Future<void> selectAnswer(int answerIndex) async {
    if (state.status != QuizGameStatus.playing) {
      return;
    }

    if (state.selectedAnswerIndex != null) {
      return;
    }

    final question = state.currentQuestion;

    if (question == null) return;

    final selectedAnswer = question.answers[answerIndex];

    final isCorrect = selectedAnswer.isCorrect;

    if (isCorrect) {
      await HapticFeedback.selectionClick();
    } else {
      await HapticFeedback.heavyImpact();
    }

    emit(
      state.copyWith(
        status: QuizGameStatus.answered,
        selectedAnswerIndex: answerIndex,
        isAnswerCorrect: isCorrect,
        correctAnswers: isCorrect
            ? state.correctAnswers + 1
            : state.correctAnswers,
        wrongAnswers: isCorrect ? state.wrongAnswers : state.wrongAnswers + 1,
      ),
    );
  }

  Future<void> nextQuestion() async {
    if (state.status != QuizGameStatus.answered) {
      return;
    }

    final isLastQuestion = state.currentIndex == state.questions.length - 1;

    if (isLastQuestion) {
      await _completeGame();
      return;
    }

    emit(
      state.copyWith(
        status: QuizGameStatus.playing,
        currentIndex: state.currentIndex + 1,
        clearSelectedAnswer: true,
        clearAnswerResult: true,
      ),
    );
  }

  Future<void> _completeGame() async {
    final total = state.questions.length;

    final score = ((state.correctAnswers / total) * 100).round();

    final stars = _calculateStars(correct: state.correctAnswers, total: total);

    final passed = score >= 70;

    await progressRepository.saveLevelResult(
      topicSlug: _topicSlug,
      levelNumber: _levelNumber,
      score: score,
      stars: stars,
      passed: passed,
    );

    emit(
      state.copyWith(
        status: QuizGameStatus.completed,
        score: score,
        stars: stars,
        passed: passed,
      ),
    );
  }

  int _calculateStars({required int correct, required int total}) {
    final percentage = correct / total * 100;

    if (percentage >= 90) return 3;
    if (percentage >= 80) return 2;
    if (percentage >= 70) return 1;

    return 0;
  }

  void restart() {
    startGame(
      topicSlug: _topicSlug,
      level: LevelEntity(levelNumber: _levelNumber, questions: state.questions),
    );
  }
}
