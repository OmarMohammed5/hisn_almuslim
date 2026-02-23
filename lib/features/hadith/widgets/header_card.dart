import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';

class HeaderCard extends StatelessWidget {
  final int index;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;

  const HeaderCard({super.key, required this.index, this.onCopy, this.onShare});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.teal.withOpacity(0.15)
            : Colors.teal.withOpacity(0.08),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade600, Colors.teal.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 16.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10.w),
              CustomText(
                'حديث رقم $index',
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.teal.shade200 : Colors.teal.shade800,
              ),
            ],
          ),
          Row(
            spacing: 8.w,
            children: [
              _ActionButton(
                icon: Icons.copy_rounded,
                onPressed: onCopy,
                isDark: isDark,
              ),
              _ActionButton(
                icon: Icons.share_rounded,
                onPressed: onShare,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ===== Action Button =====
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isDark;

  const _ActionButton({
    required this.icon,
    this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: 38.w,
          height: 38.h,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isDark
                  ? Colors.teal.withOpacity(0.3)
                  : Colors.teal.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 18.sp,
            color: isDark ? Colors.teal.shade300 : Colors.teal.shade700,
          ),
        ),
      ),
    );
  }
}
