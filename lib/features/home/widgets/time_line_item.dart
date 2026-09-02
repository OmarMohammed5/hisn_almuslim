import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../core/shared/custom_text.dart';
import '../../adhan/data/models/prayer_time_model.dart';

class TimelineItem extends StatelessWidget {
  const TimelineItem({
    required this.prayer,
    required this.isPast,
    required this.isCurrent,
    required this.isLast,
    required this.accentColor,
    required this.isDark,
  });

  final PrayerTimeModel prayer;
  final bool isPast;
  final bool isCurrent;
  final bool isLast;
  final Color accentColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : const Color(0xFF0D2A26);
    final subTextColor = isDark ? Colors.white60 : Colors.grey.shade600;

    final arabicName = _getArabicPrayerName(prayer.name);
    final formattedTime = DateFormat(
      'hh:mm a',
    ).format(prayer.time).replaceAll('AM', 'ص').replaceAll('PM', 'م');

    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 14.w,
              height: 14.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrent
                    ? accentColor
                    : isPast
                    ? const Color(0xFF4DD0B5).withValues(alpha: 0.3)
                    : const Color(0xFFB2DFDB).withValues(alpha: 0.3),
                border: Border.all(
                  color: isCurrent
                      ? accentColor
                      : (isPast
                            ? const Color(0xFF4DD0B5).withValues(alpha: 0.3)
                            : const Color(0xFFB2DFDB).withValues(alpha: 0.3)),
                  width: isCurrent ? 3 : 2,
                ),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 30.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isPast
                        ? [
                            const Color(0xFF4DD0B5).withValues(alpha: 0.4),
                            const Color(0xFF4DD0B5).withValues(alpha: 0.2),
                          ]
                        : [
                            const Color(0xFFB2DFDB).withValues(alpha: 0.3),
                            const Color(0xFFB2DFDB).withValues(alpha: 0.1),
                          ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
          ],
        ),
        Gap(8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              arabicName,
              fontSize: 12.sp,
              color: isCurrent
                  ? accentColor
                  : (isPast ? subTextColor.withValues(alpha: 0.5) : textColor),
              fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
            ),
            Gap(2.h),
            CustomText(
              formattedTime,
              fontSize: 10.sp,
              color: isPast
                  ? subTextColor.withValues(alpha: 0.4)
                  : subTextColor,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        if (!isLast) Gap(16.w),
      ],
    );
  }

  String _getArabicPrayerName(String name) {
    final names = {
      'Fajr': 'الفجر',
      'Sunrise': 'الشروق',
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
    };
    return names[name] ?? name;
  }
}
