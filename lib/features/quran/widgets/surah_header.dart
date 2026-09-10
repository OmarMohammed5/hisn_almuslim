import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
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
      expandedHeight: AppResponsive.heightValue(context, 170),
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
            fontSize: AppResponsive.fontSize(context, 20),
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
                    fontSize: AppResponsive.fontSize(context, 30),
                    color: isDark ? MushafColors.goldDark : MushafColors.gold,
                  ),
                ),
                SizedBox(height: AppResponsive.heightValue(context, 6)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _chip(context, surah.englishName, isDark),
                    SizedBox(width: AppResponsive.widthValue(context, 8)),
                    _chip(context, surah.revelationType, isDark),
                    SizedBox(width: AppResponsive.widthValue(context, 8)),
                    _chip(context, '${toArabicDigits(surah.totalAyahs)} آية', isDark),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, String text, bool isDark) {
    final color = isDark ? MushafColors.goldDark : MushafColors.gold;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 10), vertical: AppResponsive.heightValue(context, 4)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
      ),
      child: Text(text, style: TextStyle(fontSize: AppResponsive.fontSize(context, 11), color: color)),
    );
  }
}