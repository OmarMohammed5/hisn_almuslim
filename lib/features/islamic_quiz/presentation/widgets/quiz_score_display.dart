import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../../../../core/theme/app_colors.dart';
import '../theme/quiz_tokens.dart';
import 'quiz_stars.dart';

class QuizScoreDisplay extends StatelessWidget {
  const QuizScoreDisplay({super.key, required this.score, required this.stars});

  final int score;
  final int stars;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: AppResponsive.heightValue(context, 25),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, QuizRadius.lg),
        ),
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: score),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => CustomText(
              '$value%',
              fontSize: AppResponsive.fontSize(context, 37),
              fontWeight: FontWeight.w900,
              color: QuizColors.primary(context),
            ),
          ),
          SizedBox(height: AppResponsive.heightValue(context, 12)),
          QuizStars(
            count: stars,
            size: AppResponsive.fontSize(context, 32),
            animate: true,
          ),
        ],
      ),
    );
  }
}
