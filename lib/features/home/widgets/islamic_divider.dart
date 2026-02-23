import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IslamicDivider extends StatelessWidget {
  const IslamicDivider({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    isDark ? Colors.teal.shade700 : Colors.teal.shade400,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.teal.shade900.withValues(alpha: 0.3)
                    : Colors.teal.shade50,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? Colors.teal.shade700 : Colors.teal.shade400,
                  width: 2.w,
                ),
              ),
              child: Icon(
                FlutterIslamicIcons.islam,
                color: isDark ? Colors.teal.shade400 : Colors.teal.shade700,
                size: 16.sp,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    isDark ? Colors.teal.shade700 : Colors.teal.shade400,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
