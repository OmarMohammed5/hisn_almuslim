import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
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
        duration: const Duration(milliseconds: 50),
        curve: Curves.bounceInOut,
        margin: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 2)),
        padding: EdgeInsets.zero,
        height: AppResponsive.heightValue(context, 62),
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
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 16)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _primary.withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: Offset(0, AppResponsive.heightValue(context, 6)),
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
                fontSize: AppResponsive.fontSize(context, 8),
                fontWeight: isFriday || isSelected
                    ? FontWeight.bold
                    : FontWeight.w700,
                fontFamily: 'Cairo',
              ),
            ),
            Gap(AppResponsive.heightValue(context, 2)),
            // Hijri Day Number - Fixed size
            Container(
              width: AppResponsive.widthValue(context, 28),
              height: AppResponsive.widthValue(context, 28),
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
                    fontSize: AppResponsive.fontSize(context, 14),
                    fontWeight: isSelected || isToday
                        ? FontWeight.w900
                        : FontWeight.w700,
                    height: 1,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
            Gap(AppResponsive.heightValue(context, 2)),
            // Indicator - Fixed size
            Container(
              width: isSelected
                  ? AppResponsive.widthValue(context, 16)
                  : isToday
                  ? AppResponsive.widthValue(context, 12)
                  : AppResponsive.widthValue(context, 6),
              height: AppResponsive.heightValue(context, 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? _primaryLight
                    : isToday
                    ? _primary
                    : mutedColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppResponsive.radius(context, 2)),
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
