import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/dependency_injection.dart' as di;
import '../datasource/ayah_highlight_data_source.dart';
import 'ayah_highlight_state.dart';

class AyahHighlightCubit extends Cubit<AyahHighlightState> {
  final AyahHighlightLocalDataSource _localDataSource;

  AyahHighlightCubit({AyahHighlightLocalDataSource? localDataSource})
      : _localDataSource =
      localDataSource ?? di.sl<AyahHighlightLocalDataSource>(),
        super(const AyahHighlightState());

  String _key(int surah, int ayah) => '${surah}_$ayah';

  Future<void> loadAll() async {
    final raw = await _localDataSource.getAllHighlights();
    final mapped = raw.map((key, value) => MapEntry(key, HighlightData(
      color: Color(value['color'] as int),
      timestamp: value['timestamp'] as int,
    )));
    emit(state.copyWith(highlights: mapped));
  }

  // Future<void> setHighlight(int surahNumber, int ayahNumber, Color color) async {
  //   final timestamp = DateTime.now().millisecondsSinceEpoch;
  //   final updated = Map<String, HighlightData>.from(state.highlights)
  //     ..[_key(surahNumber, ayahNumber)] = HighlightData(
  //       color: color,
  //       timestamp: timestamp,
  //     );
  //   emit(state.copyWith(highlights: updated));
  //   await _localDataSource.setHighlight(surahNumber, ayahNumber, color.value, timestamp);
  // }

  Future<void> setHighlight(int surahNumber, int ayahNumber, Color color) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final key = _key(surahNumber, ayahNumber);

    // خد الـ highlights الحالية
    final currentHighlights = Map<String, HighlightData>.from(state.highlights);

    // ضيف الـ highlight الجديد
    currentHighlights[key] = HighlightData(
      color: color,
      timestamp: timestamp,
    );

    // اعمل emit للـ state الجديد
    emit(state.copyWith(highlights: currentHighlights));

    // احفظ في الداتا بيز
    await _localDataSource.setHighlight(surahNumber, ayahNumber, color.value, timestamp);
  }

  Future<void> removeHighlight(int surahNumber, int ayahNumber) async {
    final updated = Map<String, HighlightData>.from(state.highlights)
      ..remove(_key(surahNumber, ayahNumber));
    emit(state.copyWith(highlights: updated));
    await _localDataSource.removeHighlight(surahNumber, ayahNumber);
  }
}


