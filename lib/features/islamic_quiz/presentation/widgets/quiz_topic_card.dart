import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../../domain/entities/topic_entity.dart';
import '../theme/quiz_tokens.dart';
import 'quiz_press_scale.dart';

class QuizTopicCard extends StatelessWidget {
  const QuizTopicCard({
    super.key,
    required this.topic,
    required this.onTap,
    this.completedLevels = 0,
  });

  final TopicEntity topic;
  final VoidCallback onTap;
  final int completedLevels;

  @override
  Widget build(BuildContext context) {
    final total = topic.levels.length;
    final progress = total == 0 ? 0.0 : completedLevels / total;
    final hasProgress = completedLevels > 0;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return QuizPressScale(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, QuizRadius.md),
          ),
          child: Ink(
            padding: EdgeInsets.all(AppResponsive.widthValue(context, 17)),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(
                AppResponsive.radius(context, QuizRadius.md),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: AppResponsive.widthValue(context, 45),
                  height: AppResponsive.widthValue(context, 45),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: bgColor,
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: AppResponsive.fontSize(context, 20),
                    color: AppColors.kPrimary,
                  ),
                ),
                SizedBox(
                  width: AppResponsive.widthValue(context, QuizSpacing.md),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        topic.name,
                        fontSize: AppResponsive.fontSize(context, 16),
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(height: AppResponsive.heightValue(context, 6)),
                      if (hasProgress) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(QuizRadius.pill),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: progress),
                            duration: QuizDurations.slow,
                            curve: Curves.easeOut,
                            builder: (context, value, _) =>
                                LinearProgressIndicator(
                                  value: value,
                                  minHeight: AppResponsive.heightValue(
                                    context,
                                    6,
                                  ),
                                  backgroundColor: QuizColors.border(context),
                                  valueColor: AlwaysStoppedAnimation(
                                    QuizColors.primary(context),
                                  ),
                                ),
                          ),
                        ),
                        SizedBox(height: AppResponsive.heightValue(context, 6)),
                        CustomText(
                          'اكتمل $completedLevels من $total مستويات',
                          fontWeight: FontWeight.w600,
                          fontSize: AppResponsive.fontSize(context, 13),
                        ),
                      ] else
                        CustomText(
                          '$total مستويات',
                          fontWeight: FontWeight.w400,
                          fontSize: AppResponsive.fontSize(context, 11),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: AppResponsive.widthValue(context, QuizSpacing.sm),
                ),
                Container(
                  width: AppResponsive.widthValue(context, 27),
                  height: AppResponsive.widthValue(context, 27),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: bgColor,
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: AppResponsive.fontSize(context, 14),
                    color: AppColors.kPrimary,
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
