part of 'hajj_dua_cubit.dart';

class HajjDuaState {}

final class HajjDuaInitial extends HajjDuaState {}

final class HajjDuaLoading extends HajjDuaState {}

final class HajjDuaLoaded extends HajjDuaState {
  final List<HajjChapter> items;

  HajjDuaLoaded(this.items);
}

final class HajjDuaError extends HajjDuaState {
  final String message;

  HajjDuaError(this.message);
}
