import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
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

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return Scaffold(
      body: SafeArea(
        child: AppResponsive.constrain(
          context,
          maxWidth: 700,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppResponsive.widthValue(context, 22),
              AppResponsive.heightValue(context, 35),
              AppResponsive.widthValue(context, 22),
              AppResponsive.heightValue(context, 25),
            ),
            child: Column(
              children: [
                _ResultIcon(passed: args.passed),
                SizedBox(height: AppResponsive.heightValue(context, 22)),
                CustomText(
                  args.passed ? 'أحسنت!' : 'حاول مرة أخرى',
                  textAlign: TextAlign.center,
                  fontSize: AppResponsive.fontSize(context, 24),
                  fontWeight: FontWeight.w900,
                  color: QuizColors.textPrimary(context),
                ),
                SizedBox(height: AppResponsive.heightValue(context, 12)),
                CustomText(
                  args.passed
                      ? 'لقد اجتزت المستوى بنجاح'
                      : 'يمكنك إعادة المستوى وتحسين نتيجتك',
                  textAlign: TextAlign.center,
                  fontSize: AppResponsive.fontSize(context, 14),
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0x99F3F6F4)
                      : const Color(0x9914211A),
                  height: 1.5,
                ),
                if (args.passed) ...[
                  SizedBox(height: AppResponsive.heightValue(context, 14)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.widthValue(context, 14),
                      vertical: AppResponsive.heightValue(context, 8),
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      border: Border.all(color: borderColor, width: 1),
                      borderRadius: BorderRadius.circular(QuizRadius.pill),
                    ),
                    child: CustomText(
                      'المستوى التالي مفتوح الآن',
                      fontSize: AppResponsive.fontSize(context, 13),
                      fontWeight: FontWeight.w700,
                      color: QuizColors.success,
                    ),
                  ),
                ],
                SizedBox(height: AppResponsive.heightValue(context, 30)),
                QuizScoreDisplay(score: args.score, stars: args.stars),
                SizedBox(height: AppResponsive.heightValue(context, 25)),
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
                    SizedBox(width: AppResponsive.widthValue(context, 12)),
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
                SizedBox(height: AppResponsive.heightValue(context, 30)),
                SizedBox(
                  width: double.infinity,
                  height: AppResponsive.heightValue(context, 58),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppResponsive.radius(context, QuizRadius.md),
                        ),
                      ),
                    ),
                    child: CustomText(
                      'العودة للمستويات',
                      fontSize: AppResponsive.fontSize(context, 13),
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
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
        width: AppResponsive.widthValue(context, 85),
        height: AppResponsive.widthValue(context, 85),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: .12),
        ),
        child: Icon(
          passed ? Icons.emoji_events_rounded : Icons.refresh_rounded,
          size: AppResponsive.fontSize(context, 50),
          color: color,
        ),
      ),
    );
  }
}
