import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final isDark = theme.brightness == Brightness.dark;

    final foreground = selected ? colorScheme.onPrimary : colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17.r),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.r),
            color: selected ? Colors.grey[750] : Colors.grey[750]?.withValues(alpha: isDark ? 0.10 : 0.055,),
            border: Border.all(color: selected ? AppColors.kPrimary : AppColors.kPrimary.withValues(alpha: isDark ? 0.18 : 0.10,), width: 1,),
            boxShadow: [
              if (!selected)
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.06 : 0.025,),
                  blurRadius: 8.r,
                  offset:
                  Offset(0, 3.h),
                ),
            ],
          ),

          child: Padding(
            padding:
            EdgeInsets.symmetric(
              horizontal: 6.w,
              vertical: 10.h,
            ),

            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [
                // Icon
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    shape:
                    BoxShape.circle,
                    color: selected ?  AppColors.kPrimary.withValues(alpha: 0.14) :
                    AppColors.kPrimary.withValues(alpha: isDark ? 0.14 : 0.10),
                  ),
                  child: Icon(
                    icon,
                    size: 20.sp,
                    color: AppColors.kPrimary
                  ),
                ),

                SizedBox(height: 8.h),

                // Label
                CustomText(
                  label,
                  maxLines: 2,
                  textAlign:
                  TextAlign.center,
                  fontSize: 10.5.sp,
                  fontWeight:
                  FontWeight.w700,
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