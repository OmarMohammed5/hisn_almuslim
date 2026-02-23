import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';

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

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0d2b26),
                  Color(0xFF0a1f1c),
                  Color(0xFF071a17),
                ],
                stops: [0.0, 0.5, 1.0],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFe8f9f6),
                  Color(0xFFd0f3ee),
                  Color(0xFFc0ebe5),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
        border: Border.all(
          color: isDark
              ? Colors.teal.withValues(alpha: 0.18)
              : Colors.teal.withValues(alpha: 0.25),
          width: 1.0,
        ),
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: Stack(
          children: [
            // ── Decorative glow blobs ────────────────────────────────
            Positioned(
              top: -40.h,
              left: -30.w,
              child: _GlowBlob(
                size: 160.w,
                color: isDark
                    ? Colors.teal.withValues(alpha: 0.07)
                    : Colors.teal.withValues(alpha: 0.12),
              ),
            ),

            ///
            Positioned(
              bottom: -40.h,
              right: -20.w,
              child: _GlowBlob(
                size: 140.w,
                color: isDark
                    ? Colors.teal.withValues(alpha: 0.05)
                    : Colors.white.withValues(alpha: 0.40),
              ),
            ),

            // ── Main Content ─────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Center: Icon + Label + Prayer Name ────────────
                  _CenterSection(isDark: isDark, nextPrayer: nextPrayer),

                  Gap(16.h),

                  // ── Divider ───────────────────────────────────────
                  _GradientDivider(isDark: isDark),

                  Gap(7.h),

                  // ── Timer ─────────────────────────────────────────
                  _TimerRow(
                    isDark: isDark,
                    hours: hours,
                    minutes: minutes,
                    seconds: seconds,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Center Section
// ─────────────────────────────────────────────────────────────────────────────
class _CenterSection extends StatelessWidget {
  const _CenterSection({required this.isDark, required this.nextPrayer});

  final bool isDark;
  final String nextPrayer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mosque icon badge
        Container(
          width: 52.w,
          height: 52.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: isDark
                ? Colors.teal.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.65),
            border: Border.all(
              color: isDark
                  ? Colors.teal.withValues(alpha: 0.22)
                  : Colors.teal.withValues(alpha: 0.20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withValues(alpha: isDark ? 0.15 : 0.12),
                blurRadius: 16.r,
              ),
            ],
          ),
          child: Icon(
            FlutterIslamicIcons.mosque,
            size: 24.sp,
            color: isDark ? const Color(0xFF5EEAD4) : const Color(0xFF0F766E),
          ),
        ),

        Gap(10.h),

        // "الصلاة القادمة" label
        CustomText(
          'الصلاة القادمة',
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          // letterSpacing: 1.2,
          color: isDark
              ? const Color(0xFF5EEAD4).withValues(alpha: 0.55)
              : const Color(0xFF0F766E).withValues(alpha: 0.60),
        ),

        Gap(6.h),

        // Prayer name — big & serif-feel via bold
        CustomText(
          nextPrayer,
          fontSize: 22.sp,
          fontWeight: FontWeight.w900,
          color: isDark ? const Color(0xFFF0FDF9) : const Color(0xFF0F2E2A),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Gradient Divider
// ─────────────────────────────────────────────────────────────────────────────
class _GradientDivider extends StatelessWidget {
  const _GradientDivider({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            isDark
                ? Colors.teal.withValues(alpha: 0.30)
                : Colors.teal.withValues(alpha: 0.35),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Timer Row
// ─────────────────────────────────────────────────────────────────────────────
class _TimerRow extends StatelessWidget {
  const _TimerRow({
    required this.isDark,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  final bool isDark;
  final int hours;
  final int minutes;
  final int seconds;

  @override
  Widget build(BuildContext context) {
    final sepColor = isDark
        ? const Color(0xFF5EEAD4).withValues(alpha: 0.30)
        : const Color(0xFF0F766E).withValues(alpha: 0.30);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TimeUnit(isDark: isDark, value: hours, label: 'ساعة'),
        _Separator(color: sepColor),
        _TimeUnit(isDark: isDark, value: minutes, label: 'دقيقة'),
        _Separator(color: sepColor),
        _TimeUnit(isDark: isDark, value: seconds, label: 'ثانية'),
      ],
    );
  }
}

class _TimeUnit extends StatelessWidget {
  const _TimeUnit({
    required this.isDark,
    required this.value,
    required this.label,
  });

  final bool isDark;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          value.toString().padLeft(2, '0'),
          fontSize: 30.sp,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : const Color(0xFF0F2E2A),
        ),
        Gap(2.h),
        CustomText(
          label,
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
          color: isDark
              ? const Color(0xFF5EEAD4).withValues(alpha: 0.50)
              : const Color(0xFF0F766E).withValues(alpha: 0.55),
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
      padding: EdgeInsets.only(bottom: 14.h, left: 6.w, right: 6.w),
      child: CustomText(
        ':',
        fontSize: 26.sp,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Glow Blob helper
// ─────────────────────────────────────────────────────────────────────────────
class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
