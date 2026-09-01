import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/cubit/ayah_highlight_cubit.dart';
import '../data/cubit/ayah_highlight_state.dart';
import '../data/cubit/quran_cubit.dart';
import '../data/cubit/quran_state.dart';
import '../data/cubit/reading_progress_cubit.dart';
import '../domain/entities/ayah_entity.dart';
import '../widgets/ayah_actions_sheet.dart';
import '../widgets/mushaf_page_block.dart';
import '../widgets/reader_settings.dart';
import '../widgets/reader_settings_sheet.dart';
import '../widgets/reading_mode_sheet.dart';

class QuranSurahPage extends StatefulWidget {
  final int surahNumber;
  final int? initialAyahNumber;

  const QuranSurahPage({
    super.key,
    required this.surahNumber,
    this.initialAyahNumber,
  });

  @override
  State<QuranSurahPage> createState() => _QuranSurahPageState();
}

class _QuranSurahPageState extends State<QuranSurahPage> {
  final PageController _pageController = PageController();
  final Map<int, GlobalKey<MushafPageBlockState>> _pageBlockKeys = {};
  final AudioPlayer _audioPlayer = AudioPlayer();

  QuranReaderSettings _settings = const QuranReaderSettings();

  int _settingsRevision = 0;
  Timer? _progressSaveDebounce;
  bool _didAutoScroll = false;
  bool _audioPlaying = false;
  bool _audioLoading = false;
  int? _playingAyah;

  static const Color _lightBackground = Color(0xFFF7F4EC);
  static const Color _darkBackground = Color(0xFF101815);
  static const Color _lightText = Color(0xFF20281F);
  static const Color _darkText = Color(0xFFECE6D6);
  static const Color _lightPrimary = Color(0xFF1F5145);
  static const Color _darkPrimary = Color(0xFF7EB6A8);

