// lib/features/quran/presentation/widgets/ayah_badge.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/arabic_digits.dart';
import '../theme/mushaf_colors.dart';

class AyahBadge extends StatelessWidget {
  final int numberInSurah;
  final bool isBookmarked;
  final Color? highlightColor;

  const AyahBadge({
    super.key,
    required this.numberInSurah,
    this.isBookmarked = false,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ringColor = highlightColor ??
        (isDark ? MushafColors.goldDark : MushafColors.gold);

    return Container(
      width: 24.w,
      height: 24.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor.withOpacity(0.8), width: 1),
        color: highlightColor != null
            ? highlightColor!.withOpacity(0.22)
            : Colors.transparent,
      ),
      child: Text(
        toArabicDigits(numberInSurah),
        style: TextStyle(
          fontSize: 10.5.sp,
          color: ringColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}