part of 'asma_allah_cubit.dart';

@immutable
sealed class AsmaAllahState {}

final class AsmaAllahInitial extends AsmaAllahState {}

final class AsmaAllahLoading extends AsmaAllahState {}

final class AsmaAllahLoaded extends AsmaAllahState {
  final List<AsmaAllahModel> names;

  AsmaAllahLoaded(this.names);
}

final class AsmaAllahError extends AsmaAllahState {
  final String message;
  AsmaAllahError(this.message);
}
