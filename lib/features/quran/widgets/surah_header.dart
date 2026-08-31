import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/arabic_digits.dart';
import '../domain/entities/surah_entity.dart';
import '../theme/mushaf_colors.dart';

class SurahHeader extends StatelessWidget {
  final SurahEntity surah;

  const SurahHeader({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: 170.h,
      pinned: true,
      stretch: true,
      backgroundColor:
      isDark ? MushafColors.paperDarkDeep : MushafColors.paperLightDeep,
      iconTheme: IconThemeData(
        color: isDark ? MushafColors.goldDark : MushafColors.gold,
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          surah.displayName,
          style: TextStyle(
            fontFamily: 'Uthmani',
            fontSize: 20.sp,
            color: isDark ? Colors.white : MushafColors.inkLight,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [MushafColors.paperDark, MushafColors.paperDarkDeep]
                  : [MushafColors.paperLight, MushafColors.paperLightDeep],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'سُورَةُ ${surah.displayName}',
                  style: TextStyle(
                    fontFamily: 'Uthmanic',
                    fontSize: 30.sp,
                    color: isDark ? MushafColors.goldDark : MushafColors.gold,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _chip(surah.englishName, isDark),
                    SizedBox(width: 8.w),
                    _chip(surah.revelationType, isDark),
                    SizedBox(width: 8.w),
                    _chip('${toArabicDigits(surah.totalAyahs)} آية', isDark),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(String text, bool isDark) {
    final color = isDark ? MushafColors.goldDark : MushafColors.gold;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(text, style: TextStyle(fontSize: 11.sp, color: color)),
    );
  }
}