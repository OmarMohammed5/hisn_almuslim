import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../../../../core/theme/app_colors.dart';
import '../theme/quiz_tokens.dart';

class QuizResultStat extends StatelessWidget {
  const QuizResultStat({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? QuizColors.textSecondary(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;



    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(QuizRadius.md.r),
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 26.sp, color: tint),
          SizedBox(height: 8.h),
          CustomText(
            value,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: QuizColors.textPrimary(context),
          ),
          SizedBox(height: 8.h),
          CustomText(
            label,
            textAlign: TextAlign.center,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: tint,
          ),
        ],
      ),
    );
  }
}
