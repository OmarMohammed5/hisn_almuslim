// lib/features/reading_progress/data/cubit/reading_progress_state.dart

import 'package:equatable/equatable.dart';

import '../../domain/entities/reading_progress_entity.dart';

class ReadingProgressState extends Equatable {
  final Map<int, ReadingProgressEntity> progressBySurah;

  const ReadingProgressState({this.progressBySurah = const {}});

  ReadingProgressState copyWith({Map<int, ReadingProgressEntity>? progressBySurah}) {
    return ReadingProgressState(
      progressBySurah: progressBySurah ?? this.progressBySurah,
    );
  }

  @override
  List<Object?> get props => [progressBySurah];
}