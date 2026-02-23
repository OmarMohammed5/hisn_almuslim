part of 'dua_cubit.dart';

class DuaState {
  const DuaState();
}

final class DuaInitial extends DuaState {}

final class DuaLoading extends DuaState {}

final class DuaLoaded extends DuaState {
  final List<DuaChapter> duas;

  DuaLoaded(this.duas);
}

final class DuaError extends DuaState {
  final String message;

  DuaError(this.message);
}
