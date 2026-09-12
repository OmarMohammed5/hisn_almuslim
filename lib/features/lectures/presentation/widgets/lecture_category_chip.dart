import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

class LectureCategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const LectureCategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    final foreground = selected ? colorScheme.primary : colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 17)),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, 17),
            ),
            color: bgColor,
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              if (!selected)
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.06 : 0.025),
                  blurRadius: AppResponsive.radius(context, 8),
                  offset: Offset(0, AppResponsive.heightValue(context, 3)),
                ),
            ],
          ),

          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.widthValue(context, 6),
              vertical: AppResponsive.heightValue(context, 10),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                // Icon
                Container(
                  width: AppResponsive.widthValue(context, 40),
                  height: AppResponsive.widthValue(context, 40),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? AppColors.kPrimary.withValues(alpha: 0.14)
                        : AppColors.kPrimary.withValues(
                            alpha: isDark ? 0.14 : 0.10,
                          ),
                  ),
                  child: Icon(
                    icon,
                    size: AppResponsive.fontSize(context, 20),
                    color: AppColors.kPrimary,
                  ),
                ),

                SizedBox(height: AppResponsive.heightValue(context, 8)),

                // Label
                CustomText(
                  label,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  fontSize: AppResponsive.fontSize(context, 9.4),
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  color: foreground,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
