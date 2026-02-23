import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';

class CategoriesHeader extends StatelessWidget {
  const CategoriesHeader({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      child: Row(
        children: [
          // Decoration Right
          Column(
            children: [
              Container(
                width: 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.teal.shade400 : Colors.teal.shade600,
                  shape: BoxShape.circle,
                ),
              ),
              Gap(4.h),
              Container(
                width: 4.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.teal.shade600 : Colors.teal.shade400,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Gap(4.h),
              Container(
                width: 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.teal.shade400 : Colors.teal.shade600,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          Gap(12.h),
          // Title
          Expanded(
            child: CustomText(
              'الأقسام',
              fontSize: 14.5.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Color(0xFF1A1A2E),
            ),
          ),
          // Categories
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          //   decoration: BoxDecoration(
          //     color: isDark
          //         ? Colors.teal.shade900.withValues(alpha: .3)
          //         : Colors.teal.shade50,
          //     borderRadius: BorderRadius.circular(16.r),
          //     border: Border.all(
          //       color: isDark ? Colors.teal.shade700 : Colors.teal.shade200,
          //     ),
          //   ),
          //   child: Container(
          //     padding: EdgeInsets.all(6.w),
          //     decoration: BoxDecoration(
          //       color: isDark
          //           ? Colors.teal.shade900.withValues(alpha: 0.3)
          //           : Colors.teal.shade50,
          //       borderRadius: BorderRadius.circular(8.r),
          //     ),
          //     child: Icon(
          //       Icons.apps_rounded,
          //       color: isDark ? Colors.teal.shade400 : Colors.teal.shade700,
          //       size: 16.sp,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
