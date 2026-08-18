// lib/features/reading_progress/data/datasource/reading_progress_local_data_source_impl.dart

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/reading_progress_model.dart';
import 'reading_progress_local_data_source.dart';

class ReadingProgressLocalDataSourceImpl implements ReadingProgressLocalDataSource {
  static const String _storageKey = 'reading_progress_v1';

  final SharedPreferences _prefs;

  ReadingProgressLocalDataSourceImpl(this._prefs);

  Map<String, dynamic> _readRaw() {
    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      return json.decode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  Future<void> _writeRaw(Map<String, dynamic> data) async {
    await _prefs.setString(_storageKey, json.encode(data));
  }

  @override
  Future<void> saveProgress(ReadingProgressModel model) async {
    final data = _readRaw();
    data[model.surahNumber.toString()] = model.toJson();
    await _writeRaw(data);
  }

  @override
  Future<ReadingProgressModel?> getProgress(int surahNumber) async {
    final data = _readRaw();
    final entry = data[surahNumber.toString()];
    if (entry == null) return null;
    return ReadingProgressModel.fromJson(entry as Map<String, dynamic>);
  }

  @override
  Future<Map<int, ReadingProgressModel>> getAllProgress() async {
    final data = _readRaw();
    final result = <int, ReadingProgressModel>{};
    for (final entry in data.entries) {
      final surahNumber = int.tryParse(entry.key);
      if (surahNumber == null) continue;
      result[surahNumber] = ReadingProgressModel.fromJson(entry.value as Map<String, dynamic>);
    }
    return result;
  }
}