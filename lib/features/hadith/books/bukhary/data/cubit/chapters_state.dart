part of 'chapters_cubit.dart';

class ChaptersState {
  const ChaptersState();
}

final class ChaptersInitial extends ChaptersState {}

final class ChaptersLoading extends ChaptersState {}

final class ChaptersLoaded extends ChaptersState {
  final List<Chapter> chapters;

  ChaptersLoaded(this.chapters);
}

final class ChaptersError extends ChaptersState {
  final String message;
  ChaptersError(this.message);
}
