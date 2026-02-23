import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(20.r);

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          // height: 137.h,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: isDark
                  ? [
                      Colors.teal.shade800.withOpacity(0.9),
                      Colors.teal.shade900.withOpacity(0.2),
                    ]
                  : [Colors.teal.shade100, Colors.teal.shade50],
            ),
            // borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isDark
                  ? Colors.teal.shade700.withOpacity(0.4)
                  : Colors.teal.shade200.withValues(alpha: 0.7),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.shade700.withOpacity(0.15),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Center(
            child: // Main Content
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                Colors.teal.shade600.withValues(alpha: 0.8),
                                Colors.teal.shade700.withValues(alpha: 0.9),
                              ]
                            : [Colors.teal.shade500, Colors.teal.shade600],
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 20.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Gap(17.h),
                  CustomText(
                    title,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.bold,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    color: isDark ? Colors.white : Colors.black87,
                  ),

                  Gap(10.h),

                  // Discover >
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.r),
                      color: Colors.teal.withValues(alpha: 0.2),
                      border: Border.all(
                        color: Colors.teal.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          'استكشف',
                          fontSize: 7.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.teal.shade300
                              : Colors.teal.shade700,
                        ),
                        Gap(3.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 7.sp,
                          color: isDark
                              ? Colors.teal.shade300
                              : Colors.teal.shade700,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
