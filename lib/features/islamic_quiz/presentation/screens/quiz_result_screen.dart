import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../theme/quiz_tokens.dart';
import '../widgets/quiz_result_stat.dart';
import '../widgets/quiz_score_display.dart';

class QuizResultArgs {
  final int score;
  final int stars;
  final bool passed;
  final int correctAnswers;
  final int wrongAnswers;
  final int totalQuestions;

  const QuizResultArgs({
    required this.score,
    required this.stars,
    required this.passed,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalQuestions,
  });
}

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key, required this.args});

  final QuizResultArgs args;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(22.w, 35.h, 22.w, 25.h),
          child: Column(
            children: [
              _ResultIcon(passed: args.passed),
              SizedBox(height: 22.h),
              CustomText(
                args.passed ? 'أحسنت!' : 'حاول مرة أخرى',
                textAlign: TextAlign.center,
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
                color: QuizColors.textPrimary(context),
              ),
              SizedBox(height: 12.h),
              CustomText(
                args.passed
                    ? 'لقد اجتزت المستوى بنجاح'
                    : 'يمكنك إعادة المستوى وتحسين نتيجتك',
                textAlign: TextAlign.center,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? const Color(0x99F3F6F4)
                    : const Color(0x9914211A),
                height: 1.5,
              ),
              if (args.passed) ...[
                SizedBox(height: 14.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: QuizColors.successSoft,
                    borderRadius: BorderRadius.circular(QuizRadius.pill),
                  ),
                  child: CustomText(
                    'المستوى التالي مفتوح الآن',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: QuizColors.success,
                  ),
                ),
              ],
              SizedBox(height: 30.h),
              QuizScoreDisplay(score: args.score, stars: args.stars),
              SizedBox(height: 25.h),
              Row(
                children: [
                  Expanded(
                    child: QuizResultStat(
                      icon: Icons.check_circle_rounded,
                      value: '${args.correctAnswers}',
                      label: 'إجابة صحيحة',
                      color: QuizColors.success,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: QuizResultStat(
                      icon: Icons.cancel_rounded,
                      value: '${args.wrongAnswers}',
                      label: 'إجابة خاطئة',
                      color: QuizColors.error,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(QuizRadius.md.r),
                    ),
                  ),
                  child: CustomText(
                    'العودة للمستويات',
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultIcon extends StatelessWidget {
  const _ResultIcon({required this.passed});

  final bool passed;

  @override
  Widget build(BuildContext context) {
    final color = passed ? QuizColors.success : QuizColors.warning;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: QuizDurations.slow,
      curve: Curves.easeOutBack,
      builder: (context, t, child) => Transform.scale(scale: t, child: child),
      child: Container(
        width: 85.w,
        height: 85.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: .12),
        ),
        child: Icon(
          passed ? Icons.emoji_events_rounded : Icons.refresh_rounded,
          size: 50.sp,
          color: color,
        ),
      ),
    );
  }
}
