import '../../domain/entities/jami_dua_category.dart';

sealed class JamiDuaState {
  const JamiDuaState();
}

final class JamiDuaInitial extends JamiDuaState {
  const JamiDuaInitial();
}

final class JamiDuaLoading extends JamiDuaState {
  const JamiDuaLoading();
}

final class JamiDuaLoaded extends JamiDuaState {
  final JamiDuaCategory category;

  const JamiDuaLoaded(this.category);
}

final class JamiDuaError extends JamiDuaState {
  final String message;

  const JamiDuaError(this.message);
}