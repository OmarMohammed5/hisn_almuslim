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

    final palette = _paletteFor(nextPrayer);
    final gradientColors = isDark ? palette.gradientDark : palette.gradientLight;
    final accent = isDark ? palette.accentDark : palette.accentLight;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
          stops: const [0.0, 0.5, 1.0],
        ),
        border: Border.all(
          color: accent.withValues(alpha: isDark ? 0.18 : 0.25),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: Stack(
          children: [
            // ── Decorative glow blobs
            Positioned(
              top: -40.h,
              left: -30.w,
              child: _GlowBlob(
                size: 160.w,
                color: accent.withValues(alpha: isDark ? 0.07 : 0.12),
              ),
            ),
            Positioned(
              bottom: -40.h,
              right: -20.w,
              child: _GlowBlob(
                size: 140.w,
                color: isDark
                    ? accent.withValues(alpha: 0.05)
                    : Colors.white.withValues(alpha: 0.40),
              ),
            ),

            // ── Main Content
            Padding(
              padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _CenterSection(
                    isDark: isDark,
                    nextPrayer: nextPrayer,
                    palette: palette,
                    accent: accent,
                  ),
                  Gap(16.h),
                  _GradientDivider(accent: accent),
                  Gap(7.h),
                  _TimerRow(
                    isDark: isDark,
                    accent: accent,
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

// Prayer Palette
class _PrayerPalette {
  final IconData icon;
  final bool mirror;
  final List<Color> gradientDark;
  final List<Color> gradientLight;
  final Color accentDark;
  final Color accentLight;

  const _PrayerPalette({
    required this.icon,
    this.mirror = false,
    required this.gradientDark,
    required this.gradientLight,
    required this.accentDark,
    required this.accentLight,
  });
}

_PrayerPalette _paletteFor(String prayerName) {
  switch (prayerName) {
    case 'الفجر':
      return const _PrayerPalette(
        icon: Icons.nightlight_round,
        gradientDark: [
          Color(0xFF1E1B4B),
          Color(0xFF181442),
          Color(0xFF0F0D2E),
        ],
        gradientLight: [
          Color(0xFFEEF2FF),
          Color(0xFFE0E7FF),
          Color(0xFFC7D2FE),
        ],
        accentDark: Color(0xFFA5B4FC),
        accentLight: Color(0xFF4338CA),
      );

    case 'الشروق':
      return const _PrayerPalette(
        icon: Icons.wb_twilight,
        gradientDark: [
          Color(0xFF3D1F00),
          Color(0xFF2B1400),
          Color(0xFF1A0F00),
        ],
        gradientLight: [
          Color(0xFFFFF7ED),
          Color(0xFFFFEDD5),
          Color(0xFFFED7AA),
        ],
        accentDark: Color(0xFFFDBA74),
        accentLight: Color(0xFFC2410C),
      );

    case 'الظهر':
      return const _PrayerPalette(
        icon: Icons.wb_sunny,
        gradientDark: [
          Color(0xFF0C2340),
          Color(0xFF0A1A30),
          Color(0xFF071122),
        ],
        gradientLight: [
          Color(0xFFEFF6FF),
          Color(0xFFDBEAFE),
          Color(0xFFBFDBFE),
        ],
        accentDark: Color(0xFF93C5FD),
        accentLight: Color(0xFF1D4ED8),
      );

    case 'العصر':
      return const _PrayerPalette(
        icon: Icons.brightness_5,
        gradientDark: [
          Color(0xFF3D2B00),
          Color(0xFF2B1D00),
          Color(0xFF1A1100),
        ],
        gradientLight: [
          Color(0xFFFFFBEB),
          Color(0xFFFEF3C7),
          Color(0xFFFDE68A),
        ],
        accentDark: Color(0xFFFCD34D),
        accentLight: Color(0xFFB45309),
      );

    case 'المغرب':
      return const _PrayerPalette(
        icon: Icons.wb_twilight,
        mirror: true,
        gradientDark: [
          Color(0xFF2E1065),
          Color(0xFF431407),
          Color(0xFF1A0A2E),
        ],
        gradientLight: [
          Color(0xFFFFEDD5),
          Color(0xFFFBCFE8),
          Color(0xFFE9D5FF),
        ],
        accentDark: Color(0xFFFDA4AF),
        accentLight: Color(0xFFBE185D),
      );

    case 'العشاء':
      return const _PrayerPalette(
        icon: Icons.dark_mode,
        gradientDark: [
          Color(0xFF020617),
          Color(0xFF0F172A),
          Color(0xFF1E293B),
        ],
        gradientLight: [
          Color(0xFFEEF2FF),
          Color(0xFFE0E7FF),
          Color(0xFFC7D2FE),
        ],
        accentDark: Color(0xFF818CF8),
        accentLight: Color(0xFF3730A3),
      );

    default:
      return const _PrayerPalette(
        icon: FlutterIslamicIcons.mosque,
        gradientDark: [
          Color(0xFF0D2B26),
          Color(0xFF0A1F1C),
          Color(0xFF071A17),
        ],
        gradientLight: [
          Color(0xFFE8F9F6),
          Color(0xFFD0F3EE),
          Color(0xFFC0EBE5),
        ],
        accentDark: Color(0xFF5EEAD4),
        accentLight: Color(0xFF0F766E),
      );
  }
}

// Center Section
class _CenterSection extends StatelessWidget {
  const _CenterSection({
    required this.isDark,
    required this.nextPrayer,
    required this.palette,
    required this.accent,
  });

  final bool isDark;
  final String nextPrayer;
  final _PrayerPalette palette;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    Widget icon = Icon(
      palette.icon,
      size: 24.sp,
      color: isDark ? palette.accentDark : palette.accentLight,
    );

    if (palette.mirror) {
      icon = Transform.flip(flipX: true, child: icon);
    }

    return Column(
      children: [
        // Icon badge
        Container(
          width: 52.w,
          height: 52.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: isDark
                ? accent.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.65),
            border: Border.all(
              color: accent.withValues(alpha: isDark ? 0.22 : 0.20),
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: isDark ? 0.15 : 0.12),
                blurRadius: 16.r,
              ),
            ],
          ),
          child: icon,
        ),

        Gap(10.h),

        CustomText(
          'الصلاة القادمة',
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: accent.withValues(alpha: isDark ? 0.55 : 0.60),
        ),

        Gap(6.h),

        // Prayer name
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

// Gradient Divider
class _GradientDivider extends StatelessWidget {
  const _GradientDivider({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            accent.withValues(alpha: 0.35),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

// Timer Row
class _TimerRow extends StatelessWidget {
  const _TimerRow({
    required this.isDark,
    required this.accent,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  final bool isDark;
  final Color accent;
  final int hours;
  final int minutes;
  final int seconds;

  @override
  Widget build(BuildContext context) {
    final sepColor = accent.withValues(alpha: 0.30);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TimeUnit(isDark: isDark, accent: accent, value: hours, label: 'ساعة'),
        _Separator(color: sepColor),
        _TimeUnit(isDark: isDark, accent: accent, value: minutes, label: 'دقيقة'),
        _Separator(color: sepColor),
        _TimeUnit(isDark: isDark, accent: accent, value: seconds, label: 'ثانية'),
      ],
    );
  }
}

class _TimeUnit extends StatelessWidget {
  const _TimeUnit({
    required this.isDark,
    required this.accent,
    required this.value,
    required this.label,
  });

  final bool isDark;
  final Color accent;
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
          color: accent.withValues(alpha: isDark ? 0.50 : 0.55),
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

// Glow Blob helper
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