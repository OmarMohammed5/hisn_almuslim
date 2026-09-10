import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

class CategoryCardWidget extends StatelessWidget {
  const CategoryCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(AppResponsive.radius(context, 18));

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;
    final iconBg = isDark
        ? AppColors.kPrimaryMedium.withValues(alpha: 0.16)
        : AppColors.kPrimaryLight;
    final iconColor = isDark ? Colors.teal.shade300 : AppColors.kPrimary;
    final textColor = isDark ? Colors.white : const Color(0xFF13251F);

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        splashColor: AppColors.kPrimary.withValues(alpha: 0.08),
        highlightColor: AppColors.kPrimary.withValues(alpha: 0.04),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 12), vertical: AppResponsive.heightValue(context, 10)), // بدل all(AppResponsive.widthValue(context, 14))
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: radius,
            border: Border.all(color: borderColor, width: 1),
            boxShadow:
            isDark
                ? const []
                : [
              BoxShadow(
                color: AppColors.kPrimary.withValues(alpha: 0.05),
                blurRadius: AppResponsive.radius(context, 6),
                offset: Offset(0, AppResponsive.heightValue(context, 3)),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: AppResponsive.heightValue(context, 10),
            children: [
              Container(
                width: AppResponsive.widthValue(context, 45),
                height: AppResponsive.widthValue(context, 45),
                decoration: BoxDecoration(
                  color: iconBg,
                 borderRadius: BorderRadius.circular(AppResponsive.radius(context, 10)),
                ),
                child: Icon(icon, size: AppResponsive.fontSize(context, 20), color: iconColor),
              ),
              CustomText(
                title,
                fontSize: AppResponsive.fontSize(context, 11),
                fontWeight: FontWeight.w700,
                color: textColor,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}