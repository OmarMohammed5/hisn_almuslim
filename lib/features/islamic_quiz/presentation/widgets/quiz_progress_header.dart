import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../../../../core/theme/app_colors.dart';
import '../theme/quiz_tokens.dart';

class QuizProgressHeader extends StatelessWidget {
  const QuizProgressHeader({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.progress,
  });

  final int currentQuestion;
  final int totalQuestions;
  final double progress;

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;



    return Row(
      children: [
        Material(
          color: bgColor,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                Icons.close_rounded,
                size: 20.sp,
                color: QuizColors.textPrimary(context),
              ),
            ),
          ),
        ),
        SizedBox(width: QuizSpacing.sm.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(QuizRadius.pill),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: QuizDurations.slow,
              curve: Curves.easeOut,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 9.h,
                backgroundColor: QuizColors.border(context),
                valueColor: AlwaysStoppedAnimation(QuizColors.primary(context)),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(QuizRadius.pill),
          ),
          child: CustomText(
            '$currentQuestion / $totalQuestions',
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: QuizColors.primary(context),
          ),
        ),
      ],
    );
  }
}
