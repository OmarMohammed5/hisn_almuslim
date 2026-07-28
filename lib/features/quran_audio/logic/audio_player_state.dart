import 'package:equatable/equatable.dart';
import 'package:hisn_almuslim/features/quran_audio/data/models/surah_audio_model.dart';

import '../data/models/reciter_model.dart';

abstract class AudioPlayerState extends Equatable {
  const AudioPlayerState();

  @override
  List<Object?> get props => [];
}

class AudioPlayerInitial extends AudioPlayerState {
  const AudioPlayerInitial();
}

class AudioPlayerLoading extends AudioPlayerState {
  final String? message;

  const AudioPlayerLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// Single state for the whole "player is set up" lifecycle.
/// isPlaying/isBuffering/isCompleted/currentPosition all update via copyWith —
/// never swap to a different class for playing/paused/completed.
class AudioPlayerReady extends AudioPlayerState {
  final SurahAudioModel surah;
  final ReciterModel reciter;
  final Duration totalDuration;
  final Duration currentPosition;
  final bool isPlaying;
  final bool isBuffering;
  final bool isCompleted;
  final double speed;

  const AudioPlayerReady({
    required this.surah,
    required this.reciter,
    required this.totalDuration,
    required this.currentPosition,
    this.isPlaying = false,
    this.isBuffering = false,
    this.isCompleted = false,
    this.speed = 1.0,
  });

  AudioPlayerReady copyWith({
    SurahAudioModel? surah,
    ReciterModel? reciter,
    Duration? totalDuration,
    Duration? currentPosition,
    bool? isPlaying,
    bool? isBuffering,
    bool? isCompleted,
    double? speed,
  }) {
    return AudioPlayerReady(
      surah: surah ?? this.surah,
      reciter: reciter ?? this.reciter,
      totalDuration: totalDuration ?? this.totalDuration,
      currentPosition: currentPosition ?? this.currentPosition,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      isCompleted: isCompleted ?? this.isCompleted,
      speed: speed ?? this.speed,
    );
  }

  @override
  List<Object?> get props => [
    surah,
    reciter,
    totalDuration,
    currentPosition,
    isPlaying,
    isBuffering,
    isCompleted,
    speed,
  ];
}

class AudioPlayerError extends AudioPlayerState {
  final String message;

  const AudioPlayerError(this.message);

  @override
  List<Object?> get props => [message];
}