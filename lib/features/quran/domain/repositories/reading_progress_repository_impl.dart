// lib/features/reading_progress/data/repositories/reading_progress_repository_impl.dart

import '../../data/datasource/reading_progress_local_data_source.dart';
import '../../data/models/reading_progress_model.dart';
import '../../domain/entities/reading_progress_entity.dart';
import '../../domain/repositories/reading_progress_repository.dart';

class ReadingProgressRepositoryImpl implements ReadingProgressRepository {
  final ReadingProgressLocalDataSource _localDataSource;

  ReadingProgressRepositoryImpl({
    required ReadingProgressLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  ReadingProgressEntity _mapToEntity(ReadingProgressModel model) {
    return ReadingProgressEntity(
      surahNumber: model.surahNumber,
      lastReadPage: model.lastReadPage,
      lastReadAyahNumber: model.lastReadAyahNumber,
      progressPercentage: model.progressPercentage,
      lastReadTimestamp: model.lastReadTimestamp,
    );
  }

  ReadingProgressModel _mapToModel(ReadingProgressEntity entity) {
    return ReadingProgressModel(
      surahNumber: entity.surahNumber,
      lastReadPage: entity.lastReadPage,
      lastReadAyahNumber: entity.lastReadAyahNumber,
      progressPercentage: entity.progressPercentage,
      lastReadTimestamp: entity.lastReadTimestamp,
    );
  }

  @override
  Future<void> saveProgress(ReadingProgressEntity progress) {
    return _localDataSource.saveProgress(_mapToModel(progress));
  }

  @override
  Future<ReadingProgressEntity?> getProgress(int surahNumber) async {
    final model = await _localDataSource.getProgress(surahNumber);
    return model == null ? null : _mapToEntity(model);
  }

  @override
  Future<Map<int, ReadingProgressEntity>> getAllProgress() async {
    final models = await _localDataSource.getAllProgress();
    return models.map((key, value) => MapEntry(key, _mapToEntity(value)));
  }
}