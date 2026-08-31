import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/cubit/ayah_highlight_state.dart';
import '../domain/entities/ayah_entity.dart';
import '../domain/entities/mushaf_page_entity.dart';
import 'ayah_badge.dart';
import 'page_footer.dart';

class MushafPageBlock extends StatefulWidget {
  final MushafPageEntity page;

  final int? selectedAyahNumber;

  final Map<int, HighlightData> highlightedAyahs;

  final ValueChanged<AyahEntity> onAyahTap;

  final bool showBasmala;

  const MushafPageBlock({
    super.key,

    required this.page,

    required this.onAyahTap,

    this.highlightedAyahs = const {},

    this.selectedAyahNumber,

    this.showBasmala = false,
  });

  @override
  State<MushafPageBlock> createState() => MushafPageBlockState();
}

class MushafPageBlockState extends State<MushafPageBlock> {
  final Map<int, TapGestureRecognizer> _recognizers = {};

  final Map<int, GlobalKey> _ayahKeys = {};

  // ============================================================
  // Mushaf Palette
  // ============================================================

  static const Color _lightText = Color(0xFF292C29);

  static const Color _darkText = Color(0xFFE8E0CC);

  static const Color _lightTeal = Color(0xFF16877D);

  static const Color _darkTeal = Color(0xFF66C7BB);

  static const Color _lightGold = Color(0xFFB59A5A);

  static const Color _darkGold = Color(0xFFCDB878);

  // ============================================================
  // Recognizers
  // ============================================================

  TapGestureRecognizer _recognizerFor(AyahEntity ayah) {
    return _recognizers.putIfAbsent(
      ayah.numberInSurah,
      () => TapGestureRecognizer()..onTap = () => widget.onAyahTap(ayah),
    );
  }

  // ============================================================
  // Ayah Keys
  // ============================================================

  GlobalKey _keyFor(int ayahNumberInSurah) {
    return _ayahKeys.putIfAbsent(ayahNumberInSurah, () => GlobalKey());
  }

  // ============================================================
  // Dispose Recognizers
  // ============================================================

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

  // ============================================================
  // Get Top Visible Ayah
  // ============================================================

  int? topVisibleAyahNumber({required double thresholdY}) {
    int? result;

    double bestY = -double.infinity;

    for (final entry in _ayahKeys.entries) {
      final ctx = entry.value.currentContext;

      if (ctx == null) continue;

      final box = ctx.findRenderObject() as RenderBox?;

      if (box == null || !box.attached) {
        continue;
      }

      final globalY = box.localToGlobal(Offset.zero).dy;

      if (globalY <= thresholdY && globalY > bestY) {
        bestY = globalY;

        result = entry.key;
      }
    }

    return result;
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark ? _darkText : _lightText;

    final accentColor = isDark ? _darkTeal : _lightTeal;

    final goldColor = isDark ? _darkGold : _lightGold;

    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            // ==================================================
            // Basmala
            // ==================================================
            if (widget.showBasmala) _buildBasmala(context, isDark, goldColor),

            // ==================================================
            // Quran Text
            // ==================================================
            RichText(
              textAlign: TextAlign.right,

              textDirection: TextDirection.rtl,

              text: TextSpan(children: _buildSpans(baseColor, accentColor)),
            ),

            // ==================================================
            // Page Divider
            // ==================================================
            Padding(
              padding: EdgeInsets.only(top: 18.h),

              child: Container(
                height: 1,

                margin: EdgeInsets.symmetric(horizontal: 12.w),

                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,

                      goldColor.withValues(alpha: .22),

                      goldColor.withValues(alpha: .30),

                      goldColor.withValues(alpha: .22),

                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 8.h),

            // ==================================================
            // Footer
            // ==================================================
            PageFooter(page: widget.page),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Basmala
  // ============================================================

  Widget _buildBasmala(BuildContext context, bool isDark, Color goldColor) {
    final color = isDark ? goldColor : _lightTeal;

    return Padding(
      padding: EdgeInsets.only(top: 2.h, bottom: 18.h),

      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),

          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? .055 : .045),

            borderRadius: BorderRadius.circular(100.r),

            border: Border.all(
              color: color.withValues(alpha: isDark ? .16 : .12),
              width: 0.8,
            ),
          ),

          child: ColorFiltered(
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),

            child: Image.asset(
              'assets/images/basmala.png',

              height: 43.h,

              fit: BoxFit.contain,

              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Ayah Spans
  // ============================================================

  List<InlineSpan> _buildSpans(Color baseColor, Color selectionColor) {
    final spans = <InlineSpan>[];

    for (final ayah in widget.page.ayahs) {
      final isSelected = widget.selectedAyahNumber == ayah.numberInSurah;

      final highlightData = widget.highlightedAyahs[ayah.numberInSurah];

      // --------------------------------------------------------
      // Ayah
      // --------------------------------------------------------

      spans.add(
        TextSpan(
          text: '${ayah.text} ',

          recognizer: _recognizerFor(ayah),

          style: TextStyle(
            fontFamily: 'QuranFont',

            fontSize: 21.sp,

            height: 2.0,

            color: isSelected ? selectionColor : baseColor,

            backgroundColor: highlightData != null
                ? highlightData.color.withValues(alpha: .16)
                : isSelected
                ? selectionColor.withValues(alpha: .075)
                : null,
          ),
        ),
      );

      // --------------------------------------------------------
      // Ayah Badge
      // --------------------------------------------------------

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,

          child: KeyedSubtree(
            key: _keyFor(ayah.numberInSurah),

            child: AyahBadge(
              numberInSurah: ayah.numberInSurah,

              isBookmarked: highlightData != null,
            ),
          ),
        ),
      );

      // --------------------------------------------------------
      // Spacing
      // --------------------------------------------------------

      spans.add(
        const TextSpan(
          text: '   ',
          style: TextStyle(fontFamily: 'Noon'),
        ),
      );
    }

    return spans;
  }
}
