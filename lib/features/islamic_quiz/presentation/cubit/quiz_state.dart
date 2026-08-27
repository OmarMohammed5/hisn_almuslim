part of 'quiz_cubit.dart';

@immutable
sealed class QuizState {
  const QuizState();
}

final class QuizInitial extends QuizState {
  const QuizInitial();
}

final class QuizLoading extends QuizState {
  const QuizLoading();
}

final class QuizLoaded extends QuizState {
  final QuizDatabaseEntity database;

 const QuizLoaded(this.database);

}

final class QuizError extends QuizState {
  final String message;
 const  QuizError(this.message);
}
