import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
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
      padding: EdgeInsets.symmetric(vertical: AppResponsive.heightValue(context, 9), horizontal: AppResponsive.widthValue(context, 5)),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: .035)
            : Colors.white.withValues(alpha: .65),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 13)),
        border: Border.all(
          color: primary.withValues(alpha: isDark ? .08 : .10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppResponsive.fontSize(context, 17), color: primary),

          SizedBox(height: AppResponsive.heightValue(context, 3)),

          CustomText(
            value,
            maxLines: 1,
              fontSize: AppResponsive.fontSize(context, 14),
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF173C38),
          ),

          SizedBox(height: AppResponsive.heightValue(context, 1)),

          CustomText(
            label,
              fontSize: AppResponsive.fontSize(context, 9),
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