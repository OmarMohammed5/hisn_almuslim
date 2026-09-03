import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/adhan_settings.dart';

class AdhanSettingsStore {
  static const _key = 'adhan_alarm_settings_v1';

  Future<AdhanSettings> load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_key);
    if (raw == null) return const AdhanSettings();
    try {
      return AdhanSettings.fromJson(jsonDecode(raw));
    } catch (_) {
      return const AdhanSettings();
    }
  }

  Future<void> save(AdhanSettings s) async {
    (await SharedPreferences.getInstance()).setString(
      _key,
      jsonEncode(s.toJson()),
    );
  }
}
