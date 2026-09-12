import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../responsive/app_responsive.dart';

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
    padding: EdgeInsets.symmetric(
      horizontal: AppResponsive.widthValue(context, 14),
      vertical: AppResponsive.widthValue(context, 12),
    ),
    margin: EdgeInsets.only(
      bottom: AppResponsive.heightValue(context, 15),
      left: AppResponsive.widthValue(context, 20),
      right: AppResponsive.widthValue(context, 20),
    ),
    backgroundColor: bgColor,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppResponsive.radius(context, 16)),
    ),
    content: Row(
      spacing: AppResponsive.widthValue(context, 12),
      children: [
        Icon(icon, color: iconColor, size: AppResponsive.iconSize(context, 16)),
        Expanded(
          child: CustomText(
            msg,
            color: textColor,
            fontSize: AppResponsive.fontSize(context, 11),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
