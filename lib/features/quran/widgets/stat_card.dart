import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final bool isDark;

  const StatCard(
    this.label,
    this.value,
    this.unit,
    this.icon,
    this.isDark, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.widthValue(context, 14)),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey.shade800.withOpacity(0.5)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 16)),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: AppResponsive.fontSize(context, 20), color: Colors.teal.shade700),
          Gap(AppResponsive.heightValue(context, 8)),
          CustomText(value, fontSize: AppResponsive.fontSize(context, 13), fontWeight: FontWeight.bold),
          Gap(AppResponsive.heightValue(context, 2)),
          CustomText(unit, fontSize: AppResponsive.fontSize(context, 9), color: Colors.grey.shade600),
          Gap(AppResponsive.heightValue(context, 4)),
          CustomText(label, fontSize: AppResponsive.fontSize(context, 9), color: Colors.grey.shade600),
        ],
      ),
    );
  }
}
