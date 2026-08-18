// lib/features/reading_progress/domain/entities/reading_progress_entity.dart

import 'package:equatable/equatable.dart';

class ReadingProgressEntity extends Equatable {
  final int surahNumber;
  final int lastReadPage;
  final int lastReadAyahNumber;
  final double progressPercentage;
  final DateTime lastReadTimestamp;

  const ReadingProgressEntity({
    required this.surahNumber,
    required this.lastReadPage,
    required this.lastReadAyahNumber,
    required this.progressPercentage,
    required this.lastReadTimestamp,
  });

  @override
  List<Object?> get props => [
    surahNumber,
    lastReadPage,
    lastReadAyahNumber,
    progressPercentage,
    lastReadTimestamp,
  ];
}