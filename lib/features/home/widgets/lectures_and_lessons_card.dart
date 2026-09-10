import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/shared/custom_text.dart';
import '../../../core/theme/app_colors.dart';

class LecturesAndLessonsCard extends StatelessWidget {
  const LecturesAndLessonsCard({super.key});

  Future<void> _openLectures(BuildContext context) async {
    final preferences = await SharedPreferences.getInstance();
    if (!context.mounted) return;

    Navigator.pushNamed(context, AppRoutes.lectures, arguments: preferences);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () => _openLectures(context),
        child: Ink(
          height: 200.h,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.kPrimary.withValues(
                  alpha: isDark ? .12 : .08,
                ),
                blurRadius: 20.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Main content
              Padding(
                padding: EdgeInsets.all(18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // Top row - Badge
                    _buildTopRow(isDark),
                    // Middle - Content
                    Expanded(child: _buildMainContent(isDark, scheme)),
                    // Bottom - Action button
                    _buildActionButton(isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.kPrimary.withValues(alpha: isDark ? .15 : .08),
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(
              color: AppColors.kPrimary.withValues(alpha: isDark ? .12 : .06),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle_rounded,
                size: 6.sp,
                color: const Color(0xFFC9A85D),
              ),
              Gap(6.w),
              CustomText(
                'محتوى صوتي ومرئي',
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : AppColors.kPrimary,
              ),
            ],
          ),
        ),
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: AppColors.kPrimary.withValues(alpha: isDark ? .12 : .06),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.kPrimary.withValues(alpha: isDark ? .15 : .08),
            ),
          ),
          child: Icon(
            Icons.headphones_rounded,
            size: 16.sp,
            color: AppColors.kPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(bool isDark, ColorScheme scheme) {
    return Row(
      children: [
        // Text content
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                'محاضرات ودروس',
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : const Color(0xFF17342E),
                height: 1.1,
              ),
              Gap(6.h),
              CustomText(
                'استكشف محاضرات مختارة من قنوات YouTube الإسلامية',
                fontSize: 11.sp,
                height: 1.5,
                maxLines: 2,
                color:
                    (isDark
                            ? Colors.white70
                            : const Color(0xFF17342E).withValues(alpha: .54))
                        .withValues(alpha: .7),
              ),
              Gap(14.h),
              // Tags
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: [
                  _buildTag('🎙️ بودكاست', isDark),
                  _buildTag('📚 دروس', isDark),
                  _buildTag('🎥 فيديوهات', isDark),
                ],
              ),
            ],
          ),
        ),
        Gap(12.w),
        // Visual element
        Expanded(flex: 3, child: _buildVisualElement(isDark)),
      ],
    );
  }

  Widget _buildTag(String text, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.kPrimary.withValues(alpha: isDark ? .12 : .06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.kPrimary.withValues(alpha: isDark ? .08 : .04),
        ),
      ),
      child: CustomText(
        text,
        fontSize: 8.5.sp,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white70 : AppColors.kPrimary,
      ),
    );
  }

  Widget _buildVisualElement(bool isDark) {

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : AppColors.kBorderLight;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Stack(
        children: [
          // Center icon
          Center(
            child: Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.kPrimary, AppColors.kPrimaryMedium],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kPrimary.withValues(alpha: .3),
                    blurRadius: 16.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                size: 28.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.kPrimary, AppColors.kPrimaryMedium],
            ),
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.kPrimary.withValues(alpha: .25),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                'استكشف الآن',
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              Gap(6.w),
              Icon(
                Icons.arrow_forward_rounded,
                size: 14.sp,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
