import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
class CategoryCardWidget extends StatelessWidget {
  const CategoryCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(16.r);

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;
    final iconBg = isDark
        ? AppColors.kPrimaryMedium.withValues(alpha: 0.16)
        : AppColors.kPrimaryLight;
    final iconColor = isDark ? Colors.teal.shade300 : AppColors.kPrimary;
    final textColor = isDark ? Colors.white : const Color(0xFF13251F);

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        splashColor: AppColors.kPrimary.withValues(alpha: 0.08),
        highlightColor: AppColors.kPrimary.withValues(alpha: 0.04),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h), // بدل all(14.w)
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: radius,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 10.h,
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: iconBg,
                 borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 16.sp, color: iconColor),
              ),
              CustomText(
                title,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w700,
                color: textColor,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}