import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:intl/intl.dart';

import '../../../core/responsive/app_responsive.dart';

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
    final formattedTime = DateFormat(
      'hh:mm a',
    ).format(time).replaceAll('AM', 'ص').replaceAll('PM', 'م');

    final surface = isDark ? const Color(0xFF171A19) : Colors.white;
    final text = isDark ? Colors.white : const Color(0xFF17231F);
    final muted = isDark
        ? Colors.white.withValues(alpha: .52)
        : const Color(0xFF71807B);
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
        borderRadius: BorderRadius.circular( AppResponsive.radius(context, 17)),
        border: Border.all(
          color: isCurrentPrayer
              ? const Color(0xFF0E8A78).withValues(alpha: .22)
              : isNextPrayer
              ? const Color(0xFFD99727).withValues(alpha: .20)
              : (isDark
                    ? Colors.white.withValues(alpha: .05)
                    : const Color(0xFFE9EFED)),
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
            width: AppResponsive.widthValue(context, 7),
            height:  AppResponsive.heightValue(context, 7),
            decoration: BoxDecoration(shape: BoxShape.circle, color: accent),
          ),
          Gap(AppResponsive.widthValue(context, 8)),

          Expanded(
            child: Row(
              children: [
                CustomText(
                  prayer,
                  fontSize: AppResponsive.fontSize(context, 12),
                  color: text,
                  fontWeight: isCurrentPrayer || isNextPrayer
                      ? FontWeight.w800
                      : FontWeight.w600,
                ),
                if (isCurrentPrayer) ...[
                  Gap(AppResponsive.widthValue(context, 7)),
                  _Badge(
                    text: 'الآن',
                    color: const Color(0xFF0E8A78),
                    isDark: isDark,
                  ),
                ] else if (isNextPrayer) ...[
                  Gap(AppResponsive.widthValue(context, 7)),
                  _Badge(
                    text: 'القادمة',
                    color: const Color(0xFFD99727),
                    isDark: isDark,
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.widthValue(context, 11),
              vertical: AppResponsive.heightValue(context, 6),
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: .06)
                  : const Color(0xFFF2F4F3),
              borderRadius: BorderRadius.circular( AppResponsive.radius(context, 12)),
            ),
            child: CustomText(
              formattedTime,
              fontSize: AppResponsive.fontSize(context, 10),
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
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 6),
        vertical: AppResponsive.heightValue(context, 3),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? .18 : .12),
        borderRadius: BorderRadius.circular( AppResponsive.radius(context, 20)),
      ),
      child: CustomText(
        text,
        fontSize: AppResponsive.fontSize(context, 8.6),
        color: isDark ? color.withValues(alpha: .95) : color,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
