import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


class HighlightData {
  final Color color;
  final int timestamp;

  HighlightData({required this.color, required this.timestamp});

  Map<String, dynamic> toJson() => {
    'color': color.value,
    'timestamp': timestamp,
  };

  factory HighlightData.fromJson(Map<String, dynamic> json) => HighlightData(
    color: Color(json['color'] as int),
    timestamp: json['timestamp'] as int,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is HighlightData &&
              runtimeType == other.runtimeType &&
              color == other.color &&
              timestamp == other.timestamp;

  @override
  int get hashCode => color.hashCode ^ timestamp.hashCode;
}

class AyahHighlightState extends Equatable {
  final Map<String, HighlightData> highlights;

  const AyahHighlightState({this.highlights = const {}});

  AyahHighlightState copyWith({Map<String, HighlightData>? highlights}) {
    return AyahHighlightState(
      highlights: highlights ?? this.highlights,
    );
  }

  Map<int, HighlightData> forSurah(int surahNumber) {
    final result = <int, HighlightData>{};
    final prefix = '${surahNumber}_';
    for (final entry in highlights.entries) {
      if (entry.key.startsWith(prefix)) {
        final ayah = int.tryParse(entry.key.substring(prefix.length));
        if (ayah != null) result[ayah] = entry.value;
      }
    }
    return result;
  }

  @override
  List<Object?> get props => [highlights];
}