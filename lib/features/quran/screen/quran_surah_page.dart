import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
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

  // ============================================================
  // Colors
  // ============================================================

  static const Color _lightBackground = Color(0xFFF7F3E8);

  static const Color _darkBackground = Color(0xFF171B19);

  static const Color _lightAppBar = Color(0xFFEEE7D5);

  static const Color _darkAppBar = Color(0xFF1D2522);

  static const Color _lightText = Color(0xFF292C29);

  static const Color _darkText = Color(0xFFE8E0CC);

  static const Color _teal = Color(0xFF16877D);

  static const Color _darkTeal = Color(0xFF66C7BB);

  static const Color _lightGold = Color(0xFFB59A5A);

  static const Color _darkGold = Color(0xFFCDB878);

  // ============================================================
  // Init
  // ============================================================

  @override
  void initState() {
    super.initState();

    context.read<QuranCubit>().loadSurahPaged(
      widget.surahNumber,
      initialAyahNumber: null,
    );

    _itemPositionsListener.itemPositions.addListener(_onPositionsChanged);
  }

  // ============================================================
  // Reading Progress
  // ============================================================

  void _onPositionsChanged() {
    _progressSaveDebounce?.cancel();

    _progressSaveDebounce = Timer(
      const Duration(milliseconds: 700),
      _saveCurrentProgress,
    );
  }

  double get _readLineY {
    final topPadding = MediaQuery.of(context).padding.top;

    return topPadding + kToolbarHeight + 24.h;
  }

  void _saveCurrentProgress() {
    if (!mounted) return;

    final quranState = context.read<QuranCubit>().state;

    if (quranState is! SurahPagesLoaded) {
      return;
    }

    final positions = _itemPositionsListener.itemPositions.value;

    if (positions.isEmpty) return;

    final visibleIndex = positions
        .where((p) => p.itemTrailingEdge > 0)
        .reduce((a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b)
        .index;

    final pages = quranState.pageGroup.pages;

    if (visibleIndex < 0 || visibleIndex >= pages.length) {
      return;
    }

    final currentPage = pages[visibleIndex];

    final blockState = _pageBlockKeys[currentPage.pageNumber]?.currentState;

    final ayahNumber =
        blockState?.topVisibleAyahNumber(thresholdY: _readLineY) ??
        currentPage.firstAyahNumberInSurah;

    context.read<ReadingProgressCubit>().updateProgress(
      surahNumber: quranState.surah.number,
      page: currentPage.pageNumber,
      ayahNumber: ayahNumber,
      totalAyahsInSurah: quranState.surah.totalAyahs,
    );
  }

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void dispose() {
    _progressSaveDebounce?.cancel();

    _itemPositionsListener.itemPositions.removeListener(_onPositionsChanged);

    super.dispose();
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? _darkBackground : _lightBackground;

    final appBarColor = isDark ? _darkAppBar : _lightAppBar;

    final textColor = isDark ? _darkText : _lightText;

    final accentColor = isDark ? _darkTeal : _teal;

    return Scaffold(
      backgroundColor: backgroundColor,

      // ========================================================
      // App Bar
      // ========================================================
      appBar: AppBar(
        scrolledUnderElevation: 0,

        elevation: 0,

        centerTitle: true,

        backgroundColor: appBarColor,

        foregroundColor: accentColor,

        toolbarHeight: 35.h,

        title: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) {
            final name = state is SurahPagesLoaded
                ? state.surah.displayName
                : '';

            return CustomText(
              name,
              maxLines: 1,
              textAlign: TextAlign.center,
              fontFamily: 'QuranFont',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
              height: 1.3,
            );
          },
        ),
      ),

      // ========================================================
      // Body
      // ========================================================
      body: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          // ----------------------------------------------------
          // Loading
          // ----------------------------------------------------

          if (state is QuranLoading) {
            return Center(
              child: SizedBox(
                width: 26.w,
                height: 26.w,
                child: CupertinoActivityIndicator(color: accentColor),
              ),
            );
          }

          // ----------------------------------------------------
          // Loaded
          // ----------------------------------------------------

          if (state is SurahPagesLoaded) {
            final pages = state.pageGroup.pages;

            // --------------------------------------------------
            // Initial Scroll
            // --------------------------------------------------

            if (!_didAutoScroll && pages.isNotEmpty) {
              _didAutoScroll = true;

              final highlightState = context.read<AyahHighlightCubit>().state;

              final highlightsForSurah = highlightState.forSurah(
                state.surah.number,
              );

              int? targetAyah;

              if (highlightsForSurah.isNotEmpty) {
                final latestHighlight = highlightsForSurah.entries.reduce(
                  (a, b) => a.value.timestamp > b.value.timestamp ? a : b,
                );

                targetAyah = latestHighlight.key;
              }

              targetAyah ??= widget.initialAyahNumber ?? 1;

              final targetIndex = pages.indexWhere(
                (page) =>
                    targetAyah! >= page.firstAyahNumberInSurah &&
                    targetAyah! <= page.lastAyahNumberInSurah,
              );

              if (targetIndex >= 0) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!_itemScrollController.isAttached) {
                    return;
                  }

                  _itemScrollController.jumpTo(index: targetIndex);
                });
              }
            }

            // --------------------------------------------------
            // Highlight State
            // --------------------------------------------------

            return BlocBuilder<AyahHighlightCubit, AyahHighlightState>(
              builder: (context, highlightState) {
                final highlightsForSurah = highlightState.forSurah(
                  state.surah.number,
                );

                // ----------------------------------------------
                // Mushaf Pages
                // ----------------------------------------------

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

                    // First page Basmala
                    final bool showBasmala =
                        index == 0 &&
                        widget.surahNumber != 9 &&
                        widget.surahNumber != 1;

                    return MushafPageBlock(
                      key: blockKey,

                      page: page,

                      selectedAyahNumber: state.selectedAyahNumber,

                      highlightedAyahs: highlightsForSurah,

                      onAyahTap: (ayah) {
                        context.read<QuranCubit>().selectAyah(
                          ayah.numberInSurah,
                        );

                        _showAyahActions(
                          context,
                          state,
                          ayah,
                          highlightsForSurah[ayah.numberInSurah],
                        );
                      },

                      showBasmala: showBasmala,
                    );
                  },
                );
              },
            );
          }

          // ----------------------------------------------------
          // Error
          // ----------------------------------------------------

          if (state is QuranError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Container(
                      width: 58.w,
                      height: 58.w,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        color: accentColor.withValues(alpha: .08),
                      ),

                      child: Icon(
                        Icons.menu_book_rounded,
                        size: 28.sp,
                        color: accentColor,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.6,
                        color: textColor.withValues(alpha: .75),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    FilledButton.icon(
                      onPressed: () {
                        context.read<QuranCubit>().loadSurahPaged(
                          widget.surahNumber,
                        );
                      },

                      icon: const Icon(Icons.refresh_rounded),

                      label: const Text('إعادة المحاولة'),

                      style: FilledButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 11.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ============================================================
  // Ayah Actions
  // ============================================================

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

        onHighlight: (color) => context.read<AyahHighlightCubit>().setHighlight(
          state.surah.number,
          ayah.numberInSurah,
          color,
        ),

        onRemoveHighlight: () => context
            .read<AyahHighlightCubit>()
            .removeHighlight(state.surah.number, ayah.numberInSurah),

        onTafsir: () {
          Navigator.pop(sheetContext);

          Navigator.pushNamed(
            context,
            AppRoutes.quranTafsir,
            arguments: {
              'ayahNumber': ayah.numberInSurah,

              'ayahText': ayah.text,

              'tafsirText':
                  'تفسير الآية ${ayah.numberInSurah} من سورة ${state.surah.displayName}',

              'tafsirSource': 'تفسير ابن كثير',
            },
          );
        },
      ),
    );
  }
}
