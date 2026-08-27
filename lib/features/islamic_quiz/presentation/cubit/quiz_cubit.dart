import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:hisn_almuslim/features/islamic_quiz/domain/entities/quiz_database_entity.dart';
import 'package:hisn_almuslim/features/islamic_quiz/domain/usecases/get_quiz_database.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final GetQuizDatabase getQuizDatabase;

  QuizCubit({required this.getQuizDatabase}) : super(const QuizInitial());

  Future<void> loadQuizDatabase() async {
    emit(QuizLoading());
    try {
      final database = await getQuizDatabase();

      emit(QuizLoaded(database));
    } catch (e , stackTrace) {
      debugPrint('❌ Quiz Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(QuizError('حدث خطأ أثناء تحميل الأسئلة'));
    }
  }
}
