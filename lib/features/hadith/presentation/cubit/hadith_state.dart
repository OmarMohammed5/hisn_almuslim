import '../../domain/entities/hadith_entity.dart';

sealed class HadithState {
  const HadithState();
}

final class HadithInitial extends HadithState {}

final class HadithLoading extends HadithState {}

final class HadithLoaded extends HadithState {
  final HadithBookData data;

  const HadithLoaded(this.data);
}

final class HadithError extends HadithState {
  final String message;

  const HadithError(this.message);
}
