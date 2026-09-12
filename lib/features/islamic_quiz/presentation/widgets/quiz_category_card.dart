import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../../domain/entities/main_category_entity.dart';
import '../theme/quiz_tokens.dart';
import 'quiz_press_scale.dart';

class QuizCategoryCard extends StatelessWidget {
  const QuizCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  final MainCategoryEntity category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return QuizPressScale(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, QuizRadius.lg),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, QuizRadius.lg),
          ),
          child: Ink(
            padding: EdgeInsets.all(AppResponsive.widthValue(context, 18)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppResponsive.radius(context, QuizRadius.lg),
              ),
              color: bgColor,
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: AppResponsive.widthValue(context, 45),
                  height: AppResponsive.widthValue(context, 45),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppResponsive.radius(context, QuizRadius.md),
                    ),
                    color: bgColor,
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.auto_stories_rounded,
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
                    spacing: AppResponsive.heightValue(context, 10),
                    children: [
                      CustomText(
                        category.arabicName,
                        fontWeight: FontWeight.w700,
                        fontSize: AppResponsive.fontSize(context, 14),
                      ),

                      CustomText(
                        '${category.topics.length} موضوع',
                        fontSize: AppResponsive.fontSize(context, 11),
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
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
