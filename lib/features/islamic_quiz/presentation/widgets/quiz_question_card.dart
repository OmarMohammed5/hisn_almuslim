import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../theme/quiz_tokens.dart';

class QuizQuestionCard extends StatelessWidget {
  const QuizQuestionCard({
    super.key,
    required this.question,
    this.questionNumber,
    this.totalQuestions,
    this.onTap,
  });

  final String question;
  final int? questionNumber;
  final int? totalQuestions;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final primary = QuizColors.primary(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    // Show progress if numbers are provided
    final showProgress = questionNumber != null && totalQuestions != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    QuizColors.card(context).withValues(alpha: 0.95),
                    QuizColors.card(context).withValues(alpha: 0.8),
                  ]
                : [Colors.white, Colors.white.withValues(alpha: 0.95)],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.kPrimary.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: -2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.05 : 0.02),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: -4,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with icon and label
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Question badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primary, primary.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.help_outline_rounded,
                        size: 16.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6.w),
                      CustomText(
                        'سؤال',
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                      ),
                    ],
                  ),
                ),

                // Progress indicator
                if (showProgress)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 14.sp,
                          color: primary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '$questionNumber / $totalQuestions',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: primary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            Gap(15.h),

            // Question text with better styling
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                question,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style:
                    textTheme.headlineSmall?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: "QuranFont",
                      height: 1.8,
                      color: isDark ? Colors.white : Colors.grey[900],
                      letterSpacing: 0.3,
                    ) ??
                    TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.8,
                      color: isDark ? Colors.white : Colors.grey[900],
                      fontFamily: "QuranFont",
                      letterSpacing: 0.3,
                    ),
              ),
            ),

            // Bottom decoration - subtle accent
            if (question.length > 50) // Only show for longer questions
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Container(
                  width: 30.w,
                  height: 2.h,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
