import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomActionBar extends StatelessWidget {
  final int currentCount;
  final int totalCount;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const BottomActionBar({
    super.key,
    this.currentCount = 5,
    this.totalCount = 1,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        width: 100.w,
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1C2227) : Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: Color(0xFF677C8D).withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: 16.w,
          children: [
            // Previous Button
            BuildActionButton(
              icon: Icons.arrow_back_ios_new,
              onPressed: onPrevious,
            ),
            // Next Button
            BuildActionButton(icon: Icons.arrow_forward_ios, onPressed: onNext),

          ],
        ),
      ),
    );
  }
}

class BuildActionButton extends StatelessWidget {
  const BuildActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 42.w,
      height: 42.h,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2C2C2E) : Color(0xffe9eef0),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.teal.shade600, size: 16.sp),
        onPressed: onPressed ?? () {},
        padding: EdgeInsets.zero,
      ),
    );
  }
}
