part of 'hadith_cubit.dart';

class HadithState {
  const HadithState();
}

class HadithInitial extends HadithState {}

class HadithLoading extends HadithState {}

class HadithLoaded extends HadithState {
  final List<Hadith> hadithList;
  HadithLoaded(this.hadithList);
}

class HadithError extends HadithState {
  final String message;
  HadithError(this.message);
}
