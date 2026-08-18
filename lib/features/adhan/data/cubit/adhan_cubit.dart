import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hisn_almuslim/core/service/location_service.dart';
import 'package:hisn_almuslim/features/adhan/data/models/prayer_time_model.dart';
part 'adhan_state.dart';

class AdhanCubit extends Cubit<AdhanState> {
  AdhanCubit() : super(AdhanInitial());

  Timer? _timer;
  Coordinates? _coordinates;
  final CalculationParameters _params =
  CalculationMethod.egyptian.getParameters()..madhab = Madhab.shafi;

  Future<void> loadPrayerTimes() async {
    emit(AdhanLoading());
    try {
      final coords = await LocationService.getCoordinates();
      _coordinates = Coordinates(coords.lat, coords.lng);

      final today = DateTime.now();
      final prayerData = PrayerTimes(
        _coordinates!,
        DateComponents.from(today),
        _params,
      );

      final prayers = [
        PrayerTimeModel(name: 'الفجر', time: prayerData.fajr),
        PrayerTimeModel(name: 'الشروق', time: prayerData.sunrise),
        PrayerTimeModel(name: 'الظهر', time: prayerData.dhuhr),
        PrayerTimeModel(name: 'العصر', time: prayerData.asr),
        PrayerTimeModel(name: 'المغرب', time: prayerData.maghrib),
        PrayerTimeModel(name: 'العشاء', time: prayerData.isha),
      ];

      _startTimer(prayers);
    } on LocationServiceDisabledException {
      emit(AdhanError(
        'خدمة الموقع (GPS) مقفولة، فعّلها عشان نظبطلك المواقيت',
        type: AdhanErrorType.serviceDisabled,
      ));
    } on PermissionDeniedException catch (e) {
      final foreverDenied = e.message?.contains('دائم') ?? false;
      emit(AdhanError(
        e.message ?? 'تم رفض إذن الموقع',
        type: foreverDenied
            ? AdhanErrorType.permissionDeniedForever
            : AdhanErrorType.permissionDenied,
      ));
    } catch (e) {
      emit(AdhanError(e.toString(), type: AdhanErrorType.unknown));
    }
  }

  void _startTimer(List<PrayerTimeModel> prayers) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final currentPrayer = _getCurrentPrayer(prayers, now);

      PrayerTimeModel? nextPrayer;
      for (final prayer in prayers) {
        if (prayer.time.isAfter(now)) {
          nextPrayer = prayer;
          break;
        }
      }

      if (nextPrayer == null && _coordinates != null) {
        final tomorrow = now.add(const Duration(days: 1));
        final tomorrowTimes = PrayerTimes(
          _coordinates!,
          DateComponents.from(tomorrow),
          _params,
        );
        nextPrayer = PrayerTimeModel(name: 'الفجر', time: tomorrowTimes.fajr);
      }

      if (nextPrayer == null) return;

      emit(
        AdhanLoaded(
          prayerTimes: prayers,
          currentPrayer: currentPrayer,
          nextPrayer: nextPrayer,
          remainingTime: nextPrayer.time.difference(now),
        ),
      );
    });
  }

  PrayerTimeModel _getCurrentPrayer(
      List<PrayerTimeModel> prayers,
      DateTime now,
      ) {
    for (int i = prayers.length - 1; i >= 0; i--) {
      if (prayers[i].time.isBefore(now)) {
        return prayers[i];
      }
    }
    return prayers.first;
  }

  Future<void> refreshLocation() => loadPrayerTimes();

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
