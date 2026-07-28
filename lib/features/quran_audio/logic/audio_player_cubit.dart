import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../data/models/reciter_model.dart';
import '../data/models/surah_audio_model.dart';
import 'audio_player_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  AudioPlayer? _audioPlayer;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;

  bool _isClosed = false;

  AudioPlayerCubit() : super(const AudioPlayerInitial());

  AudioPlayer? get player => _audioPlayer;

  Future<void> initializePlayer({
    required String audioUrl,
    required SurahAudioModel surah,
    required ReciterModel reciter,
  }) async {
    if (_isClosed) return;

    try {
      emit(const AudioPlayerLoading(message: 'Loading audio...'));

      await _disposePlayer();
      _audioPlayer = AudioPlayer();

      // Drives isPlaying / isBuffering / isCompleted
      _playerStateSubscription = _audioPlayer!.playerStateStream.listen(
            (playerState) {
          if (!_isClosed) _handlePlayerStateChange(playerState);
        },
        onError: (error) {
          if (!_isClosed) emit(AudioPlayerError('Playback error: $error'));
        },
      );

      // Single, dedicated source for position updates — just_audio emits
      // this frequently and smoothly on its own, no manual Timer needed.
      _positionSubscription = _audioPlayer!.positionStream.listen(
            (position) {
          if (!_isClosed) _updatePosition(position);
        },
        onError: (error) {
          if (!_isClosed) emit(AudioPlayerError('Position update error: $error'));
        },
      );

      await _audioPlayer!.setUrl(audioUrl);
      if (_isClosed) return;

      final duration = _audioPlayer!.duration ?? Duration.zero;

      emit(
        AudioPlayerReady(
          surah: surah,
          reciter: reciter,
          totalDuration: duration,
          currentPosition: Duration.zero,
          isPlaying: false,
        ),
      );

      if (_isClosed) return;
      await play();
    } catch (e) {
      if (!_isClosed) emit(AudioPlayerError('Failed to initialize player: $e'));
    }
  }

  void _handlePlayerStateChange(PlayerState playerState) {
    if (_isClosed) return;

    final currentState = state;
    if (currentState is! AudioPlayerReady) return;

    final isBuffering = playerState.processingState == ProcessingState.buffering;
    final isPlaying = playerState.playing;

    if (playerState.processingState == ProcessingState.completed) {
      emit(
        currentState.copyWith(
          currentPosition: currentState.totalDuration,
          isPlaying: false,
          isBuffering: false,
          isCompleted: true,
        ),
      );
      return;
    }

    emit(
      currentState.copyWith(
        isPlaying: isPlaying,
        isBuffering: isBuffering,
        isCompleted: false,
      ),
    );
  }

  void _updatePosition(Duration position) {
    if (_isClosed) return;

    final currentState = state;
    if (currentState is AudioPlayerReady) {
      emit(currentState.copyWith(currentPosition: position));
    }
  }

  Future<void> play() async {
    if (_isClosed || _audioPlayer == null) return;
    try {
      await _audioPlayer!.play();
    } catch (e) {
      if (!_isClosed) emit(AudioPlayerError('Failed to play: $e'));
    }
  }

  Future<void> pause() async {
    if (_isClosed || _audioPlayer == null) return;
    try {
      await _audioPlayer!.pause();
    } catch (e) {
      if (!_isClosed) emit(AudioPlayerError('Failed to pause: $e'));
    }
  }

  Future<void> togglePlayPause() async {
    if (_isClosed) return;

    final currentState = state;
    if (currentState is! AudioPlayerReady) return;

    // If the surah finished, tapping play should restart it from zero.
    if (currentState.isCompleted) {
      await seek(Duration.zero);
      await play();
      return;
    }

    if (currentState.isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> seek(Duration position) async {
    if (_isClosed || _audioPlayer == null) return;
    try {
      await _audioPlayer!.seek(position);
      final currentState = state;
      if (currentState is AudioPlayerReady) {
        emit(currentState.copyWith(currentPosition: position, isCompleted: false));
      }
    } catch (e) {
      if (!_isClosed) emit(AudioPlayerError('Failed to seek: $e'));
    }
  }

  Future<void> setSpeed(double speed) async {
    if (_isClosed || _audioPlayer == null) return;
    try {
      await _audioPlayer!.setSpeed(speed);
      final currentState = state;
      if (currentState is AudioPlayerReady) {
        emit(currentState.copyWith(speed: speed));
      }
    } catch (e) {
      if (!_isClosed) emit(AudioPlayerError('Failed to set speed: $e'));
    }
  }

  Future<void> _disposePlayer() async {
    await _playerStateSubscription?.cancel();
    await _positionSubscription?.cancel();
    await _audioPlayer?.dispose();
    _audioPlayer = null;
  }

  Future<void> disposePlayer() async {
    _isClosed = true;
    await _disposePlayer();
  }

  static String formatDuration(Duration duration) {
    if (duration == Duration.zero) return '0:00';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Future<void> close() {
    _isClosed = true;
    _disposePlayer();
    return super.close();
  }
}