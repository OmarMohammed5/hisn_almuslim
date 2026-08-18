// lib/features/reading_progress/data/models/reading_progress_model.dart

class ReadingProgressModel {
  final int surahNumber;
  final int lastReadPage;
  final int lastReadAyahNumber;
  final double progressPercentage;
  final DateTime lastReadTimestamp;

  const ReadingProgressModel({
    required this.surahNumber,
    required this.lastReadPage,
    required this.lastReadAyahNumber,
    required this.progressPercentage,
    required this.lastReadTimestamp,
  });

  factory ReadingProgressModel.fromJson(Map<String, dynamic> json) {
    return ReadingProgressModel(
      surahNumber: json['surahNumber'] as int? ?? 0,
      lastReadPage: json['lastReadPage'] as int? ?? 0,
      lastReadAyahNumber: json['lastReadAyahNumber'] as int? ?? 1,
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
      lastReadTimestamp: DateTime.tryParse(json['lastReadTimestamp'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'lastReadPage': lastReadPage,
      'lastReadAyahNumber': lastReadAyahNumber,
      'progressPercentage': progressPercentage,
      'lastReadTimestamp': lastReadTimestamp.toIso8601String(),
    };
  }
}