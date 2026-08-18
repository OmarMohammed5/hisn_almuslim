// lib/features/quran/data/cubit/ayah_highlight_state.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AyahHighlightEntry extends Equatable {
  final Color color;
  final DateTime timestamp;

  const AyahHighlightEntry({required this.color, required this.timestamp});

  @override
  List<Object?> get props => [color, timestamp];
}

class AyahHighlightState extends Equatable {
  /// Key format: "surahNumber_ayahNumberInSurah"
  final Map<String, AyahHighlightEntry> highlights;

  const AyahHighlightState({this.highlights = const {}});

  AyahHighlightState copyWith({Map<String, AyahHighlightEntry>? highlights}) {
    return AyahHighlightState(highlights: highlights ?? this.highlights);
  }

  /// Color-only view for one Surah — exactly what MushafPageBlock expects.
  Map<int, Color> forSurah(int surahNumber) {
    final result = <int, Color>{};
    final prefix = '${surahNumber}_';
    for (final entry in highlights.entries) {
      if (entry.key.startsWith(prefix)) {
        final ayah = int.tryParse(entry.key.substring(prefix.length));
        if (ayah != null) result[ayah] = entry.value.color;
      }
    }
    return result;
  }

  /// numberInSurah of the most recently CREATED highlight in this Surah,
  /// or null if the Surah has no highlights. This drives the "resume from
  /// latest highlight" behavior in the reader.
  int? latestHighlightedAyah(int surahNumber) {
    final prefix = '${surahNumber}_';
    int? latestAyah;
    DateTime? latestTime;

    for (final entry in highlights.entries) {
      if (!entry.key.startsWith(prefix)) continue;
      final ayah = int.tryParse(entry.key.substring(prefix.length));
      if (ayah == null) continue;

      final ts = entry.value.timestamp;
      if (latestTime == null || ts.isAfter(latestTime)) {
        latestTime = ts;
        latestAyah = ayah;
      }
    }

    return latestAyah;
  }

  @override
  List<Object?> get props => [highlights];
}