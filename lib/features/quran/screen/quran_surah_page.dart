import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../core/routing/app_routes.dart';
import '../data/cubit/ayah_highlight_cubit.dart';
import '../data/cubit/ayah_highlight_state.dart';
import '../data/cubit/quran_cubit.dart';
import '../data/cubit/quran_state.dart';
import '../data/cubit/reading_progress_cubit.dart';
import '../domain/entities/ayah_entity.dart';
import '../widgets/ayah_actions_sheet.dart';
import '../widgets/mushaf_page_block.dart';

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
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
  ItemPositionsListener.create();

  final Map<int, GlobalKey<MushafPageBlockState>> _pageBlockKeys = {};

  int? _resolvedInitialAyah;
  bool _didAutoScroll = false;
  Timer? _progressSaveDebounce;

  @override
  void initState() {
    super.initState();

    context.read<QuranCubit>().loadSurahPaged(
      widget.surahNumber,
      initialAyahNumber: null,
    );

    _itemPositionsListener.itemPositions.addListener(_onPositionsChanged);
  }

  void _onPositionsChanged() {
    _progressSaveDebounce?.cancel();
    _progressSaveDebounce = Timer(const Duration(milliseconds: 700), _saveCurrentProgress);
  }

  double get _readLineY {
    final topPadding = MediaQuery.of(context).padding.top;
    return topPadding + kToolbarHeight + 24.h;
  }

  void _saveCurrentProgress() {
    if (!mounted) return;
    final quranState = context.read<QuranCubit>().state;
    if (quranState is! SurahPagesLoaded) return;

    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    final visibleIndex = positions
        .where((p) => p.itemTrailingEdge > 0)
        .reduce((a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b)
        .index;

    final pages = quranState.pageGroup.pages;
    if (visibleIndex < 0 || visibleIndex >= pages.length) return;

    final currentPage = pages[visibleIndex];

    final blockState = _pageBlockKeys[currentPage.pageNumber]?.currentState;
    final ayahNumber = blockState?.topVisibleAyahNumber(thresholdY: _readLineY) ??
        currentPage.firstAyahNumberInSurah;

    context.read<ReadingProgressCubit>().updateProgress(
      surahNumber: quranState.surah.number,
      page: currentPage.pageNumber,
      ayahNumber: ayahNumber,
      totalAyahsInSurah: quranState.surah.totalAyahs,
    );
  }

  @override
  void dispose() {
    _progressSaveDebounce?.cancel();
    _itemPositionsListener.itemPositions.removeListener(_onPositionsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF241F16) : const Color(0xFFFBF3E3),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF2E271A) : const Color(0xFFF3E6C8),
        toolbarHeight: 35.h,
        title: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) {
            final name = state is SurahPagesLoaded ? state.surah.displayName : '';
            return Text(name, style: TextStyle(fontFamily: 'Noon', fontSize: 16.sp));
          },
        ),
      ),
      body: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          if (state is QuranLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SurahPagesLoaded) {
            final pages = state.pageGroup.pages;

            if (!_didAutoScroll && pages.isNotEmpty) {
              _didAutoScroll = true;
              final highlightState = context.read<AyahHighlightCubit>().state;
              final highlightsForSurah = highlightState.forSurah(state.surah.number);

              int? targetAyah;

              if (highlightsForSurah.isNotEmpty) {
                final latestHighlight = highlightsForSurah.entries.reduce(
                      (a, b) => a.value.timestamp > b.value.timestamp ? a : b,
                );
                targetAyah = latestHighlight.key;
              }

              targetAyah ??= widget.initialAyahNumber ?? 1;

              final targetIndex = pages.indexWhere((p) =>
              targetAyah! >= p.firstAyahNumberInSurah &&
                  targetAyah! <= p.lastAyahNumberInSurah);

              if (targetIndex >= 0) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _itemScrollController.jumpTo(index: targetIndex);
                });
              }
            }

            return BlocBuilder<AyahHighlightCubit, AyahHighlightState>(
              builder: (context, highlightState) {
                final highlightsForSurah = highlightState.forSurah(state.surah.number);

                return ScrollablePositionedList.builder(
                  itemScrollController: _itemScrollController,
                  itemPositionsListener: _itemPositionsListener,
                  padding: EdgeInsets.only(bottom: 80.h),
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    final blockKey = _pageBlockKeys.putIfAbsent(
                      page.pageNumber,
                          () => GlobalKey<MushafPageBlockState>(),
                    );

                    // Check if this is the first page and should show Basmala
                    final bool showBasmala = (index == 0 &&
                        widget.surahNumber != 9 &&
                        widget.surahNumber != 1);

                    return MushafPageBlock(
                      key: blockKey,
                      page: page,
                      selectedAyahNumber: state.selectedAyahNumber,
                      highlightedAyahs: highlightsForSurah,
                      onAyahTap: (ayah) {
                        context.read<QuranCubit>().selectAyah(ayah.numberInSurah);
                        _showAyahActions(context, state, ayah, highlightsForSurah[ayah.numberInSurah]);
                      },
                      showBasmala: showBasmala,
                    );
                  },
                );
              },
            );
          }

          if (state is QuranError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<QuranCubit>().loadSurahPaged(widget.surahNumber),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

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
      builder: (sheetContext) => AyahActionsSheet(
        surah: state.surah,
        ayah: ayah,
        currentHighlight: currentHighlight,
        onHighlight: (color) => context
            .read<AyahHighlightCubit>()
            .setHighlight(state.surah.number, ayah.numberInSurah, color),
        onRemoveHighlight: () => context
            .read<AyahHighlightCubit>()
            .removeHighlight(state.surah.number, ayah.numberInSurah),
        onTafsir: () {
          Navigator.pop(sheetContext);
          Navigator.pushNamed(context, AppRoutes.quranTafsir, arguments: {
            'ayahNumber': ayah.numberInSurah,
            'ayahText': ayah.text,
            'tafsirText':
            'تفسير الآية ${ayah.numberInSurah} من سورة ${state.surah.displayName}',
            'tafsirSource': 'تفسير ابن كثير',
          });
        },
      ),
    );
  }
}