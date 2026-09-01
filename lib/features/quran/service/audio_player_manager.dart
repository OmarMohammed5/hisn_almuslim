import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../data/cubit/quran_cubit.dart';
import '../data/cubit/quran_state.dart';
import '../domain/entities/ayah_entity.dart';
import '../widgets/reader_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AudioPlayerManager {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final VoidCallback? onPlayStateChanged;
  final VoidCallback? onPlayComplete;

  bool _isLoading = false;
  bool _isPlaying = false;
  int? _playingAyah;

  bool get isLoading => _isLoading;
  bool get isPlaying => _isPlaying;
  int? get playingAyah => _playingAyah;

  AudioPlayerManager({
    this.onPlayStateChanged,
    this.onPlayComplete,
  }) {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      final playing = state == PlayerState.playing;
      if (_isPlaying != playing) {
        _isPlaying = playing;
        onPlayStateChanged?.call();
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      onPlayComplete?.call();
    });
  }

  Future<void> playAyah({
    required BuildContext context,
    required int surahNumber,
    required AyahEntity ayah,
    VoidCallback? onPlayStarted,
  }) async {
    final url = _getAudioUrl(surahNumber, ayah);
    if (!context.mounted) return;

    _setLoading(true);
    _playingAyah = ayah.numberInSurah;

    context.read<QuranCubit>().selectAyah(ayah.numberInSurah);

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
      onPlayStarted?.call();
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تشغيل التلاوة')),
      );
    } finally {
      _setLoading(false);
    }
  }

  String _getAudioUrl(int surahNumber, AyahEntity ayah) {
    if (ayah.audioUrl.endsWith('.mp3')) {
      return ayah.audioUrl;
    }
    if (ayah.audioSecondary.isNotEmpty &&
        ayah.audioSecondary.first.endsWith('.mp3')) {
      return ayah.audioSecondary.first;
    }
    return 'https://cdn.islamic.network/quran/audio/128/ar.husary/$surahNumber${ayah.numberInSurah}.mp3';
  }

  Future<void> playNextAyah({
    required BuildContext context,
    required QuranReaderSettings settings,
    required PageController pageController,
  }) async {
    if (!context.mounted || _playingAyah == null || settings.mode != QuranReadingMode.qari) {
      return;
    }

    final state = context.read<QuranCubit>().state;
    if (state is! SurahPagesLoaded) return;

    final all = state.surah.ayahs;
    final currentIndex = all.indexWhere(
          (ayah) => ayah.numberInSurah == _playingAyah,
    );

    if (currentIndex < 0 || currentIndex + 1 >= all.length) {
      _reset();
      return;
    }

    final next = all[currentIndex + 1];
    final pages = state.pageGroup.pages;
    final pageIndex = pages.indexWhere(
          (page) =>
      next.numberInSurah >= page.firstAyahNumberInSurah &&
          next.numberInSurah <= page.lastAyahNumberInSurah,
    );

    if (pageIndex >= 0 && pageController.hasClients) {
      final currentPage = pageController.page?.round();
      if (currentPage != pageIndex) {
        await pageController.animateToPage(
          pageIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    }

    await playAyah(
      context: context,
      surahNumber: state.surah.number,
      ayah: next,
    );
  }

  void togglePlay() {
    if (_isLoading) return;
    if (_isPlaying) {
      _audioPlayer.pause();
    } else if (_playingAyah != null) {
      _audioPlayer.resume();
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _reset();
  }

  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    onPlayStateChanged?.call();
  }

  void _reset() {
    _isPlaying = false;
    _playingAyah = null;
    onPlayStateChanged?.call();
  }
}