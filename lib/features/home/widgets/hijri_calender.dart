import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hisn_almuslim/features/home/widgets/calender_day_item.dart';
import 'package:hisn_almuslim/features/home/widgets/calender_header.dart';

class HijriCalendarCard extends StatefulWidget {
  const HijriCalendarCard({super.key});

  @override
  State<HijriCalendarCard> createState() => _HijriCalendarCardState();
}

class _HijriCalendarCardState extends State<HijriCalendarCard> {
  late HijriCalendar _today;
  late List<Map<String, dynamic>> _weekDays;
  int _selectedIndex = 3;

  // App Identity Colors
  static const Color _primary = Color(0xFF0E8A78);
  static const Color _lightText = Color(0xFF18312D);
  static const Color _darkSurface = Color(0xFF102622);

  @override
  void initState() {
    super.initState();
    _today = HijriCalendar.now();
    _generateWeekDays();
  }

  // Build Week Data
  void _generateWeekDays() {
    _weekDays = [];
    for (int i = -3; i <= 3; i++) {
      final date = DateTime.now().add(Duration(days: i));
      final hijri = HijriCalendar.fromDate(date);
      _weekDays.add({
        'date': date,
        'hijri': hijri,
        'hijriDay': hijri.hDay,
        'weekDay': _getArabicWeekDay(date.weekday),
        'shortWeekDay': _getShortArabicWeekDay(date.weekday),
        'isToday': i == 0,
        'isFriday': date.weekday == 5,
      });
    }
  }

  // Arabic Week Days
  String _getArabicWeekDay(int weekday) {
    const days = [
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    return days[weekday - 1];
  }

  String _getShortArabicWeekDay(int weekday) {
    const days = ['إثن', 'ثلا', 'أرب', 'خمي', 'جمع', 'سبت', 'أحد'];
    return days[weekday - 1];
  }

  // Main UI
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedDay = _weekDays[_selectedIndex];
    final selectedHijri = selectedDay['hijri'] as HijriCalendar;
    final selectedDate = selectedDay['date'] as DateTime;
    final selectedIsToday = selectedDay['isToday'] as bool;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: isDark ? _darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE1EEEA),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _primary.withValues(alpha: isDark ? 0.15 : 0.08),
            blurRadius: 30,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalenderHeader(
            isDark: isDark,
            selectedHijri: selectedHijri,
            selectedDate: selectedDate,
            selectedIsToday: selectedIsToday,
          ),
          _buildWeekDays(isDark: isDark),
        ],
      ),
    );
  }

  // Week Days - Improved with fixed size
  Widget _buildWeekDays({required bool isDark}) {
    final textColor = isDark ? Colors.white : _lightText;

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 3.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: _primary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Gap(6.w),
              Text(
                'أيام الأسبوع',
                style: TextStyle(
                  color: textColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          Gap(10.h),
          SizedBox(
            height: 62.h,
            child: Row(
              children: List.generate(
                _weekDays.length,
                (index) => Expanded(
                  child: CalenderDayItem(
                    index: index,
                    isDark: isDark,
                    isSelected: _selectedIndex == index,
                    dayData: _weekDays[index],
                    onTap: () {
                      if (_selectedIndex == index) return;
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
