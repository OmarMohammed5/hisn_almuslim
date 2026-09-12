import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
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

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppResponsive.widthValue(context, 24)),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, 20),
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
                    horizontal: AppResponsive.widthValue(context, 12),
                    vertical: AppResponsive.heightValue(context, 6),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primary, primary.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(
                      AppResponsive.radius(context, 30),
                    ),
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
                        size: AppResponsive.fontSize(context, 16),
                        color: Colors.white,
                      ),
                      SizedBox(width: AppResponsive.widthValue(context, 6)),
                      CustomText(
                        'سؤال',
                        fontSize: AppResponsive.fontSize(context, 11),
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
                      horizontal: AppResponsive.widthValue(context, 10),
                      vertical: AppResponsive.heightValue(context, 4),
                    ),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(
                        AppResponsive.radius(context, 30),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: AppResponsive.fontSize(context, 14),
                          color: primary,
                        ),
                        SizedBox(width: AppResponsive.widthValue(context, 4)),
                        Text(
                          '$questionNumber / $totalQuestions',
                          style: TextStyle(
                            fontSize: AppResponsive.fontSize(context, 11),
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

            Gap(AppResponsive.heightValue(context, 15)),

            // Question text with better styling
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.widthValue(context, 8),
              ),
              child: Text(
                question,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style:
                    textTheme.headlineSmall?.copyWith(
                      fontSize: AppResponsive.fontSize(context, 20),
                      fontWeight: FontWeight.w700,
                      fontFamily: "Noon",
                      height: 1.8,
                      color: isDark ? Colors.white : Colors.grey[900],
                      letterSpacing: 0.3,
                    ) ??
                    TextStyle(
                      fontSize: AppResponsive.fontSize(context, 20),
                      fontWeight: FontWeight.w700,
                      height: 1.8,
                      color: isDark ? Colors.white : Colors.grey[900],
                      fontFamily: "Noon",
                      letterSpacing: 0.3,
                    ),
              ),
            ),

            // Bottom decoration - subtle accent
            if (question.length > 50) // Only show for longer questions
              Padding(
                padding: EdgeInsets.only(
                  top: AppResponsive.heightValue(context, 16),
                ),
                child: Container(
                  width: AppResponsive.widthValue(context, 30),
                  height: AppResponsive.heightValue(context, 2),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppResponsive.radius(context, 10),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
