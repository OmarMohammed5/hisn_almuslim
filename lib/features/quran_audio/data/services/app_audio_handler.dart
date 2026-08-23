import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

/// AppAudioHandler

class AppAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  StreamSubscription<PlaybackEvent>? _eventSubscription;
  StreamSubscription<ProcessingState>? _processingStateSubscription;

  String? currentUrl;

  AppAudioHandler() {
    _init();
  }


  // في AppAudioHandler
  Stream<Duration> get durationStream => _player.durationStream
      .where((duration) => duration != null)
      .map((duration) => duration!);

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    _eventSubscription = _player.playbackEventStream.listen(
      _broadcastState,
      onError: (Object e, StackTrace st) {},
    );

    _processingStateSubscription = _player.processingStateStream.listen((
      state,
    ) {
      if (state == ProcessingState.completed) {
        // Let the notification reflect "finished" rather than "playing".
        playbackState.add(
          playbackState.value.copyWith(
            playing: false,
            processingState: AudioProcessingState.completed,
          ),
        );
      }
    });
  }

  // ---------------------------------------------------------------------
  // Streams exposed upward to AudioPlayerService (mirrors what the Cubit
  // used to read directly off AudioPlayer).
  // ---------------------------------------------------------------------

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;

  Duration? get audioDuration => _player.duration;
  Duration get currentPosition => _player.position;
  bool get isPlayerPlaying => _player.playing;
  double get currentSpeed => _player.speed;

  // ---------------------------------------------------------------------
  // Loading
  // ---------------------------------------------------------------------

  Future<void> loadTrack({
    required String url,
    required MediaItem mediaItem,
  }) async {
    this.mediaItem.add(mediaItem);
    queue.add([mediaItem]);

    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
    } catch (e) {
      if (currentUrl == url) currentUrl = null;
      rethrow;
    }

    currentUrl = url;

    final duration = _player.duration;
    if (duration != null) {
      this.mediaItem.add(mediaItem.copyWith(duration: duration));
    }
  }


  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  @override
  Future<void> seek(Duration position) {
    Duration target = position;
    if (target < Duration.zero) target = Duration.zero;

    final dur = _player.duration;
    if (dur != null && target > dur) target = dur;

    return _player.seek(target);
  }


  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
    playbackState.add(playbackState.value.copyWith(speed: speed));
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    currentUrl = null;
    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        processingState: AudioProcessingState.idle,
      ),
    );
    await super.stop();
  }

  /// Called when the notification's "close" / task-removed event fires.
  /// Ensures the foreground service and player are fully torn down instead
  /// of leaking a background player with no UI.
  @override
  Future<void> onTaskRemoved() async {
    await stop();
  }

  // ---------------------------------------------------------------------
  // Broadcasting state to the OS (notification, lock screen, Android Auto,
  // Bluetooth headset metadata).
  // ---------------------------------------------------------------------

  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.rewind,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.fastForward,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ),
    );
  }

  Future<void> disposeHandler() async {
    await _eventSubscription?.cancel();
    await _processingStateSubscription?.cancel();
    await _player.dispose();
  }


}
