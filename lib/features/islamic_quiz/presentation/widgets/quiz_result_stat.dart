import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../../../../core/theme/app_colors.dart';
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

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppResponsive.heightValue(context, 18),
        horizontal: AppResponsive.widthValue(context, 12),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, QuizRadius.md),
        ),
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: AppResponsive.fontSize(context, 26), color: tint),
          SizedBox(height: AppResponsive.heightValue(context, 8)),
          CustomText(
            value,
            fontSize: AppResponsive.fontSize(context, 22),
            fontWeight: FontWeight.w900,
            color: QuizColors.textPrimary(context),
          ),
          SizedBox(height: AppResponsive.heightValue(context, 8)),
          CustomText(
            label,
            textAlign: TextAlign.center,
            fontSize: AppResponsive.fontSize(context, 13),
            fontWeight: FontWeight.w500,
            color: tint,
          ),
        ],
      ),
    );
  }
}
