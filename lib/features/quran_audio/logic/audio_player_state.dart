import 'package:equatable/equatable.dart';
import 'package:hisn_almuslim/features/quran_audio/data/models/surah_audio_model.dart';
import '../data/models/reciter_model.dart';

enum CompletionMode {
  continueToNext,
  repeatCurrent,
  stopAfterCurrent,
  manual,
}

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

class AudioPlayerReady extends AudioPlayerState {
  final SurahAudioModel surah;
  final ReciterModel reciter;
  final Duration totalDuration;
  final Duration currentPosition;
  final bool isPlaying;
  final bool isBuffering;
  final bool isCompleted;
  final double speed;
  final CompletionMode completionMode;
  final List<SurahAudioModel> surahs;
  final int currentSurahIndex;

  const AudioPlayerReady({
    required this.surah,
    required this.reciter,
    required this.totalDuration,
    required this.currentPosition,
    this.isPlaying = false,
    this.isBuffering = false,
    this.isCompleted = false,
    this.speed = 1.0,
    this.completionMode = CompletionMode.manual,
    this.surahs = const [],
    this.currentSurahIndex = 0,
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
    CompletionMode? completionMode,
    List<SurahAudioModel>? surahs,
    int? currentSurahIndex,
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
      completionMode: completionMode ?? this.completionMode,
      surahs: surahs ?? this.surahs,
      currentSurahIndex: currentSurahIndex ?? this.currentSurahIndex,
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
    completionMode,
    surahs,
    currentSurahIndex,
  ];
}

class AudioPlayerError extends AudioPlayerState {
  final String message;
  final bool isRetryable;
  final bool shouldShow;
  final SurahAudioModel? surah;
  final ReciterModel? reciter;
  final String? audioUrl;

  const AudioPlayerError({
    required this.message,
    this.isRetryable = true,
    this.shouldShow = true,
    this.surah,
    this.reciter,
    this.audioUrl,
  });

  @override
  List<Object?> get props => [message, isRetryable, shouldShow ,surah, reciter, audioUrl];
}