part of 'last_ten_duas_cubit.dart';

class LastTenDuasState {}

final class LastTenDuasInitial extends LastTenDuasState {}

final class LastTenDuasLoading extends LastTenDuasState {}

final class LastTenDuasLoaded extends LastTenDuasState {
  final List<DuaModel> duas;

  LastTenDuasLoaded(this.duas);
}

final class LastTenDuasError extends LastTenDuasState {
  final String message;

  LastTenDuasError(this.message);
}
