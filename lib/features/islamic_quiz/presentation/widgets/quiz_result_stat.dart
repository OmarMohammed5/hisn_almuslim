import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

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

    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(QuizRadius.md.r),
        color: QuizColors.card(context),
        border: Border.all(color: QuizColors.border(context)),
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
