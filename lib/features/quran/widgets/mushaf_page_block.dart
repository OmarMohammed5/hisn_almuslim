import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/cubit/ayah_highlight_state.dart';
import '../domain/entities/ayah_entity.dart';
import '../domain/entities/mushaf_page_entity.dart';
import '../theme/mushaf_colors.dart';
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

  TapGestureRecognizer _recognizerFor(AyahEntity ayah) {
    return _recognizers.putIfAbsent(
      ayah.numberInSurah,
          () => TapGestureRecognizer()..onTap = () => widget.onAyahTap(ayah),
    );
  }

  GlobalKey _keyFor(int ayahNumberInSurah) {
    return _ayahKeys.putIfAbsent(ayahNumberInSurah, () => GlobalKey());
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
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;

      final globalY = box.localToGlobal(Offset.zero).dy;
      if (globalY <= thresholdY && globalY > bestY) {
        bestY = globalY;
        result = entry.key;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
    isDark ? Colors.white.withOpacity(0.92) : MushafColors.inkLight;
    final selectionColor = isDark ? MushafColors.goldDark : MushafColors.gold;

    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Basmala at the top center
            if (widget.showBasmala)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Image.asset(
                    'assets/images/basmala.png',
                    height: 45.h,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),

            // Ayah text
            RichText(
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              text: TextSpan(
                children: _buildSpans(baseColor, selectionColor),
              ),
            ),

            Divider(
              height: 24.h,
              thickness: 0.6,
              color: (isDark ? MushafColors.goldDark : MushafColors.gold)
                  .withOpacity(0.25),
            ),
            PageFooter(page: widget.page),
          ],
        ),
      ),
    );
  }

  List<InlineSpan> _buildSpans(Color baseColor, Color selectionColor) {
    final spans = <InlineSpan>[];

    for (final ayah in widget.page.ayahs) {
      final isSelected = widget.selectedAyahNumber == ayah.numberInSurah;
      final highlightData = widget.highlightedAyahs[ayah.numberInSurah];

      spans.add(TextSpan(
        text: '${ayah.text} ',
        recognizer: _recognizerFor(ayah),
        style: TextStyle(
          fontFamily: 'QuranFont',
          fontSize: 21.sp,
          height: 2.0,
          color: isSelected ? selectionColor : baseColor,
          backgroundColor: highlightData?.color.withOpacity(0.28) ??
              (isSelected ? selectionColor.withOpacity(0.10) : null),
        ),
      ));
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: KeyedSubtree(
          key: _keyFor(ayah.numberInSurah),
          child: AyahBadge(
            numberInSurah: ayah.numberInSurah,
            isBookmarked: highlightData != null,
          ),
        ),
      ));
      spans.add(const TextSpan(text: '   ', style: TextStyle(fontFamily: 'Noon')));
    }
    return spans;
  }
}