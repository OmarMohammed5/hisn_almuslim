// lib/features/reading_progress/data/cubit/reading_progress_cubit.dart

import 'package:bloc/bloc.dart';

import '../../../../core/di/dependency_injection.dart' as di;
import '../../domain/entities/reading_progress_entity.dart';
import '../../domain/repositories/reading_progress_repository.dart';
import 'reading_progress_state.dart';

class ReadingProgressCubit extends Cubit<ReadingProgressState> {
  final ReadingProgressRepository _repository;

  ReadingProgressCubit({ReadingProgressRepository? repository})
      : _repository = repository ?? di.sl<ReadingProgressRepository>(),
        super(const ReadingProgressState());

  Future<void> loadAllProgress() async {
    final all = await _repository.getAllProgress();
    emit(state.copyWith(progressBySurah: all));
  }

  ReadingProgressEntity? progressFor(int surahNumber) =>
      state.progressBySurah[surahNumber];

  Future<void> updateProgress({
    required int surahNumber,
    required int page,
    required int ayahNumber,
    required int totalAyahsInSurah,
  }) async {
    if (totalAyahsInSurah <= 0) return;

    final percentage = (ayahNumber / totalAyahsInSurah).clamp(0.0, 1.0);
    final entity = ReadingProgressEntity(
      surahNumber: surahNumber,
      lastReadPage: page,
      lastReadAyahNumber: ayahNumber,
      progressPercentage: percentage,
      lastReadTimestamp: DateTime.now(),
    );

    final existing = state.progressBySurah[surahNumber];
    if (existing != null &&
        existing.lastReadAyahNumber == ayahNumber &&
        existing.lastReadPage == page) {
      return; // No-op: avoid redundant writes/emits for the same position.
    }

    final updatedMap = Map<int, ReadingProgressEntity>.from(state.progressBySurah)
      ..[surahNumber] = entity;
    emit(state.copyWith(progressBySurah: updatedMap));

    await _repository.saveProgress(entity);
  }
}