  @override
  void initState() {
    super.initState();
    context.read<QuranCubit>().loadSurahPaged(
      widget.surahNumber,
      initialAyahNumber: null,
    );
    context.read<AyahHighlightCubit>().loadAll();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      final playing = state == PlayerState.playing;
      if (_audioPlaying != playing) {
        setState(() {
          _audioPlaying = playing;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _playNextAyah();
    });

    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final rawMode = prefs.getInt('quran_reader_mode') ?? 0;
    final safeMode = rawMode >= 0 && rawMode < QuranReadingMode.values.length
        ? rawMode
        : 0;
    final font = prefs.getDouble('quran_reader_font') ?? 21;
    final dark = prefs.getBool('quran_reader_dark') ?? false;
    final loadedSettings = QuranReaderSettings(
      mode: QuranReadingMode.values[safeMode],
      fontSize: font.clamp(17, 27).toDouble(),
      darkMode: dark,
    );
    if (_settings == loadedSettings) {
      return;
    }
    setState(() {
      _settings = loadedSettings;
      _settingsRevision++;
    });
  }

  Future<void> _saveSettings(QuranReaderSettings value) async {
    if (!mounted) return;
    if (_settings == value) {
      return;
    }
    final oldSettings = _settings;
    setState(() {
      _settings = value;
      _settingsRevision++;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      await Future.wait([
        prefs.setInt('quran_reader_mode', value.mode.index),

        prefs.setDouble('quran_reader_font', value.fontSize),

        prefs.setBool('quran_reader_dark', value.darkMode),
      ]);
    } catch (_) {}

    if (oldSettings.mode != value.mode && value.mode != QuranReadingMode.qari) {
      await _audioPlayer.pause();

      if (!mounted) return;

      setState(() {
        _audioPlaying = false;
        _playingAyah = null;
      });
    }
  }

  void _scheduleProgressSave(SurahPagesLoaded state, int pageIndex) {
    _progressSaveDebounce?.cancel();

    _progressSaveDebounce = Timer(const Duration(milliseconds: 650), () {
      _savePageProgress(state, pageIndex);
    });
  }

  void _savePageProgress(SurahPagesLoaded state, int pageIndex) {
    if (!mounted) return;

    final pages = state.pageGroup.pages;

    if (pageIndex < 0 || pageIndex >= pages.length) {
      return;
    }

    final page = pages[pageIndex];

    final ayah =
        _pageBlockKeys[page.pageNumber]?.currentState?.topVisibleAyahNumber(
          thresholdY: MediaQuery.of(context).padding.top + 92.h,
        ) ??
        page.firstAyahNumberInSurah;

    context.read<ReadingProgressCubit>().updateProgress(
      surahNumber: state.surah.number,
      page: page.pageNumber,
      ayahNumber: ayah,
      totalAyahsInSurah: state.surah.totalAyahs,
    );
  }

  @override
  void dispose() {
    _progressSaveDebounce?.cancel();

    _pageController.dispose();

    _audioPlayer.stop();
    _audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = _settings.darkMode;

    final background = dark ? _darkBackground : _lightBackground;

    final text = dark ? _darkText : _lightText;

    final primary = dark ? _darkPrimary : _lightPrimary;

    final theme = Theme.of(context);

    final readerTheme = theme.copyWith(
      brightness: dark ? Brightness.dark : Brightness.light,

      scaffoldBackgroundColor: background,

      colorScheme: theme.colorScheme.copyWith(
        primary: primary,

        brightness: dark ? Brightness.dark : Brightness.light,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: background,

        foregroundColor: primary,

        elevation: 0,

        scrolledUnderElevation: 0,

        surfaceTintColor: Colors.transparent,
      ),
    );

    return Theme(
      data: readerTheme,

      child: Scaffold(
        backgroundColor: background,

        appBar: _buildAppBar(text, primary),

        body: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) {
            if (state is QuranLoading) {
              return Center(child: CupertinoActivityIndicator(color: primary));
            }

            if (state is SurahPagesLoaded) {
              return _buildReader(state);
            }

            if (state is QuranError) {
              return _buildError(state.message, primary, text);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // APP BAR
  PreferredSizeWidget _buildAppBar(Color text, Color primary) {
    return AppBar(
      toolbarHeight: 58.h,
      leadingWidth: 52.w,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 3.h,
            children: [
              Text(
                state is SurahPagesLoaded ? state.surah.displayName : 'سورة',
                style: TextStyle(
                  fontFamily: 'Noon',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: text,
                ),
              ),
              if (state is SurahPagesLoaded)
                Text(
                  '${state.surah.totalAyahs} آيات',
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: text.withValues(alpha: .48),
                  ),
                ),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          tooltip: 'إعدادات القراءة',
          icon: Icon(Icons.tune_rounded, size: 21.sp),
          onPressed: _openSettings,
        ),
        SizedBox(width: 5.w),
      ],
    );
  }

  // READER
  Widget _buildReader(SurahPagesLoaded state) {
    final pages = state.pageGroup.pages;
    if (!_didAutoScroll && pages.isNotEmpty) {
      _didAutoScroll = true;
      final highlights = context.read<AyahHighlightCubit>().state.forSurah(
        state.surah.number,
      );
      int? targetAyah = widget.initialAyahNumber;
      if (highlights.isNotEmpty) {
        targetAyah = highlights.entries
            .reduce((a, b) => a.value.timestamp > b.value.timestamp ? a : b)
            .key;
      }
      targetAyah ??= 1;
      final pageIndex = pages.indexWhere(
        (page) =>
            targetAyah! >= page.firstAyahNumberInSurah &&
            targetAyah <= page.lastAyahNumberInSurah,
      );
      if (pageIndex >= 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          if (_pageController.hasClients) {
            _pageController.jumpToPage(pageIndex);
          }
        });
      }
    }
    return BlocBuilder<AyahHighlightCubit, AyahHighlightState>(
      builder: (context, highlightState) {
        final highlights = highlightState.forSurah(state.surah.number);

        return Directionality(
          textDirection: TextDirection.rtl,

          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,

                reverse: false,

                physics: const PageScrollPhysics(),

                pageSnapping: true,

                allowImplicitScrolling: true,

                itemCount: pages.length,

                onPageChanged: (index) {
                  _scheduleProgressSave(state, index);
                },

                itemBuilder: (context, index) {
                  final page = pages[index];

                  final key = _pageBlockKeys.putIfAbsent(
                    page.pageNumber,
                    () => GlobalKey<MushafPageBlockState>(),
                  );

                  return MushafPageBlock(
                    key: key,

                    page: page,

                    mode: _settings.mode,

                    fontSize: _settings.fontSize,

                    darkMode: _settings.darkMode,

                    settingsRevision: _settingsRevision,

                    selectedAyahNumber: state.selectedAyahNumber,

                    highlightedAyahs: highlights,

                    showBasmala: index == 0 && widget.surahNumber != 9,

                    onAyahTap: (ayah) {
                      context.read<QuranCubit>().selectAyah(ayah.numberInSurah);

                      if (_settings.mode == QuranReadingMode.qari) {
                        _playAyah(state.surah.number, ayah);
                      } else {
                        _showAyahActions(
                          context,
                          state,
                          ayah,
                          highlights[ayah.numberInSurah],
                        );
                      }
                    },
                  );
                },
              ),

              // QARI BAR
              if (_settings.mode == QuranReadingMode.qari)
                _buildQariBar(state.surah.number),
            ],
          ),
        );
      },
    );
  }

  // QARI BAR
  Widget _buildQariBar(int surahNumber) {
    final dark = _settings.darkMode;

    final surface = dark ? const Color(0xFF171F1B) : const Color(0xFFFDFBF5);

    final text = dark ? _darkText : _lightText;

    final primary = dark ? _darkPrimary : _lightPrimary;

    return Positioned(
      left: 12.w,
      right: 12.w,
      bottom: 12.h,

      child: Material(
        color: surface,

        borderRadius: BorderRadius.circular(22.r),

        elevation: 8,

        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),

            border: Border.all(color: primary.withValues(alpha: .10)),
          ),

          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,

                decoration: BoxDecoration(
                  color: primary.withValues(alpha: .10),

                  shape: BoxShape.circle,
                ),

                child: _audioLoading
                    ? Padding(
                        padding: EdgeInsets.all(11.w),

                        child: CircularProgressIndicator(
                          strokeWidth: 2,

                          color: primary,
                        ),
                      )
                    : IconButton(
                        padding: EdgeInsets.zero,

                        onPressed: _toggleAudio,

                        icon: Icon(
                          _audioPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,

                          color: primary,

                          size: 21.sp,
                        ),
                      ),
              ),

              SizedBox(width: 10.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      _audioPlaying ? 'جاري التلاوة' : 'اضغط على آية للبدء',
                      style: TextStyle(
                        color: text,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _playingAyah == null
                          ? 'الشيخ محمود خليل الحصري'
                          : 'آية $_playingAyah • الشيخ محمود خليل الحصري',

                      style: TextStyle(
                        color: text.withValues(alpha: .52),

                        fontSize: 8.5.sp,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(Icons.graphic_eq_rounded, color: primary, size: 20.sp),
            ],
          ),
        ),
      ),
    );
  }

  // AUDIO
  void _toggleAudio() {
    if (_audioLoading) {
      return;
    }

    if (_audioPlaying) {
      _audioPlayer.pause();

      return;
    }

    if (_playingAyah != null) {
      _audioPlayer.resume();
    }
  }

  Future<void> _playAyah(int surahNumber, AyahEntity ayah) async {
    final url = ayah.audioUrl.endsWith('.mp3')
        ? ayah.audioUrl
        : (ayah.audioSecondary.isNotEmpty &&
              ayah.audioSecondary.first.endsWith('.mp3'))
        ? ayah.audioSecondary.first
        : 'https://cdn.islamic.network/quran/audio/128/ar.husary/$surahNumber${ayah.numberInSurah}.mp3';
    if (!mounted) {
      return;
    }
    setState(() {
      _playingAyah = ayah.numberInSurah;
      _audioLoading = true;
    });
    context.read<QuranCubit>().selectAyah(ayah.numberInSurah);
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر تشغيل التلاوة')));
    } finally {
      if (mounted) {
        setState(() {
          _audioLoading = false;
        });
      }
    }
  }

  Future<void> _playNextAyah() async {
    if (!mounted ||
        _playingAyah == null ||
        _settings.mode != QuranReadingMode.qari) {
      return;
    }

    final state = context.read<QuranCubit>().state;

    if (state is! SurahPagesLoaded) {
      return;
    }

    final all = state.surah.ayahs;

    final currentIndex = all.indexWhere(
      (ayah) => ayah.numberInSurah == _playingAyah,
    );

    if (currentIndex < 0 || currentIndex + 1 >= all.length) {
      setState(() {
        _audioPlaying = false;

        _playingAyah = null;
      });

      return;
    }

    final next = all[currentIndex + 1];

    final pages = state.pageGroup.pages;

    final pageIndex = pages.indexWhere(
      (page) =>
          next.numberInSurah >= page.firstAyahNumberInSurah &&
          next.numberInSurah <= page.lastAyahNumberInSurah,
    );

    if (pageIndex >= 0 && _pageController.hasClients) {
      final currentPage = _pageController.page?.round();

      if (currentPage != pageIndex) {
        await _pageController.animateToPage(
          pageIndex,

          duration: const Duration(milliseconds: 400),

          curve: Curves.easeOut,
        );
      }
    }

    await _playAyah(state.surah.number, next);
  }

  // SETTINGS
  void _openSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ReaderSettingsSheet(
          settings: _settings,
          onChanged: _saveSettings,
          onChooseMode: () {
            Navigator.pop(context);
            Future.delayed(const Duration(milliseconds: 120), _openModePicker);
          },
          onClose: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  // MODE PICKER
  void _openModePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return ReadingModeSheet(
          selected: _settings.mode,
          darkMode: _settings.darkMode,
          onSelected: (mode) {
            _saveSettings(_settings.copyWith(mode: mode));
          },
        );
      },
    );
  }

  // AYAH ACTIONS
  void _showAyahActions(
    BuildContext context,
    SurahPagesLoaded state,
    AyahEntity ayah,
    HighlightData? currentHighlight,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return AyahActionsSheet(
          surah: state.surah,
          ayah: ayah,
          currentHighlight: currentHighlight,
          onHighlight: (color) {
            context.read<AyahHighlightCubit>().setHighlight(
              state.surah.number,

              ayah.numberInSurah,

              color,
            );
          },
          onRemoveHighlight: () {
            context.read<AyahHighlightCubit>().removeHighlight(
              state.surah.number,

              ayah.numberInSurah,
            );
          },
        );
      },
    );
  }

  // ERROR
  Widget _buildError(String message, Color primary, Color text) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(Icons.menu_book_rounded, size: 46.sp, color: primary),

            SizedBox(height: 14.h),

            Text(
              message,

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 12.sp,

                height: 1.7,

                color: text.withValues(alpha: .7),
              ),
            ),

            SizedBox(height: 14.h),

            FilledButton.icon(
              onPressed: () {
                _didAutoScroll = false;

                _pageBlockKeys.clear();

                context.read<QuranCubit>().loadSurahPaged(widget.surahNumber);
              },

              icon: const Icon(Icons.refresh_rounded),

              label: const CustomText('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
