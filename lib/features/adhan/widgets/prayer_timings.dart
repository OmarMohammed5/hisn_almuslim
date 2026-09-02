import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
    final formattedTime = DateFormat('hh:mm a')
        .format(time)
        .replaceAll('AM', 'ص')
        .replaceAll('PM', 'م');

    final surface = isDark ? const Color(0xFF171A19) : Colors.white;
    final text = isDark ? Colors.white : const Color(0xFF17231F);
    final muted = isDark ? Colors.white.withValues(alpha: .52) : const Color(0xFF71807B);
    final accent = isCurrentPrayer
        ? const Color(0xFF0E8A78)
        : isNextPrayer
        ? const Color(0xFFD99727)
        : muted;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: isCurrentPrayer
            ? (isDark ? const Color(0xFF123A34) : const Color(0xFFE6F5F1))
            : isNextPrayer
            ? (isDark ? const Color(0xFF30250F) : const Color(0xFFFFF7E7))
            : surface,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(
          color: isCurrentPrayer
              ? const Color(0xFF0E8A78).withValues(alpha: .22)
              : isNextPrayer
              ? const Color(0xFFD99727).withValues(alpha: .20)
              : (isDark ? Colors.white.withValues(alpha: .05) : const Color(0xFFE9EFED)),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: .035),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 7.w,
            height: 7.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: accent),
          ),
          Gap(8.w),
          Expanded(
            child: Row(
              children: [
                CustomText(
                  prayer,
                  fontSize: 13.sp,
                  color: text,
                  fontWeight: isCurrentPrayer || isNextPrayer
                      ? FontWeight.w800
                      : FontWeight.w600,
                ),
                if (isCurrentPrayer) ...[
                  Gap(7.w),
                  _Badge(text: 'الآن', color: const Color(0xFF0E8A78), isDark: isDark),
                ] else if (isNextPrayer) ...[
                  Gap(7.w),
                  _Badge(text: 'القادمة', color: const Color(0xFFD99727), isDark: isDark),
                ],
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: .06) : const Color(0xFFF2F4F3),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: CustomText(
              formattedTime,
              fontSize: 10.sp,
              color: text,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color, required this.isDark});
  final String text;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? .18 : .12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        text,
        fontSize: 8.sp,
        color: isDark ? color.withValues(alpha: .95) : color,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
