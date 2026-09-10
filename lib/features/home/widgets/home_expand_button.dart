import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../../../core/responsive/app_responsive.dart';

class HomeExpandButton extends StatelessWidget {
  const HomeExpandButton({
    super.key,
    required this.expanded,
    required this.onTap,
  });

  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tealColor = isDark ? Colors.teal.shade300 : AppColors.kPrimary;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 30)),
          splashColor: tealColor.withOpacity(0.08),
          highlightColor: tealColor.withOpacity(0.04),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 18), vertical: AppResponsive.heightValue(context, 9)),
            decoration: BoxDecoration(
              color: isDark
                  ? tealColor.withOpacity(0.10)
                  : AppColors.kPrimaryLight.withOpacity(0.7),
              borderRadius: BorderRadius.circular(AppResponsive.radius(context, 30)),
              border: Border.all(color: tealColor.withOpacity(0.25)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  expanded ? 'عرض أقل' : 'عرض الكل',
                  fontSize: AppResponsive.fontSize(context, 12),
                  fontWeight: FontWeight.w700,
                  color: tealColor,
                ),
                SizedBox(width: AppResponsive.widthValue(context, 6)),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeInOut,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: AppResponsive.fontSize(context, 18),
                    color: tealColor,
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