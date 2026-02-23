import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:bloc/bloc.dart';
import 'package:hisn_almuslim/features/adhan/data/models/prayer_time_model.dart';

part 'adhan_state.dart';

class AdhanCubit extends Cubit<AdhanState> {
  AdhanCubit() : super(AdhanInitial());

  Timer? _timer;

  final Coordinates _coordinates = Coordinates(30.0444, 31.2357); // Cairo
  final CalculationParameters _params =
      CalculationMethod.egyptian.getParameters()..madhab = Madhab.shafi;

  void loadPrayerTimes() {
    emit(AdhanLoading());

    final today = DateTime.now();
    final prayerData = PrayerTimes(
      _coordinates,
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
  }

  void _startTimer(List<PrayerTimeModel> prayers) {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();

      /// الصلاة الحالية
      final currentPrayer = _getCurrentPrayer(prayers, now);

      /// الصلاة القادمة
      PrayerTimeModel? nextPrayer;
      for (final prayer in prayers) {
        if (prayer.time.isAfter(now)) {
          nextPrayer = prayer;
          break;
        }
      }

      /// لو مفيش صلاة جاية (بعد العشاء) → فجر بكرة
      if (nextPrayer == null) {
        final tomorrow = now.add(const Duration(days: 1));
        final tomorrowTimes = PrayerTimes(
          _coordinates,
          DateComponents.from(tomorrow),
          _params,
        );

        nextPrayer = PrayerTimeModel(name: 'الفجر', time: tomorrowTimes.fajr);
      }

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
    return prayers.first; // قبل الفجر
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
