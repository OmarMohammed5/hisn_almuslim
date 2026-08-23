import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'app_audio_handler.dart';


class AudioPlayerService {
  AudioPlayerService._internal();

  static final AudioPlayerService instance = AudioPlayerService._internal();

  AppAudioHandler? _handler;

  void attachHandler(AppAudioHandler handler) {
    _handler = handler;
  }

  AppAudioHandler get _requireHandler {
    assert(
      _handler != null,
      'AudioPlayerService.attachHandler() was never called. '
      'Make sure main.dart initializes AudioService before runApp().',
    );
    return _handler!;
  }

  String? get currentUrl => _handler?.currentUrl;
  bool get isPlaying => _handler?.isPlayerPlaying ?? false;
  double get speed => _handler?.currentSpeed ?? 1.0;
  Duration? get duration => _handler?.audioDuration;
  Duration get position => _handler?.currentPosition ?? Duration.zero;

  Stream<PlayerState> get playerStateStream =>
      _requireHandler.playerStateStream;
  Stream<Duration> get positionStream => _requireHandler.positionStream;

  Future<void> loadTrack({
    required String url,
    required MediaItem mediaItem,
  }) {
    return _requireHandler.loadTrack(
      url: url,
      mediaItem: mediaItem,
    );
  }

  Future<void> play() => _requireHandler.play();

  Future<void> pause() => _requireHandler.pause();

  Future<void> seek(Duration position) => _requireHandler.seek(position);

  Future<void> setSpeed(double speed) => _requireHandler.setSpeed(speed);


  Future<void> stop() => _requireHandler.stop();

  Stream<Duration> get durationStream => _requireHandler.durationStream;



}
