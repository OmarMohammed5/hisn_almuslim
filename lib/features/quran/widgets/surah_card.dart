import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/quran/data/models/surah_model.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';

class SurahCard extends StatelessWidget {
  const SurahCard({super.key, required this.surah, this.onTap});

  final SurahModel surah;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Color(0xff1a1f24), Color(0xff252b31)]
                : [Color(0xffFAFBFC), Color(0xffF5F7F9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: isDark ? Color(0xff2d3338) : Color(0xffE5E9EC),
            width: 1.5.w,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              // Decorative number badge
              Container(
                width: 45.w,
                height: 45.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Color(0xff2d3338) : Color(0xffE9EEF0),
                ),
                child: Center(
                  child: CustomText(
                    surah.imageIndex.toString(),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Gap(16.w),

              // Surah details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Surah name
                    Text(
                      surah.name,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Al mushaf',
                        color: isDark ? Colors.white : Color(0xff1a1f24),
                        height: 1.2,
                      ),
                    ),

                    Gap(8.h),

                    // Ayah count
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 13.sp,
                          color: isDark ? Colors.white60 : Colors.black45,
                        ),
                        Gap(4.w),
                        CustomText(
                          "${surah.number} آية",
                          fontSize: 12.sp,
                          color: isDark ? Colors.white60 : Colors.black45,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Makkah/Madinah indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isDark ? Color(0xff2d3338) : Color(0xffE9EEF0),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isDark ? Color(0xff3a4147) : Color(0xffDDE3E6),
                    width: 1.w,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      surah.type == "مدنية"
                          ? "assets/icons/Madina.png"
                          : "assets/icons/Makka.png",
                      width: 26.w,
                      height: 26.h,
                    ),
                    Gap(4.w),
                    CustomText(
                      surah.type,
                      fontSize: 11.sp,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
