part of 'etiquette_dua_cubit.dart';

class EtiquetteDuaState {
  const EtiquetteDuaState();
}

final class EtiquetteDuaInitial extends EtiquetteDuaState {}

final class EtiquetteDuaLoading extends EtiquetteDuaState {}

final class EtiquetteDuaLoaded extends EtiquetteDuaState {
  final List<EtiquetteItem> items;
  EtiquetteDuaLoaded(this.items);
}

final class EtiquetteDuaError extends EtiquetteDuaState {
  final String message;
  EtiquetteDuaError(this.message);
}
