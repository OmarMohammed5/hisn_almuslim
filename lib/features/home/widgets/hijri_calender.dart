import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

class HijriCalendarCard extends StatefulWidget {
  const HijriCalendarCard({super.key});

  @override
  State<HijriCalendarCard> createState() => _HijriCalendarCardState();
}

class _HijriCalendarCardState extends State<HijriCalendarCard> {
  late HijriCalendar _today;
  late List<Map<String, dynamic>> _weekDays;

  int _selectedDay = 0;

  @override
  void initState() {
    super.initState();
    _today = HijriCalendar.now();
    _selectedDay = _today.hDay;
    _buildWeekDays();
  }

  void _buildWeekDays() {
    _weekDays = [];
    for (int i = -3; i <= 3; i++) {
      final date = DateTime.now().add(Duration(days: i));
      final hijri = HijriCalendar.fromDate(date);
      _weekDays.add({
        'hijriDay': hijri.hDay,
        'weekDay': _getArabicWeekDay(date.weekday),
        'isToday': i == 0,
        'hijri': hijri,
      });
    }
  }

  String _getArabicWeekDay(int weekday) {
    const days = [
      'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس',
      'الجمعة', 'السبت', 'الأحد',
    ];
    return days[weekday - 1];
  }

  String _getArabicMonth(int month) {
    const months = [
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر',
      'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
      'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة',
    ];
    return months[month - 1];
  }

  String _toArabicNumber(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number.toString().split('').map((d) => arabicDigits[int.parse(d)]).join();
  }

  String _getGregorianDate() {
    final now = DateTime.now();
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return '${_toArabicNumber(now.day)} ${months[now.month - 1]} ${_toArabicNumber(now.year)} ${'م'}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ===== Theme-aware palette =====
    final gradientColors = isDark
        ? [const Color(0xFF0D1F1C), const Color(0xFF1A3D36)]
        : [const Color(0xFF0E8A78), const Color(0xFF1CAA96)];

    final primaryTextColor = Colors.white;
    final secondaryTextColor = Colors.white.withValues(alpha: 0.68);
    final chipBgColor = Colors.white.withValues(alpha: isDark ? 0.11 : 0.17);
    final weekStripBg = Colors.white.withValues(alpha: isDark ? 0.05 : 0.13);
    final selectedDayColor = isDark ? const Color(0xFF48C8BC) : const Color(0xFF0E8A78);
    final selectedDayTextColor = isDark ? const Color(0xFF0D1F1C) : Colors.white;
    final todayAccentColor = const Color(0xFFFFC107);
    final shadowColor = (isDark ? Colors.black : const Color(0xFF0E8A78))
        .withValues(alpha: isDark ? 0.42 : 0.22);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 20,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(primaryTextColor, secondaryTextColor, chipBgColor),
          _buildWeekStrip(
            weekStripBg,
            primaryTextColor,
            secondaryTextColor,
            selectedDayColor,
            selectedDayTextColor,
            todayAccentColor,
          ),
          Gap(12.h),
        ],
      ),
    );
  }

  Widget _buildHeader(
      Color primaryTextColor,
      Color secondaryTextColor,
      Color chipBgColor,
      ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl,
        children: [
          // Hijri Calendar
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Text(
                _toArabicNumber(_today.hDay),
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              Gap(10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    _getArabicMonth(_today.hMonth),
                    color: primaryTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  Gap(5.h),
                  Text(
                    '${_toArabicNumber(_today.hYear)} هـ',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Gregorian Calendar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: chipBgColor,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Text(
              _getGregorianDate(),
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekStrip(
      Color weekStripBg,
      Color primaryTextColor,
      Color secondaryTextColor,
      Color selectedDayColor,
      Color selectedDayTextColor,
      Color todayAccentColor,
      ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: weekStripBg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dayWidth = (constraints.maxWidth / _weekDays.length) - 4.w;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekDays.map((day) {
              final isSelected = day['hijriDay'] == _selectedDay;
              final isToday = day['isToday'] as bool;

              return GestureDetector(
                onTap: () => setState(() => _selectedDay = day['hijriDay']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: dayWidth.clamp(32.w, 42.w),
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected ? selectedDayColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        day['weekDay'],
                        style: TextStyle(
                          color: isSelected
                              ? selectedDayTextColor
                              : secondaryTextColor,
                          fontSize: 12.sp,
                          fontFamily: "QuranFont",
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                        ),
                      ),
                      Gap(4.h),
                      Text(
                        _toArabicNumber(day['hijriDay']),
                        style: TextStyle(
                          color: isSelected
                              ? selectedDayTextColor
                              : isToday
                              ? todayAccentColor
                              : primaryTextColor,
                          fontSize: 15.sp,
                          fontWeight: isSelected || isToday
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      Gap(4.h),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 4.w,
                        height: 4.w,
                        decoration: BoxDecoration(
                          color: isToday && !isSelected
                              ? todayAccentColor
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}