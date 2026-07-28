import 'package:equatable/equatable.dart';

class AudioStateModel extends Equatable {
  final bool isPlaying;
  final bool isBuffering;
  final Duration? currentPosition;
  final Duration? totalDuration;
  final double? speed;

  const AudioStateModel({
    this.isPlaying = false,
    this.isBuffering = false,
    this.currentPosition,
    this.totalDuration,
    this.speed,
  });

  AudioStateModel copyWith({
    bool? isPlaying,
    bool? isBuffering,
    Duration? currentPosition,
    Duration? totalDuration,
    double? speed,
  }) {
    return AudioStateModel(
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      speed: speed ?? this.speed,
    );
  }

  @override
  List<Object?> get props => [
    isPlaying,
    isBuffering,
    currentPosition,
    totalDuration,
    speed,
  ];
}
