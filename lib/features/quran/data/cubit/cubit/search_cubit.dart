import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<String> {
  SearchCubit() : super('');

  void update(String value) => emit(value);

  void clear() => emit('');
}
