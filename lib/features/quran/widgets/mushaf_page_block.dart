import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/quran/widgets/basmala_widget.dart';
import '../../../core/shared/custom_text.dart';
import '../data/cubit/ayah_highlight_state.dart';
import '../domain/entities/ayah_entity.dart';
import '../domain/entities/mushaf_page_entity.dart';
import 'ayah_badge.dart';
import 'page_footer.dart';
import 'reader_settings.dart';

class MushafPageBlock extends StatefulWidget {
  final MushafPageEntity page;
  final int? selectedAyahNumber;
  final Map<int, HighlightData> highlightedAyahs;
  final ValueChanged<AyahEntity> onAyahTap;
  final bool showBasmala;
  final double fontSize;
  final QuranReadingMode mode;
  final bool darkMode;
  final int settingsRevision;

  const MushafPageBlock({
    super.key,
    required this.page,
    required this.onAyahTap,
    this.highlightedAyahs = const {},
    this.selectedAyahNumber,
    this.showBasmala = false,
    this.fontSize = 21,
    this.mode = QuranReadingMode.continuous,
    required this.darkMode,
    required this.settingsRevision,
  });

  @override
  State<MushafPageBlock> createState() => MushafPageBlockState();
}

class MushafPageBlockState extends State<MushafPageBlock> {
  final Map<int, TapGestureRecognizer> _recognizers = {};

  final Map<int, GlobalKey> _ayahKeys = {};

  static const _lightText = Color(0xFF292C29);

  static const _darkText = Color(0xFFE8E0CC);

  static const _lightTeal = Color(0xFF16877D);

  static const _darkTeal = Color(0xFF66C7BB);

  static const _lightGold = Color(0xFFB59A5A);

  static const _darkGold = Color(0xFFCDB878);

  TapGestureRecognizer _recognizerFor(AyahEntity ayah) {
    return _recognizers.putIfAbsent(
      ayah.numberInSurah,
      () => TapGestureRecognizer()..onTap = () => widget.onAyahTap(ayah),
    );
  }

  GlobalKey _keyFor(int number) {
    return _ayahKeys.putIfAbsent(number, () => GlobalKey());
  }

  void _disposeRecognizers() {
    for (final recognizer in _recognizers.values) {
      recognizer.dispose();
    }

    _recognizers.clear();
    _ayahKeys.clear();
  }

