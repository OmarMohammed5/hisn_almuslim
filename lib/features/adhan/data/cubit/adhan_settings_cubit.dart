import 'package:bloc/bloc.dart';
import '../../services/adhan_alarm_scheduler.dart';
import '../../services/adhan_settings_store.dart';
import '../models/adhan_settings.dart';

class AdhanSettingsState {
  final AdhanSettings settings;
  final bool loading;
  final String? message;

  const AdhanSettingsState(this.settings, {this.loading = false, this.message});
}

class AdhanSettingsCubit extends Cubit<AdhanSettingsState> {
  AdhanSettingsCubit()
    : super(const AdhanSettingsState(AdhanSettings(), loading: true)) {
    load();
  }

  final _store = AdhanSettingsStore();
  final _scheduler = AdhanAlarmScheduler.instance;

  Future<void> load() async {
    final s = await _store.load();
    emit(AdhanSettingsState(s));
  }

  Future<void> update(AdhanSettings s) async {
    emit(AdhanSettingsState(s, loading: true));
    try {
      if (s.enabled) {
        final ok = await _scheduler.requestPermissions();
        if (!ok) {
          emit(
            AdhanSettingsState(
              s.copyWith(enabled: false),
              message: 'يلزم السماح بالإشعارات والمنبهات الدقيقة',
            ),
          );
          return;
        }
      }
      await _store.save(s);
      await _scheduler.reschedule(s);
      emit(AdhanSettingsState(s, message: 'تم حفظ إعدادات الأذان'));
    } catch (e) {
      emit(
        AdhanSettingsState(
          s.copyWith(enabled: false),
          message: 'تعذر جدولة الأذان: $e',
        ),
      );
    }
  }
}
