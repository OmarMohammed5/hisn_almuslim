// lib/features/reading_progress/data/datasource/reading_progress_local_data_source.dart

import '../models/reading_progress_model.dart';

abstract class ReadingProgressLocalDataSource {
  Future<void> saveProgress(ReadingProgressModel model);

  Future<ReadingProgressModel?> getProgress(int surahNumber);

  Future<Map<int, ReadingProgressModel>> getAllProgress();
}