  @override
  void didUpdateWidget(covariant MushafPageBlock oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.page.pageNumber != widget.page.pageNumber) {
      _disposeRecognizers();
    }
  }

  @override
  void dispose() {
    _disposeRecognizers();

    super.dispose();
  }

  int? topVisibleAyahNumber({required double thresholdY}) {
    int? result;

    double bestY = -double.infinity;

    for (final entry in _ayahKeys.entries) {
      final ctx = entry.value.currentContext;

      if (ctx == null) {
        continue;
      }

      final renderObject = ctx.findRenderObject();

      if (renderObject is! RenderBox) {
        continue;
      }

      if (!renderObject.attached) {
        continue;
      }

      final position = renderObject.localToGlobal(Offset.zero);

      final y = position.dy;

      if (y <= thresholdY && y > bestY) {
        bestY = y;
        result = entry.key;
      }
    }

    return result;
  }

  bool _isFatihaBasmala(AyahEntity ayah) {
    return widget.page.pageNumber == 1 && ayah.numberInSurah == 1;
  }

  @override
  Widget build(BuildContext context) {
    final dark = widget.darkMode;

    final base = dark ? _darkText : _lightText;

    final accent = dark ? _darkTeal : _lightTeal;

    final gold = dark ? _darkGold : _lightGold;

    final content = switch (widget.mode) {
      QuranReadingMode.continuous => _buildContinuous(
        context,
        dark,
        base,
        accent,
        gold,
      ),

      QuranReadingMode.tajweed => _buildAyahMode(
        context,
        dark,
        base,
        accent,
        gold,
      ),
      QuranReadingMode.page => _buildPage(context, dark, base, accent, gold),
      QuranReadingMode.qari => _buildQari(context, dark, base, accent, gold),
      QuranReadingMode.focus => _buildQari(context, dark, base, accent, gold),
    };

    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.mode == QuranReadingMode.page ? 7.w : 16.w,

          vertical: widget.mode == QuranReadingMode.page ? 4.h : 8.h,
        ),

        child: content,
      ),
    );
  }

  Widget _buildPage(
    BuildContext context,
    bool dark,
    Color base,
    Color accent,
    Color gold,
  ) {
    final paper = dark ? const Color(0xFF171D1A) : const Color(0xFFFBF6EA);

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,

        padding: EdgeInsets.fromLTRB(14.w, 15.h, 14.w, 10.h),

        decoration: BoxDecoration(
          color: paper,

          borderRadius: BorderRadius.circular(8.r),

          border: Border.all(color: gold.withValues(alpha: .10)),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? .12 : .035),

              blurRadius: 18.r,

              offset: Offset(0, 7.h),
            ),
          ],
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            // BASMALA
            if (widget.showBasmala) BasmalaWidget(dark: dark, gold: gold),

            SizedBox(height: 2.h),

            // QURAN TEXT
            RichText(
              textAlign: TextAlign.right,

              textDirection: TextDirection.rtl,

              softWrap: true,

              text: TextSpan(children: _buildPageSpans(base, accent)),
            ),

            SizedBox(height: 10.h),

            // PAGE FOOTER
            PageFooter(page: widget.page),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  // PAGE SPANS
  List<InlineSpan> _buildPageSpans(Color base, Color selection) {
    final spans = <InlineSpan>[];

    for (final ayah in widget.page.ayahs) {
      if (_isFatihaBasmala(ayah)) {
        continue;
      }

      final selected = widget.selectedAyahNumber == ayah.numberInSurah;

      final highlight = widget.highlightedAyahs[ayah.numberInSurah];

      // AYAH TEXT
      spans.add(
        TextSpan(
          text: '${ayah.text} ',

          recognizer: _recognizerFor(ayah),

          style: TextStyle(
            fontFamily: 'QuranFont',

            fontSize: widget.fontSize.sp,

            height: 2.02,

            color: selected ? selection : base,

            backgroundColor:
                highlight?.color.withValues(alpha: .18) ??
                (selected ? selection.withValues(alpha: .08) : null),
          ),
        ),
      );

      // AYAH NUMBER
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,

          child: KeyedSubtree(
            key: _keyFor(ayah.numberInSurah),

            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),

              child: AyahBadge(
                numberInSurah: ayah.numberInSurah,

                isBookmarked: highlight != null,

                highlightColor: highlight?.color,
              ),
            ),
          ),
        ),
      );

      spans.add(const TextSpan(text: '   '));
    }

    return spans;
  }

  // CONTINUOUS MODE
  Widget _buildContinuous(
    BuildContext context,
    bool dark,
    Color base,
    Color accent,
    Color gold,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // BASMALA
          if (widget.showBasmala) BasmalaWidget(dark: dark, gold: gold),
          ...widget.page.ayahs.map((ayah) {
            if (_isFatihaBasmala(ayah)) {
              return const SizedBox.shrink();
            }
            final selected = widget.selectedAyahNumber == ayah.numberInSurah;
            final highlight = widget.highlightedAyahs[ayah.numberInSurah];

            return Container(
              key: _keyFor(ayah.numberInSurah),

              decoration: BoxDecoration(
                color: selected ? accent.withValues(alpha: .055) : null,

                borderRadius: BorderRadius.circular(13.r),
              ),

              child: InkWell(
                onTap: () => widget.onAyahTap(ayah),

                borderRadius: BorderRadius.circular(13.r),

                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 4.w),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: [
                      Text(
                        ayah.text,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'QuranFont',
                          fontSize: widget.fontSize.sp,
                          height: 1.9,
                          color: selected ? accent : base,
                          backgroundColor: highlight?.color.withValues(
                            alpha: .16,
                          ),
                        ),
                      ),

                      SizedBox(height: 5.h),

                      Row(
                        children: [
                          AyahBadge(
                            numberInSurah: ayah.numberInSurah,

                            isBookmarked: highlight != null,

                            highlightColor: highlight?.color,
                          ),
                        ],
                      ),

                      if (ayah != widget.page.ayahs.last)
                        Padding(
                          padding: EdgeInsets.only(top: 5.h),

                          child: Divider(
                            height: 1,

                            color: gold.withValues(alpha: .10),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),

          SizedBox(height: 4.h),

          PageFooter(page: widget.page),

          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  // AYAH / TAJWEED MODE
  Widget _buildAyahMode(
    BuildContext context,
    bool dark,
    Color base,
    Color accent,
    Color gold,
  ) {
    final surface = dark ? const Color(0xFF19211E) : const Color(0xFFF2ECDE);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.showBasmala) BasmalaWidget(dark: dark, gold: gold),
          ...widget.page.ayahs.map((ayah) {
            if (_isFatihaBasmala(ayah)) {
              return const SizedBox.shrink();
            }

            final selected = widget.selectedAyahNumber == ayah.numberInSurah;

            final highlight = widget.highlightedAyahs[ayah.numberInSurah];

            return Container(
              key: _keyFor(ayah.numberInSurah),

              margin: EdgeInsets.only(bottom: 6.h),

              padding: EdgeInsets.fromLTRB(10.w, 11.h, 10.w, 11.h),

              decoration: BoxDecoration(
                color: selected
                    ? accent.withValues(alpha: .08)
                    : highlight != null
                    ? highlight.color.withValues(alpha: .12)
                    : surface,

                borderRadius: BorderRadius.circular(17.r),

                border: Border.all(
                  color: selected
                      ? accent.withValues(alpha: .45)
                      : gold.withValues(alpha: .10),
                ),
              ),

              child: InkWell(
                onTap: () => widget.onAyahTap(ayah),

                borderRadius: BorderRadius.circular(17.r),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    CustomText(
                      ayah.text,
                      textAlign: TextAlign.right,
                      fontFamily: 'Noon',
                      fontSize: widget.fontSize.sp,
                      height: 1.95,
                      color: selected ? accent : base,
                    ),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AyahBadge(
                        numberInSurah: ayah.numberInSurah,
                        isBookmarked: highlight != null,
                        highlightColor: highlight?.color,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 4.h),
          PageFooter(page: widget.page),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  // QARI MODE
  Widget _buildQari(
    BuildContext context,
    bool dark,
    Color base,
    Color accent,
    Color gold,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          if (widget.showBasmala) BasmalaWidget(dark: dark, gold: gold),
          ...widget.page.ayahs.map((ayah) {
            if (_isFatihaBasmala(ayah)) {
              return const SizedBox.shrink();
            }

            final selected = widget.selectedAyahNumber == ayah.numberInSurah;
            final highlight = widget.highlightedAyahs[ayah.numberInSurah];

            return Container(
              key: _keyFor(ayah.numberInSurah),
              margin: EdgeInsets.only(bottom: 4.h),
              decoration: BoxDecoration(
                color: selected
                    ? gold.withValues(alpha: .08)
                    : highlight?.color.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: InkWell(
                onTap: () => widget.onAyahTap(ayah),
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
                  child: Text(
                    ayah.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'QuranFont',
                      fontSize: (widget.fontSize + 1).sp,
                      height: 2.05,
                      color: selected ? gold : base,
                    ),
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 4.h),
          PageFooter(page: widget.page),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
