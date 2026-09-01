import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/quran/widgets/qari_control_bar.dart';
import 'package:hisn_almuslim/features/quran/widgets/quran_error_state_view.dart';
import 'package:hisn_almuslim/features/quran/widgets/reader_settings.dart';
import '../data/cubit/ayah_highlight_cubit.dart';
import '../data/cubit/ayah_highlight_state.dart';
import '../data/cubit/quran_state.dart';
import '../domain/entities/ayah_entity.dart';
import '../service/audio_player_manager.dart';
import 'loading_indicator.dart';
import 'mushaf_page_block.dart';

class QuranReaderBody extends StatefulWidget {
  final QuranState state;
  final QuranReaderSettings settings;
  final int settingsRevision;
  final PageController pageController;
  final Map<int, GlobalKey<MushafPageBlockState>> pageBlockKeys;
  final int surahNumber;
  final int? initialAyahNumber;
  final bool didAutoScroll;
  final AudioPlayerManager audioManager;
  final dynamic colors;
  final Function(BuildContext, SurahPagesLoaded, int) onPageChanged;
  final Function(BuildContext, SurahPagesLoaded, AyahEntity) onAyahTap;
  final VoidCallback onRetry;
  final Function(bool) onDidAutoScrollChanged;

  const QuranReaderBody({
    super.key,
    required this.state,
    required this.settings,
    required this.settingsRevision,
    required this.pageController,
    required this.pageBlockKeys,
    required this.surahNumber,
    required this.initialAyahNumber,
    required this.didAutoScroll,
    required this.audioManager,
    required this.colors,
    required this.onPageChanged,
    required this.onAyahTap,
    required this.onRetry,
    required this.onDidAutoScrollChanged,
  });

  @override
  State<QuranReaderBody> createState() => _QuranReaderBodyState();
}

class _QuranReaderBodyState extends State<QuranReaderBody> {
  @override
  Widget build(BuildContext context) {
    if (widget.state is QuranLoading) {
      return Center(child: LoadingIndicator(color: widget.colors.primary));
    }

    if (widget.state is SurahPagesLoaded) {
      return _buildReader(context, widget.state as SurahPagesLoaded);
    }

    if (widget.state is QuranError) {
      return QuranErrorStateView(
        message: (widget.state as QuranError).message,
        colors: widget.colors,
        onRetry: widget.onRetry,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildReader(BuildContext context, SurahPagesLoaded state) {
    final pages = state.pageGroup.pages;

    _handleAutoScroll(state, pages);

    return BlocBuilder<AyahHighlightCubit, AyahHighlightState>(
      builder: (context, highlightState) {
        final highlights = highlightState.forSurah(state.surah.number);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              PageView.builder(
                controller: widget.pageController,
                reverse: false,
                physics: const PageScrollPhysics(),
                pageSnapping: true,
                allowImplicitScrolling: true,
                itemCount: pages.length,
                onPageChanged: (index) => widget.onPageChanged(context, state, index),
                itemBuilder: (context, index) => MushafPageBlock(
                  key: widget.pageBlockKeys.putIfAbsent(
                    pages[index].pageNumber,
                        () => GlobalKey<MushafPageBlockState>(),
                  ),
                  page: pages[index],
                  mode: widget.settings.mode,
                  fontSize: widget.settings.fontSize,
                  darkMode: widget.settings.darkMode,
                  settingsRevision: widget.settingsRevision,
                  selectedAyahNumber: state.selectedAyahNumber,
                  highlightedAyahs: highlights,
                  showBasmala: index == 0 && widget.surahNumber != 9,
                  onAyahTap: (ayah) => widget.onAyahTap(context, state, ayah),
                ),
              ),
              if (widget.settings.mode == QuranReadingMode.qari)
                QariControlBar(
                  audioManager: widget.audioManager,
                  colors: widget.colors,
                  darkMode: widget.settings.darkMode,
                ),
            ],
          ),
        );
      },
    );
  }

  void _handleAutoScroll(SurahPagesLoaded state, List pages) {
    if (!widget.didAutoScroll && pages.isNotEmpty) {
      final targetAyah = _getTargetAyah(state);
      final pageIndex = pages.indexWhere(
            (page) =>
        targetAyah >= page.firstAyahNumberInSurah &&
            targetAyah <= page.lastAyahNumberInSurah,
      );

      if (pageIndex >= 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && widget.pageController.hasClients) {
            widget.pageController.jumpToPage(pageIndex);
          }
        });
      }
      widget.onDidAutoScrollChanged(true);
    }
  }

  int _getTargetAyah(SurahPagesLoaded state) {
    final highlights = context.read<AyahHighlightCubit>().state
        .forSurah(state.surah.number);

    int? targetAyah = widget.initialAyahNumber;

    if (highlights.isNotEmpty) {
      targetAyah = highlights.entries
          .reduce((a, b) => a.value.timestamp > b.value.timestamp ? a : b)
          .key;
    }

    return targetAyah ?? 1;
  }
}