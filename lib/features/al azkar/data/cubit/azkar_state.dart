part of 'azkar_cubit.dart';

@immutable
sealed class AzkarState {}

final class AzkarInitial extends AzkarState {}

final class AzkarLoading extends AzkarState {}

final class AzkarLoaded extends AzkarState {
  final List<Zekr> zekrList;

  AzkarLoaded(this.zekrList);
}

final class AzkarError extends AzkarState {
  final String errorMessage;

  AzkarError(this.errorMessage);
}
