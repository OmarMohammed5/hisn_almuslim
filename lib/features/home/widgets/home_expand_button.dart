import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

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
          borderRadius: BorderRadius.circular(30.r),
          splashColor: tealColor.withOpacity(0.08),
          highlightColor: tealColor.withOpacity(0.04),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: isDark
                  ? tealColor.withOpacity(0.10)
                  : AppColors.kPrimaryLight.withOpacity(0.7),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: tealColor.withOpacity(0.25)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  expanded ? 'عرض أقل' : 'عرض الكل',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: tealColor,
                ),
                SizedBox(width: 6.w),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeInOut,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18.sp,
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