import 'package:bloc/bloc.dart';

import '../../domain/entities/jami_dua_category.dart';
import '../../domain/repositories/jami_dua_repository.dart';
import 'jami_dua_state.dart';

class JamiDuaCubit extends Cubit<JamiDuaState> {
  final JamiDuaRepository repository;

  JamiDuaCubit({required this.repository}) : super(const JamiDuaInitial());

  Future<void> loadCategory(JamiDuaCategoryType type) async {
    try {
      emit(const JamiDuaLoading());

      final category = await repository.getCategory(type);

      if (isClosed) return;
      emit(JamiDuaLoaded(category));
    } catch (e) {
      if (isClosed) return;
      emit(JamiDuaError('Error : $e'));
    }
  }
}