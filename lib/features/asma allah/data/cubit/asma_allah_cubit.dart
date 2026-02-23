import 'package:bloc/bloc.dart';
import 'package:hisn_almuslim/features/asma%20allah/data/model/asma_allah_model.dart';
import 'package:hisn_almuslim/features/asma%20allah/data/repo/asma_repositiry.dart';
import 'package:meta/meta.dart';

part 'asma_allah_state.dart';

class AsmaAllahCubit extends Cubit<AsmaAllahState> {
  AsmaAllahCubit(this._asmaRepository) : super(AsmaAllahInitial());

  final AsmaRepository _asmaRepository;

  Future<void> loadNames() async {
    emit(AsmaAllahLoading());
    try {
      final names = await _asmaRepository.loadNames();
      emit(AsmaAllahLoaded(names));
    } catch (e) {
      emit(AsmaAllahError(e.toString()));
    }
  }
}
