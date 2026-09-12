import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/hadith_book.dart';
import '../../domain/repositories/hadith_repository.dart';
import 'hadith_state.dart';

class HadithCubit extends Cubit<HadithState> {
  final HadithRepository repository;

  HadithCubit({required this.repository}) : super(HadithInitial());

  Future<void> loadBook(HadithBookType book) async {
    emit(HadithLoading());

    try {
      final data = await repository.getBook(book);
      emit(HadithLoaded(data));
    } catch (e) {
      emit(HadithError(HadithBook.fromType(book).errorMessage(e)));
    }
  }
}
