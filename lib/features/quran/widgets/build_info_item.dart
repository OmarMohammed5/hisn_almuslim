import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/shared/custom_text.dart';

class BuildInfoItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color primary;

  const BuildInfoItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 5.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: .035)
            : Colors.white.withValues(alpha: .65),
        borderRadius: BorderRadius.circular(13.r),
        border: Border.all(
          color: primary.withValues(alpha: isDark ? .08 : .10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17.sp, color: primary),

          SizedBox(height: 3.h),

          CustomText(
            value,
            maxLines: 1,
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF173C38),
          ),

          SizedBox(height: 1.h),

          CustomText(
            label,
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white.withValues(alpha: .48)
                  : const Color(0xFF5B7773),
          ),
        ],
      ),
    );
  }
}