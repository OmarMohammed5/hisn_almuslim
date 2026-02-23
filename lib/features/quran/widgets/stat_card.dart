import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';

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
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey.shade800.withOpacity(0.5)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20.sp, color: Colors.teal.shade700),
          Gap(8.h),
          CustomText(value, fontSize: 13.sp, fontWeight: FontWeight.bold),
          Gap(2.h),
          CustomText(unit, fontSize: 9.sp, color: Colors.grey.shade600),
          Gap(4.h),
          CustomText(label, fontSize: 9.sp, color: Colors.grey.shade600),
        ],
      ),
    );
  }
}
