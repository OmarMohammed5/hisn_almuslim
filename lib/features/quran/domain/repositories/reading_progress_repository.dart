// lib/features/reading_progress/domain/repositories/reading_progress_repository.dart

import '../entities/reading_progress_entity.dart';

abstract class ReadingProgressRepository {
  Future<void> saveProgress(ReadingProgressEntity progress);

  Future<ReadingProgressEntity?> getProgress(int surahNumber);

  Future<Map<int, ReadingProgressEntity>> getAllProgress();
}