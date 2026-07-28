import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'app_audio_handler.dart';

/// AudioPlayerService
///
/// The single point of contact between `AudioPlayerCubit` and audio
/// playback. The Cubit never touches `AudioPlayer` or `AppAudioHandler`
/// directly — only this service.
///
/// This is a singleton on purpose: the Cubit is recreated every time
/// `AudioPlayerScreen` is opened (it's provided via
/// `BlocProvider(create: ...)` in the screen itself), but actual playback
/// must keep running after the user navigates away. So the *service* — not
/// the Cubit — owns the long-lived connection to the handler.
class AudioPlayerService {
  AudioPlayerService._internal();

  static final AudioPlayerService instance = AudioPlayerService._internal();

  AppAudioHandler? _handler;

  /// Called once from `main.dart`, right after `AudioService.init(...)`.
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

  // ---------------------------------------------------------------------
  // State the Cubit needs to decide whether to reload a track or just
  // re-attach to what's already playing (e.g. user backs out of the
  // player screen and re-opens it for the same surah).
  // ---------------------------------------------------------------------

  String? get currentUrl => _handler?.currentUrl;
  bool get isPlaying => _handler?.isPlayerPlaying ?? false;
  double get speed => _handler?.currentSpeed ?? 1.0;
  Duration? get duration => _handler?.audioDuration;
  Duration get position => _handler?.currentPosition ?? Duration.zero;

  // ---------------------------------------------------------------------
  // Streams — same shape the Cubit used to consume straight off
  // AudioPlayer, so AudioPlayerCubit's listening logic barely changes.
  // ---------------------------------------------------------------------

  Stream<PlayerState> get playerStateStream =>
      _requireHandler.playerStateStream;
  Stream<Duration> get positionStream => _requireHandler.positionStream;

  // ---------------------------------------------------------------------
  // Commands
  // ---------------------------------------------------------------------

  Future<void> loadTrack({required String url, required MediaItem mediaItem}) {
    return _requireHandler.loadAndPlay(url: url, mediaItem: mediaItem);
  }

  Future<void> play() => _requireHandler.play();

  Future<void> pause() => _requireHandler.pause();

  Future<void> seek(Duration position) => _requireHandler.seek(position);

  Future<void> setSpeed(double speed) => _requireHandler.setSpeed(speed);

  /// Fully stops playback. Only call this for an explicit Stop action
  /// (future "Stop" button, notification Stop button) — NOT when the user
  /// simply navigates away from AudioPlayerScreen.
  Future<void> stop() => _requireHandler.stop();
}
