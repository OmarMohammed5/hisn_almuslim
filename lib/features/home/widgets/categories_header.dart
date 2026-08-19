import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class CategoriesHeader extends StatelessWidget {
  const CategoriesHeader({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final tealColor = isDark ? Colors.teal.shade400 : Colors.teal.shade600;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: tealColor.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
              Gap(3.h),

              Container(
                width: 2.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: tealColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Gap(3.h),

              Container(
                width: 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: tealColor.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          Gap(12.w),

          Expanded(
            child: CustomText(
              'الأقسام',
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              fontFamily: "QuranFont",
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isDark
                  ? tealColor.withOpacity(0.1)
                  : Colors.teal.shade50.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: tealColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.apps_rounded,
              color: tealColor,
              size: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}