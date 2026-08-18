import 'dart:async';
import 'package:audio_service/audio_service.dart' show MediaItem;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' show PlayerState, ProcessingState;
import '../data/models/reciter_model.dart';
import '../data/models/surah_audio_model.dart';
import '../data/services/app_audio_player_service.dart';
import 'audio_player_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  final AudioPlayerService _service = AudioPlayerService.instance;

  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;

  bool _isClosed = false;
  String? _currentAudioUrl;
  SurahAudioModel? _currentSurah;
  ReciterModel? _currentReciter;
  List<SurahAudioModel> _surahs = [];
  int _currentSurahIndex = 0;
  CompletionMode _currentCompletionMode = CompletionMode.manual;

  bool _isSeeking = false;
  Duration _lastEmittedPosition = Duration.zero;

  bool _completionHandled = false;


  String? get currentAudioUrl => _currentAudioUrl;

  AudioPlayerCubit() : super(const AudioPlayerInitial());

  // ============================================================
  // Initialization
  // ============================================================
  Future<void> initializePlayer({
    required String audioUrl,
    required SurahAudioModel surah,
    required ReciterModel reciter,
    List<SurahAudioModel>? surahs,
    int? surahIndex,
    CompletionMode? completionMode,
  }) async {
    if (_isClosed) return;

    try {

      _completionHandled = false;

      _currentAudioUrl = audioUrl;
      _currentSurah = surah;
      _currentReciter = reciter;

      if (completionMode != null) {
        _currentCompletionMode = completionMode;
      }

      if (surahs != null && surahs.isNotEmpty) {
        _surahs = surahs;
      }

      if (surahs != null && surahIndex != null) {
        _currentSurahIndex = surahIndex;
      } else if (surahs != null) {
        _currentSurahIndex = surahs.indexWhere((s) => s.number == surah.number);
        if (_currentSurahIndex == -1) _currentSurahIndex = 0;
      }


      final isSameTrackAlreadyLoaded = _service.currentUrl == audioUrl;


      await _cancelSubscriptions();

      _subscribeToStreams();

      if (isSameTrackAlreadyLoaded) {
        final duration = _service.duration ?? Duration.zero;
        emit(
          AudioPlayerReady(
            surah: surah,
            reciter: reciter,
            totalDuration: duration,
            currentPosition: _service.position,
            isPlaying: _service.isPlaying,
            completionMode: _currentCompletionMode,
            surahs: _surahs,
            currentSurahIndex: _currentSurahIndex,
          ),
        );
        return;
      }

      emit(const AudioPlayerLoading(message: 'جاري تحميل الصوت...'));

      final mediaItem = MediaItem(
        id: audioUrl,
        album: reciter.reciter.ar,
        title: surah.nameArabic,
        artist: reciter.reciter.ar,
      );

      await _service.loadTrack(url: audioUrl, mediaItem: mediaItem);
      if (_isClosed) return;

      final duration = _service.duration ?? Duration.zero;

      emit(
        AudioPlayerReady(
          surah: surah,
          reciter: reciter,
          totalDuration: duration,
          currentPosition: Duration.zero,
          isPlaying: false,
          completionMode: _currentCompletionMode,
          surahs: _surahs,
          currentSurahIndex: _currentSurahIndex,
        ),
      );

      if (_isClosed) return;

      await play();
    } catch (e) {
      if (!_isClosed) {
        final errorMessage = e.toString();
        if (errorMessage.contains('Source error') ||
            errorMessage.contains('SocketException') ||
            errorMessage.contains('HttpException')) {
          emit(_createErrorState(errorMessage, audioUrl, surah, reciter));
        } else {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (!_isClosed) {
              initializePlayer(
                audioUrl: audioUrl,
                surah: surah,
                reciter: reciter,
                surahs: _surahs,
                surahIndex: _currentSurahIndex,
                completionMode: _currentCompletionMode,
              );
            }
          });
        }
      }
    }
  }

  // ============================================================
  // Subscriptions
  // ============================================================

  void _subscribeToStreams() {
    // Player State Stream
    _playerStateSubscription = _service.playerStateStream.listen(
          (playerState) {
        if (!_isClosed) _handlePlayerStateChange(playerState);
      },
    );

    // Position Stream
    _positionSubscription = _service.positionStream.listen(
          (position) {
        if (!_isClosed && !_isSeeking) {
          _updatePosition(position);
        }
      },
    );

    // Duration Stream
    _durationSubscription = _service.durationStream.listen(
          (duration) {
        if (!_isClosed) _updateDuration(duration);
      },
    );
  }

  Future<void> _cancelSubscriptions() async {
    await _playerStateSubscription?.cancel();
    await _positionSubscription?.cancel();
    await _durationSubscription?.cancel();
    _playerStateSubscription = null;
    _positionSubscription = null;
    _durationSubscription = null;
  }

  // ============================================================
  // State Updates
  // ============================================================

  void _updatePosition(Duration position) {
    if (_isClosed) return;

    final currentState = state;
    if (currentState is AudioPlayerReady) {
      emit(currentState.copyWith(currentPosition: position));
    }
  }


  void _updateDuration(Duration duration) {
    if (_isClosed) return;

    final currentState = state;
    if (currentState is AudioPlayerReady) {
      if (currentState.totalDuration != duration) {
        emit(currentState.copyWith(totalDuration: duration));
      }
    }
  }
  void _handlePlayerStateChange(PlayerState playerState) {
    final currentState = state;
    if (currentState is! AudioPlayerReady) return;

    final isBuffering = playerState.processingState == ProcessingState.buffering;
    final isPlaying = playerState.playing;
    final isCompleted = playerState.processingState == ProcessingState.completed;

    if (isCompleted) {
      if (_completionHandled) return;
      _completionHandled = true;

      emit(currentState.copyWith(
        currentPosition: currentState.totalDuration,
        isPlaying: false,
        isBuffering: false,
        isCompleted: true,
      ));
      _handleCompletion(currentState);
      return;
    }

    emit(currentState.copyWith(
      isPlaying: isPlaying,
      isBuffering: isBuffering,
      isCompleted: false,
    ));
  }
  void _handleCompletion(AudioPlayerReady currentState) {
    emit(
      currentState.copyWith(
        currentPosition: currentState.totalDuration,
        isPlaying: false,
        isBuffering: false,
        isCompleted: true,
      ),
    );

    switch (_currentCompletionMode) {
      case CompletionMode.continueToNext:
        if (_currentSurahIndex < _surahs.length - 1) {
          final nextIndex = _currentSurahIndex + 1;
          _currentSurahIndex = nextIndex;
          _currentSurah = _surahs[nextIndex];
          _loadSurah(_currentSurah!);
        } else {
          _service.pause();
        }
        break;

      case CompletionMode.repeatCurrent:
        _service.seek(Duration.zero);
        Future.delayed(const Duration(milliseconds: 100), () {
          play();
        });
        break;

      case CompletionMode.stopAfterCurrent:
        _service.pause();
        final state = this.state;
        if (state is AudioPlayerReady) {
          emit(state.copyWith(isPlaying: false, isCompleted: true));
        }
        break;

      case CompletionMode.manual:
        _service.pause();
        break;
    }
  }

  // ============================================================
  // Error Handling
  // ============================================================

  AudioPlayerError _createErrorState(
      String errorMessage,
      String audioUrl,
      SurahAudioModel surah,
      ReciterModel reciter,
      ) {
    String userMessage = 'حدث خطأ أثناء تشغيل الصوت';
    bool isRetryable = true;
    bool shouldShow = true;

    if (errorMessage.contains('SocketException') ||
        errorMessage.contains('HttpException') ||
        errorMessage.contains('Connection refused') ||
        errorMessage.contains('Failed host lookup') ||
        errorMessage.contains('Network is unreachable')) {
      userMessage = 'تعذر تشغيل الصوت\nتحقق من اتصالك بالإنترنت وحاول مرة أخرى.';
    } else if (errorMessage.contains('Source error') ||
        errorMessage.contains('404') ||
        errorMessage.contains('Not Found')) {
      userMessage = 'عذراً، لا يمكن العثور على ملف الصوت';
      isRetryable = false;
    } else if (errorMessage.contains('FormatException') ||
        errorMessage.contains('unsupported')) {
      userMessage = 'صيغة الملف غير مدعومة';
      isRetryable = false;
    } else if (errorMessage.contains('already loaded') ||
        errorMessage.contains('same track')) {
      shouldShow = false;
      userMessage = '';
    } else {
      userMessage = 'حدث خطأ غير متوقع. حاول مرة أخرى.';
    }


    return AudioPlayerError(
      message: userMessage,
      isRetryable: isRetryable,
      shouldShow: shouldShow,
      surah: surah,
      reciter: reciter,
      audioUrl: audioUrl,
    );
  }

  Future<void> retry() async {
    if (_isClosed) return;

    final currentState = state;
    if (currentState is! AudioPlayerError) return;

    final surah = currentState.surah;
    final reciter = currentState.reciter;
    final audioUrl = currentState.audioUrl;

    if (surah == null || reciter == null || audioUrl == null) {
      emit(const AudioPlayerError(
        message: 'لا يمكن إعادة المحاولة، البيانات غير مكتملة',
        isRetryable: false,
      ));
      return;
    }

    await _service.pause();
    await initializePlayer(
      audioUrl: audioUrl,
      surah: surah,
      reciter: reciter,
      surahs: _surahs,
      surahIndex: _currentSurahIndex,
      completionMode: _currentCompletionMode,
    );
  }

  // ============================================================
  // Playback Controls
  // ============================================================

  Future<void> play() async {
    if (_isClosed) {
      return;
    }

    try {
      await _service.play();

      final currentState = state;
      if (currentState is AudioPlayerReady) {
        emit(currentState.copyWith(isPlaying: true, isCompleted: false));
      }
    } catch (e) {
      if (!_isClosed) {
        final currentState = state;
        if (currentState is AudioPlayerReady) {
          emit(_createErrorState(
            e.toString(),
            _currentAudioUrl ?? '',
            currentState.surah,
            currentState.reciter,
          ));
        }
      }
    }
  }

  Future<void> pause() async {
    if (_isClosed) {
      return;
    }

    try {
      await _service.pause();

      final currentState = state;
      if (currentState is AudioPlayerReady) {
        emit(currentState.copyWith(isPlaying: false));
      }
    } catch (e) {
      if (!_isClosed) {
        emit(AudioPlayerError(message: 'فشل في إيقاف التشغيل مؤقتاً: $e'));
      }
    }
  }

  Future<void> togglePlayPause() async {
    if (_isClosed) {
      return;
    }

    final currentState = state;
    if (currentState is! AudioPlayerReady) {
      return;
    }


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
    if (_isClosed) return;

    try {
      final currentState = state;
      Duration target = position;
      if (target < Duration.zero) target = Duration.zero;
      if (currentState is AudioPlayerReady && target > currentState.totalDuration) {
        target = currentState.totalDuration;
      }

      if (currentState is AudioPlayerReady && target < currentState.totalDuration) {
        _completionHandled = false;
      }

      _isSeeking = true;

      if (currentState is AudioPlayerReady) {
        emit(currentState.copyWith(currentPosition: target, isCompleted: false));
      }

      await _service.seek(target);
      _isSeeking = false;

      final newPosition = _service.position;
      if (currentState is AudioPlayerReady) {
        emit(currentState.copyWith(currentPosition: newPosition));
      }
    } catch (e) {
      _isSeeking = false;
      if (!_isClosed) {
        emit(AudioPlayerError(message: 'فشل في التقديم: $e'));
      }
    }
  }

  Future<void> setSpeed(double speed) async {
    if (_isClosed) return;
    try {
      await _service.setSpeed(speed);
      final currentState = state;
      if (currentState is AudioPlayerReady) {
        emit(currentState.copyWith(speed: speed));
      }
    } catch (e) {
      if (!_isClosed) {
        emit(AudioPlayerError(message: 'فشل في تغيير السرعة: $e'));
      }
    }
  }

  // ============================================================
  // Navigation
  // ============================================================

  Future<void> playNext() async {
    if (_isClosed || _surahs.isEmpty) {
      return;
    }

    final nextIndex = _currentSurahIndex + 1;
    if (nextIndex >= _surahs.length) {
      return;
    }

    final nextSurah = _surahs[nextIndex];

    _currentSurahIndex = nextIndex;
    await _loadSurah(nextSurah);
  }

  Future<void> playPrevious() async {
    if (_isClosed || _surahs.isEmpty) {
      return;
    }

    final prevIndex = _currentSurahIndex - 1;
    if (prevIndex < 0) {
      return;
    }

    final prevSurah = _surahs[prevIndex];

    _currentSurahIndex = prevIndex;
    await _loadSurah(prevSurah);
  }

  void _loadNextSurah() {
    if (_surahs.isEmpty) {
      return;
    }
    final nextIndex = _currentSurahIndex + 1;
    if (nextIndex >= _surahs.length) {
      return;
    }
    final nextSurah = _surahs[nextIndex];
    _currentSurahIndex = nextIndex;
    _loadSurah(nextSurah);
  }


  Future<void> _loadSurah(SurahAudioModel surah) async {
    if (_currentReciter == null) {
      return;
    }

    final server = _currentReciter!.server;
    final audioUrl = '$server/${surah.number.toString().padLeft(3, '0')}.mp3';

    await initializePlayer(
      audioUrl: audioUrl,
      surah: surah,
      reciter: _currentReciter!,
      surahs: _surahs,
      surahIndex: _currentSurahIndex,
      completionMode: _currentCompletionMode,
    );
  }


  // ============================================================
  // Completion Mode
  // ============================================================

  void setCompletionMode(CompletionMode mode) {
    if (_isClosed) return;
    _currentCompletionMode = mode;

    final currentState = state;
    if (currentState is AudioPlayerReady) {
      emit(currentState.copyWith(completionMode: mode));
    }
  }

  // ============================================================
  // Helpers
  // ============================================================

  static String formatDuration(Duration duration) {
    if (duration == Duration.zero) return '0:00';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // ============================================================
  // Lifecycle
  // ============================================================

  Future<void> disposePlayer() async {
    _isClosed = true;
    await _cancelSubscriptions();
  }

  @override
  Future<void> close() {
    _isClosed = true;
    _cancelSubscriptions();
    return super.close();
  }
}
