import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/shared/custom_text.dart';

class BuildAdhanCard extends StatelessWidget {
  final bool isDark;

  const BuildAdhanCard({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.adhanSettings),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.grey.shade900.withOpacity(0.3)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? Colors.grey.shade800.withOpacity(0.3)
                : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey.shade800.withOpacity(0.3)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    FlutterIslamicIcons.mosque,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    size: 20.sp,
                  ),
                ),
                Gap(12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "الأذان",
                      fontSize: 14.sp,
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    Gap(5.h),
                    CustomText(
                      "إعدادات الأذان",
                      fontSize: 11.sp,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
