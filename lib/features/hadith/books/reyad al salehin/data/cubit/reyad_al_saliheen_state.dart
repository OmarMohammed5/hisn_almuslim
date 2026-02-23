part of 'reyad_al_saliheen_cubit.dart';

class ReyadAlSaliheenState {
  const ReyadAlSaliheenState();
}

final class ReyadAlSaliheenInitial extends ReyadAlSaliheenState {}

final class ReyadAlSaliheenLoading extends ReyadAlSaliheenState {}

final class ReyadAlSaliheenLoaded extends ReyadAlSaliheenState {
  final List<ChapterReyadAlSaliheen> hadiths;
  ReyadAlSaliheenLoaded(this.hadiths);
}

final class ReyadAlSaliheenError extends ReyadAlSaliheenState {
  final String message;
  ReyadAlSaliheenError(this.message);
}
