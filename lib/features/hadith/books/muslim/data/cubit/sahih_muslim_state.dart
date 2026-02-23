part of 'sahih_muslim_cubit.dart';

class SahihMuslimState {
  const SahihMuslimState();
}

final class SahihMuslimInitial extends SahihMuslimState {}

final class SahihMuslimLoading extends SahihMuslimState {}

final class SahihMuslimLoaded extends SahihMuslimState {
  final List<ChapterSahihMuslim> hadiths;
  SahihMuslimLoaded(this.hadiths);
}

final class SahihMuslimError extends SahihMuslimState {
  final String message;
  SahihMuslimError(this.message);
}
