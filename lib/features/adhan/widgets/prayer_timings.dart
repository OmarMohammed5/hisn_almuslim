import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:intl/intl.dart';

class PrayerTimings extends StatelessWidget {
  const PrayerTimings({
    super.key,
    required this.isDark,
    required this.prayer,
    required this.time,
    required this.isCurrentPrayer,
    required this.isNextPrayer,
  });

  final bool isDark;
  final String prayer;
  final DateTime time;
  final bool isCurrentPrayer;
  final bool isNextPrayer;

  @override
  Widget build(BuildContext context) {
    final String formattedTime = DateFormat(
      'hh:mm a',
    ).format(time).replaceAll('AM', 'ص').replaceAll('PM', 'م');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: isCurrentPrayer
            ? isDark
                  ? Colors.teal.shade700.withValues(alpha: 0.35)
                  : Colors.teal.shade600.withValues(alpha: 0.20)
            : isNextPrayer
            ? Colors.orange.withValues(alpha: 0.12)
            : isDark
            ? Colors.grey.shade800.withValues(alpha: 0.30)
            : Colors.white.withValues(alpha: 0.80),
        border: isCurrentPrayer
            ? Border.all(
                color: isDark
                    ? Colors.teal.shade500.withValues(alpha: 0.50)
                    : Colors.teal.shade400.withValues(alpha: 0.60),
                width: 1.2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isCurrentPrayer
                ? Colors.teal.withValues(alpha: 0.15)
                : isDark
                ? Colors.black.withValues(alpha: 0.20)
                : Colors.grey.withValues(alpha: 0.15),
            blurRadius: isCurrentPrayer ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 10.w,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrentPrayer
                      ? Colors.teal.shade300
                      : isNextPrayer
                      ? Colors.orange
                      : Colors.grey.shade500,
                ),
              ),

              // CustomText(
              //   prayer,
              //   fontSize: 13.sp,
              //   color: isCurrentPrayer
              //       ? (isDark ? Colors.teal.shade200 : Colors.teal.shade800)
              //       : Colors.black87,
              //   fontWeight: isCurrentPrayer ? FontWeight.w800 : FontWeight.w600,
              // ),
              CustomText(
                prayer,
                fontSize: 13.sp,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.90) // Dark Mode → فاتح
                    : Colors.black87, // Light Mode → أسود
                fontWeight: isCurrentPrayer ? FontWeight.w800 : FontWeight.w600,
              ),

              ///  BADGES
              if (isCurrentPrayer) ...[
                SizedBox(width: 8.w),
                _badge("الآن", Colors.teal, isDark),
              ] else if (isNextPrayer) ...[
                SizedBox(width: 8.w),
                _badge("الصلاة القادمة", Colors.orange.shade700, isDark),
              ],
            ],
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isCurrentPrayer
                  ? (isDark
                        ? Colors.teal.shade800.withValues(alpha: 0.50)
                        : Colors.teal.shade100.withValues(alpha: 0.80))
                  : isDark
                  ? Colors.grey.shade700.withValues(alpha: 0.30)
                  : Colors.grey.shade400.withValues(alpha: 0.30),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: CustomText(
              formattedTime,
              fontSize: 11.sp,
              fontWeight: isCurrentPrayer ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: color.withValues(alpha: 0.20),
      ),
      child: CustomText(
        text,
        fontSize: 8.sp,
        color: isDark
            ? color.withValues(alpha: 0.9)
            : color.withValues(alpha: 0.8),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
