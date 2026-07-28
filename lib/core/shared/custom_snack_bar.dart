import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

SnackBar customSnackBar(
  String msg,
  IconData icon,
  BuildContext context, {
  Color? lightColor,
  Color? darkColor,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final Color bgColor = isDark
      ? (darkColor ?? Colors.grey.shade800)
      : (lightColor ?? Colors.grey.shade700);

  final Color textColor = isDark ? Colors.white : Colors.white;
  final Color iconColor = isDark ? Colors.white : Colors.white;

  return SnackBar(
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    margin: EdgeInsets.only(bottom: 15.h, left: 20.w, right: 20.w),
    backgroundColor: bgColor,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    content: Row(
      spacing: 12.w,
      children: [
        Icon(icon, color: iconColor, size: 16.sp),
        Expanded(
          child: CustomText(
            msg,
            color: textColor,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
