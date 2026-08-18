// // lib/features/ayah_highlight/data/datasource/ayah_highlight_local_data_source.dart
//
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AyahHighlightLocalDataSource {
//   static const String _storageKey = 'ayah_highlights_v1';
//
//   final SharedPreferences _prefs;
//
//   AyahHighlightLocalDataSource(this._prefs);
//
//   Map<String, dynamic> _readRaw() {
//     final raw = _prefs.getString(_storageKey);
//     if (raw == null || raw.isEmpty) return {};
//     try {
//       return json.decode(raw) as Map<String, dynamic>;
//     } catch (_) {
//       return {};
//     }
//   }
//
//   Future<void> _writeRaw(Map<String, dynamic> data) async {
//     await _prefs.setString(_storageKey, json.encode(data));
//   }
//
//   String _key(int surah, int ayah) => '${surah}_$ayah';
//
//   Future<void> setHighlight(
//       int surah,
//       int ayah,
//       int colorValue,
//       DateTime timestamp,
//       ) async {
//     final data = _readRaw();
//     data[_key(surah, ayah)] = {
//       'color': colorValue,
//       'timestamp': timestamp.toIso8601String(),
//     };
//     await _writeRaw(data);
//   }
//
//   Future<void> removeHighlight(int surah, int ayah) async {
//     final data = _readRaw();
//     data.remove(_key(surah, ayah));
//     await _writeRaw(data);
//   }
//
//   /// Returns raw entries: key -> {'color': int, 'timestamp': String}
//   Future<Map<String, Map<String, dynamic>>> getAllHighlights() async {
//     final raw = _readRaw();
//     return raw.map(
//           (key, value) => MapEntry(key, Map<String, dynamic>.from(value as Map)),
//     );
//   }
// }



// lib/features/ayah_highlight/data/datasource/ayah_highlight_local_data_source.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AyahHighlightLocalDataSource {
  static const String _storageKey = 'ayah_highlights_v2';

  final SharedPreferences _prefs;

  AyahHighlightLocalDataSource(this._prefs);

  Map<String, Map<String, dynamic>> _readRaw() {
    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = json.decode(raw) as Map;
      return decoded.map((key, value) => MapEntry(
        key as String,
        (value as Map).map((k, v) => MapEntry(k as String, v)),
      ));
    } catch (_) {
      return {};
    }
  }

  Future<void> _writeRaw(Map<String, Map<String, dynamic>> data) async {
    await _prefs.setString(_storageKey, json.encode(data));
  }

  String _key(int surah, int ayah) => '${surah}_$ayah';

  Future<void> setHighlight(int surah, int ayah, int colorValue, int timestamp) async {
    final data = _readRaw();
    data[_key(surah, ayah)] = {
      'color': colorValue,
      'timestamp': timestamp,
    };
    await _writeRaw(data);
  }

  Future<void> removeHighlight(int surah, int ayah) async {
    final data = _readRaw();
    data.remove(_key(surah, ayah));
    await _writeRaw(data);
  }

  Future<Map<String, Map<String, dynamic>>> getAllHighlights() async => _readRaw();
}