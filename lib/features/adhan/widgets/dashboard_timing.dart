import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../../../core/responsive/app_responsive.dart';

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
      margin: EdgeInsets.fromLTRB(
        AppResponsive.widthValue(context, 18),
        AppResponsive.heightValue(context, 10),
        AppResponsive.widthValue(context, 18),
        AppResponsive.heightValue(context, 12),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 26)),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [bg, soft],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF0E8A78,
            ).withValues(alpha: isDark ? .16 : .18),
            blurRadius: 12,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 26)),
        child: Stack(
          children: [
            Positioned(
              top: AppResponsive.heightValue(context, -55),
              left: AppResponsive.widthValue(context, -35),
              child: Container(
                width: AppResponsive.widthValue(context, 150),
                height: AppResponsive.heightValue(context, 150),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: .055),
                ),
              ),
            ),
            Positioned(
              bottom: AppResponsive.heightValue(context, -70),
              right: AppResponsive.widthValue(context, -35),
              child: Container(
                width: AppResponsive.widthValue(context, 170),
                height: AppResponsive.heightValue(context, 170),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: .04),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.widthValue(context, 18),
                AppResponsive.heightValue(context, 15),
                AppResponsive.widthValue(context, 18),
                AppResponsive.heightValue(context, 14),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: AppResponsive.widthValue(context, 40),
                        height: AppResponsive.heightValue(context, 40),
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
                          size: AppResponsive.iconSize(context, 21),
                        ),
                      ),
                      Gap(AppResponsive.widthValue(context, 10)),
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
                            Gap(AppResponsive.heightValue(context, 2)),
                            CustomText(
                              nextPrayer,
                              fontSize: AppResponsive.fontSize(context, 18),
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
                            Icon(
                              Icons.location_on_outlined,
                              size: AppResponsive.iconSize(context, 14),
                              color: muted,
                            ),
                            Gap(AppResponsive.widthValue(context, 3)),
                            CustomText(
                              cityName,
                              fontSize: AppResponsive.fontSize(context, 10),
                              color: muted,
                              fontFamily: "Noon",
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                    ],
                  ),
                  Gap(AppResponsive.heightValue(context, 14)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.widthValue(context, 12),
                      vertical: AppResponsive.heightValue(context, 10),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .09),
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .08),
                      ),
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
                    Gap(AppResponsive.heightValue(context, 8)),
                    CustomText(
                      hijriDate,
                      fontSize: AppResponsive.fontSize(context, 9),
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
  const _TimeUnit({
    required this.value,
    required this.label,
    required this.color,
  });

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
          fontSize: AppResponsive.fontSize(context, 20),
          color: color,
          fontWeight: FontWeight.w900,
        ),
        CustomText(
          label,
          fontSize: AppResponsive.fontSize(context, 8),
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
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 10),
        vertical: AppResponsive.heightValue(context, 3),
      ),
      child: CustomText(
        ':',
        fontSize: AppResponsive.fontSize(context, 14),
        color: color,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
