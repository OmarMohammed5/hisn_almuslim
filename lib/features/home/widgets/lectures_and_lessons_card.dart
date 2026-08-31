import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/shared/custom_text.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/radio_colors.dart';


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

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

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
              color: bgColor,
              border: Border.all(color: borderColor, width: 1),
              boxShadow:
              isDark
                  ? const []
                  : [
                BoxShadow(
                  color: AppColors.kPrimary.withValues(alpha: 0.05),
                  blurRadius: 6.r,
                  offset: Offset(0, 3.h),
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
                    color: tealSoft.withValues(alpha: isDark ? 0.45 : 0.85),
                    border: Border.all(
                      color: tealMedium.withValues(alpha: isDark ? 0.20 : 0.25),
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
                    color: tealMedium.withValues(alpha: isDark ? 0.16 : 0.17),
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