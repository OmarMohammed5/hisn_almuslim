import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/quran_audio/data/models/surah_audio_model.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/reciter_model.dart';

class SurahList extends StatelessWidget {
  final List<SurahAudioModel> surahs;
  final ReciterModel selectedReciter;
  final Function(int) onSurahPressed;
  final ScrollController? controller;

  const SurahList({
    super.key,
    required this.surahs,
    required this.selectedReciter,
    required this.onSurahPressed,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        controller: controller,
        padding: EdgeInsets.only(top: 4.h, bottom: 90.h),
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          final surah = surahs[index];
          return SurahTile(
            surah: surah,
            index: index,
            onPressed: () => onSurahPressed(surah.number),
          );
        },
      ),
    );
  }
}

// Surah Tile — unchanged, your styling stays exactly as-is
class SurahTile extends StatelessWidget {
  final SurahAudioModel surah;
  final int index;
  final VoidCallback onPressed;

  const SurahTile({
    super.key,
    required this.surah,
    required this.index,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 7.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xff1a1f24), const Color(0xff252b31)]
                : [const Color(0xffFAFBFC), const Color(0xffF5F7F9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: isDark ? const Color(0xff2d3338) : const Color(0xffE5E9EC),
            width: 1.5.w,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? const Color(0xff2d3338) : const Color(0xffE9EEF0),
                ),
                child: Center(
                  child: CustomText(
                    '${surah.number}',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Gap(16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "سورة ${surah.nameArabic}",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Al mushaf',
                        color: isDark ? Colors.white : const Color(0xff1a1f24),
                        height: 1.2,
                      ),
                    ),
                    Gap(8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 13.sp,
                          color: isDark ? Colors.white60 : Colors.black45,
                        ),
                        Gap(4.w),
                        CustomText(
                          "${surah.versesCount} آية",
                          fontSize: 10.sp,
                          color: isDark ? Colors.white60 : Colors.black45,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.play_circle_fill_outlined,
                color: AppColors.kIconColor,
                size: 18.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}