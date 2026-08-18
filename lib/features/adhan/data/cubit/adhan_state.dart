part of 'adhan_cubit.dart';

abstract class AdhanState {}

class AdhanInitial extends AdhanState {}

class AdhanLoading extends AdhanState {}

class AdhanLoaded extends AdhanState {
  final List<PrayerTimeModel> prayerTimes;
  final PrayerTimeModel currentPrayer;
  final PrayerTimeModel nextPrayer;
  final Duration remainingTime;
  AdhanLoaded({
    required this.prayerTimes,
    required this.currentPrayer,
    required this.nextPrayer,
    required this.remainingTime,
  });
}

enum AdhanErrorType { serviceDisabled, permissionDenied, permissionDeniedForever, unknown }

class AdhanError extends AdhanState {
  final String message;
  final AdhanErrorType type;
  AdhanError(this.message, {this.type = AdhanErrorType.unknown});
}