import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class DashboardTiming extends StatelessWidget {
  const DashboardTiming({
    super.key,
    required this.isDark,
    required this.nextPrayer,
    required this.remainingTime,
    this.prevPrayerName,
    this.prevPrayerTime,
    this.afterPrayerName,
    this.afterPrayerTime,
    this.totalDuration,
    this.cityName = 'القاهرة، مصر',
    this.hijriDate = '',
  });

  final bool isDark;
  final String nextPrayer;
  final Duration remainingTime;
  final String? prevPrayerName;
  final DateTime? prevPrayerTime;
  final String? afterPrayerName;
  final DateTime? afterPrayerTime;
  final Duration? totalDuration;
  final String cityName;
  final String hijriDate;

  @override
  Widget build(BuildContext context) {
    final hours = remainingTime.inHours % 24;
    final minutes = remainingTime.inMinutes % 60;
    final seconds = remainingTime.inSeconds % 60;

    final bg = isDark ? const Color(0xFF123A34) : const Color(0xFF0E8A78);
    final soft = isDark ? const Color(0xFF1D5149) : const Color(0xFF159985);
    final white = Colors.white;
    final muted = Colors.white.withValues(alpha: .68);

    return Container(
      margin: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [bg, soft],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E8A78).withValues(alpha: isDark ? .16 : .18),
            blurRadius: 22,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26.r),
        child: Stack(
          children: [
            Positioned(
              top: -55.h,
              left: -35.w,
              child: Container(
                width: 150.w,
                height: 150.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: .055),
                ),
              ),
            ),
            Positioned(
              bottom: -70.h,
              right: -35.w,
              child: Container(
                width: 170.w,
                height: 170.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: .04),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 15.h, 18.w, 14.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: .12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .12),
                          ),
                        ),
                        child: Icon(
                          FlutterIslamicIcons.mosque,
                          color: white,
                          size: 21.sp,
                        ),
                      ),
                      Gap(10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'الصلاة القادمة',
                              fontSize: 10.sp,
                              color: muted,
                              fontWeight: FontWeight.w600,
                            ),
                            Gap(2.h),
                            CustomText(
                              nextPrayer,
                              fontSize: 20.sp,
                              color: white,
                              fontWeight: FontWeight.w900,
                            ),
                          ],
                        ),
                      ),
                      if (cityName.isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on_outlined, size: 14.sp, color: muted),
                            Gap(3.w),
                            CustomText(
                              cityName,
                              fontSize: 10.sp,
                              color: muted,
                              fontFamily: "Noon",
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                    ],
                  ),
                  Gap(14.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .09),
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(color: Colors.white.withValues(alpha: .08)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _TimeUnit(value: hours, label: 'ساعة', color: white),
                        _Separator(color: Colors.white.withValues(alpha: .45)),
                        _TimeUnit(value: minutes, label: 'دقيقة', color: white),
                        _Separator(color: Colors.white.withValues(alpha: .45)),
                        _TimeUnit(value: seconds, label: 'ثانية', color: white),
                      ],
                    ),
                  ),
                  if (hijriDate.isNotEmpty) ...[
                    Gap(8.h),
                    CustomText(
                      hijriDate,
                      fontSize: 9.sp,
                      color: muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeUnit extends StatelessWidget {
  const _TimeUnit({required this.value, required this.label, required this.color});

  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          value.toString().padLeft(2, '0'),
          fontSize: 25.sp,
          color: color,
          fontWeight: FontWeight.w900,
        ),
        CustomText(
          label,
          fontSize: 8.sp,
          color: color.withValues(alpha: .62),
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      child: CustomText(':', fontSize: 20.sp, color: color, fontWeight: FontWeight.w700),
    );
  }
}
