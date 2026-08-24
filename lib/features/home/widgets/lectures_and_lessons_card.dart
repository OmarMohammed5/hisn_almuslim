import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/shared/custom_text.dart';
import '../../../core/theme/radio_colors.dart';

/// Redesigned to visually match CairoRadioCard's gradient/border/shadow
/// language so Radio + Lectures read as a matched pair of "listen now"
/// features. Navigation and SharedPreferences usage are unchanged.
class LecturesAndLessonsCard extends StatelessWidget {
  const LecturesAndLessonsCard({super.key});

  Future<void> _openLectures(BuildContext context) async {
    final preferences = await SharedPreferences.getInstance();
    if (!context.mounted) return;
    Navigator.pushNamed(
      context,
      AppRoutes.lectures,
      arguments: preferences,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final tealPrimary = isDark
        ? const Color(0xFF35AFA3)
        : RadioColors.lightPrimary;

    final tealDark = isDark
        ? const Color(0xFF102A27)
        : RadioColors.lightTealDark;

    final tealMedium = isDark
        ? const Color(0xFF4BC2B6)
        : RadioColors.lightTealMedium;

    final tealSoft = isDark
        ? const Color(0xFF173632)
        : RadioColors.lightTealSoft;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(22.r),
          onTap: () => _openLectures(context),
          splashColor: tealMedium.withValues(alpha: 0.10),
          highlightColor: tealMedium.withValues(alpha: 0.05),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r),

              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: isDark
                    ? const [
                  Color(0xFF152522),
                  Color(0xFF101A19),
                ]
                    : [
                  tealPrimary.withValues(alpha: 0.10),
                  tealDark.withValues(alpha: 0.04),
                ],
              ),

              border: Border.all(
                color: isDark
                    ? tealPrimary.withValues(alpha: 0.25)
                    : tealMedium.withValues(alpha: 0.28),
                width: 1,
              ),

              boxShadow: isDark
                  ? [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.20,
                  ),
                  blurRadius: 12.r,
                  offset: Offset(0, 5.h),
                ),
              ]
                  : [
                BoxShadow(
                  color: tealPrimary.withValues(
                    alpha: 0.07,
                  ),
                  blurRadius: 18.r,
                  offset: Offset(0, 7.h),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tealSoft.withValues(alpha: isDark ? 0.75 : 0.85),
                    border: Border.all(
                      color: tealMedium.withValues(alpha: isDark ? 0.40 : 0.25),
                    ),
                  ),
                  child: Icon(
                    Icons.video_collection_outlined,
                    color: tealPrimary,
                    size: 26.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'المحاضرات والدروس',
                        fontSize: 15.5.sp,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                      SizedBox(height: 6.h),
                      CustomText(
                        'استمع إلى دروس ومحاضرات إيمانية',
                        fontSize: 11.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.60),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tealMedium.withValues(alpha: isDark ? 0.16 : 0.10),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14.sp,
                    color: tealPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}