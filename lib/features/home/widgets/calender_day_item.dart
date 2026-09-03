import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CalenderDayItem extends StatelessWidget {
  final int index;
  final bool isDark;
  final bool isSelected;
  final Map<String, dynamic> dayData;
  final VoidCallback onTap;

  const CalenderDayItem({
    super.key,
    required this.index,
    required this.isDark,
    required this.isSelected,
    required this.dayData,
    required this.onTap,
  });

  // App Identity Colors
  static const Color _primary = Color(0xFF0E8A78);
  static const Color _primaryLight = Color(0xFF1CAA96);
  static const Color _primaryDark = Color(0xFF0A6B5D);
  static const Color _lightText = Color(0xFF18312D);
  static const Color _lightMuted = Color(0xFF71827E);

  @override
  Widget build(BuildContext context) {
    final date = dayData['date'] as DateTime;
    final isToday = dayData['isToday'] as bool;
    final isFriday = dayData['isFriday'] as bool;

    final textColor = isDark ? Colors.white : _lightText;
    final mutedColor = isDark ? Colors.white54 : _lightMuted;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        padding: EdgeInsets.symmetric(vertical: 4.h),
        height: 58.h,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [_primary, _primaryDark],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          color: isSelected
              ? null
              : isToday
              ? _primary.withValues(alpha: isDark ? 0.12 : 0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _primary.withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: Offset(0, 6.h),
                  ),
                ]
              : null,
          border: isToday && !isSelected
              ? Border.all(color: _primary.withValues(alpha: 0.2), width: 1.5)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Week Day
            Text(
              _getShortArabicWeekDay(date.weekday),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.85)
                    : isFriday
                    ? _primaryLight
                    : isToday
                    ? _primary
                    : mutedColor,
                fontSize: 8.sp,
                fontWeight: isFriday || isSelected
                    ? FontWeight.bold
                    : FontWeight.w700,
                fontFamily: 'Cairo',
              ),
            ),
            Gap(4.h),
            // Hijri Day Number - Fixed size
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.15)
                    : isToday && !isSelected
                    ? _primary.withValues(alpha: 0.1)
                    : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  _toArabicNumber(dayData['hijriDay'] as int),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : isToday
                        ? _primary
                        : textColor,
                    fontSize: 14.sp,
                    fontWeight: isSelected || isToday
                        ? FontWeight.w900
                        : FontWeight.w700,
                    height: 1,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
            Gap(4.h),
            // Indicator - Fixed size
            Container(
              width: isSelected
                  ? 16.w
                  : isToday
                  ? 12.w
                  : 6.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: isSelected
                    ? _primaryLight
                    : isToday
                    ? _primary
                    : mutedColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Arabic Numbers
  String _toArabicNumber(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((digit) => arabicDigits[int.parse(digit)])
        .join();
  }

  String _getShortArabicWeekDay(int weekday) {
    const days = ['إثن', 'ثلا', 'أرب', 'خمي', 'جمع', 'سبت', 'أحد'];
    return days[weekday - 1];
  }
}
