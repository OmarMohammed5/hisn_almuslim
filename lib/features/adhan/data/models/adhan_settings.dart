class AdhanSettings {
  final bool enabled;
  final String reciter;
  final bool fajr;
  final bool dhuhr;
  final bool asr;
  final bool maghrib;
  final bool isha;
  final bool sunrise;

  const AdhanSettings({
    this.enabled = false,
    this.reciter = 'mishary',
    this.fajr = true,
    this.dhuhr = true,
    this.asr = true,
    this.maghrib = true,
    this.isha = true,
    this.sunrise = true,
  });

  AdhanSettings copyWith({bool? enabled, String? reciter, bool? fajr, bool? dhuhr, bool? asr, bool? maghrib, bool? isha, bool? sunrise}) => AdhanSettings(
    enabled: enabled ?? this.enabled, reciter: reciter ?? this.reciter,
    fajr: fajr ?? this.fajr, dhuhr: dhuhr ?? this.dhuhr, asr: asr ?? this.asr,
    maghrib: maghrib ?? this.maghrib, isha: isha ?? this.isha, sunrise: sunrise ?? this.sunrise,
  );

  Map<String, dynamic> toJson() => {'enabled':enabled,'reciter':reciter,'fajr':fajr,'dhuhr':dhuhr,'asr':asr,'maghrib':maghrib,'isha':isha,'sunrise':sunrise};
  factory AdhanSettings.fromJson(Map<String,dynamic> j) => AdhanSettings(
    enabled:j['enabled']??false, reciter:j['reciter']??'mishary', fajr:j['fajr']??true,
    dhuhr:j['dhuhr']??true, asr:j['asr']??true, maghrib:j['maghrib']??true,
    isha:j['isha']??true, sunrise:j['sunrise']??true,
  );
}
