import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
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
              padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
              child: Icon(
                Icons.close_rounded,
                size: AppResponsive.fontSize(context, 20),
                color: QuizColors.textPrimary(context),
              ),
            ),
          ),
        ),
        SizedBox(width: AppResponsive.widthValue(context, QuizSpacing.sm)),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(QuizRadius.pill),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: QuizDurations.slow,
              curve: Curves.easeOut,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: AppResponsive.heightValue(context, 9),
                backgroundColor: QuizColors.border(context),
                valueColor: AlwaysStoppedAnimation(QuizColors.primary(context)),
              ),
            ),
          ),
        ),
        SizedBox(width: AppResponsive.widthValue(context, 12)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.widthValue(context, 10),
            vertical: AppResponsive.heightValue(context, 6),
          ),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(QuizRadius.pill),
          ),
          child: CustomText(
            '$currentQuestion / $totalQuestions',
            fontSize: AppResponsive.fontSize(context, 13),
            fontWeight: FontWeight.w700,
            color: QuizColors.primary(context),
          ),
        ),
      ],
    );
  }
}
