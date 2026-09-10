import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/about%20app/screen/about_app_screen.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/responsive/app_responsive.dart';

class AboutAppWidget extends StatelessWidget {
  const AboutAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutAppScreen()),
        );
      },
      child: ListTile(
        title: CustomText(
          "عن التطبيق",
          fontSize: AppResponsive.fontSize(context, 12),
          fontWeight: FontWeight.w600,
        ),
        leading: Container(
          padding: EdgeInsets.all(AppResponsive.widthValue(context, 6)),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.teal.shade800.withValues(alpha: 0.3)
                : Colors.teal.shade50,
            borderRadius: BorderRadius.circular(AppResponsive.radius(context, 8)),
          ),
          child: Icon(
            Icons.info_outline,
            color: AppColors.kIconColor,
            size: AppResponsive.iconSize(context, 22),
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.all(AppResponsive.widthValue(context, 5)),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.teal.shade800.withValues(alpha: 0.3)
                : Colors.teal.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_forward_ios, size: AppResponsive.iconSize(context, 16)),
        ),
      ),
    );
  }
}
