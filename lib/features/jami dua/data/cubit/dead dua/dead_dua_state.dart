part of 'dead_dua_cubit.dart';

class DeadDuaState {}

final class DeadDuaInitial extends DeadDuaState {}

final class DeadDuaLoading extends DeadDuaState {}

final class DeadDuaLoaded extends DeadDuaState {
  final List<DuaModel> duas;

  DeadDuaLoaded(this.duas);
}

final class DeadDuaError extends DeadDuaState {
  final String message;

  DeadDuaError(this.message);
}
