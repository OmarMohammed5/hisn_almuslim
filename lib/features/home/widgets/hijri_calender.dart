import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';

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

  String _getArabicMonth(int month) {
    const months = [
      'محرم',
      'صفر',
      'ربيع الأول',
      'ربيع الآخر',
      'جمادى الأولى',
      'جمادى الآخرة',
      'رجب',
      'شعبان',
      'رمضان',
      'شوال',
      'ذو القعدة',
      'ذو الحجة',
    ];
    return months[month - 1];
  }

  String _toArabicNumber(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((d) => arabicDigits[int.parse(d)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.teal.shade800.withOpacity(0.9),
            Colors.teal.shade900.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1A3A5C).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // ===== Header =====
          _buildHeader(isDark),

          // ===== Days of Week =====
          _buildWeekStrip(isDark),

          Gap(12.h),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl,
        children: [
          // Hijri Calender
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    _toArabicNumber(_today.hDay),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  Gap(10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5.h,
                    children: [
                      CustomText(
                        _getArabicMonth(_today.hMonth),
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      Text(
                        '${_toArabicNumber(_today.hYear)} هـ',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Gregorian Calender
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Text(
                  _getGregorianDate(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekStrip(bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _weekDays.map((day) {
          final isSelected = day['hijriDay'] == _selectedDay;
          final isToday = day['isToday'] as bool;

          return GestureDetector(
            onTap: () => setState(() => _selectedDay = day['hijriDay']),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 38.5.w,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.teal.shade400.withValues(alpha: 0.99)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Text(
                    day['weekDay'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white60,
                      fontSize: 12.sp,
                      fontFamily: "Al mushaf",
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    _toArabicNumber(day['hijriDay']),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : isToday
                          ? Color(0xFFD4AF37)
                          : Colors.white,
                      fontSize: 15.sp,
                      fontWeight: isSelected || isToday
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  Gap(4.h),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: isToday && !isSelected
                          ? Color(0xFFD4AF37)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getGregorianDate() {
    final now = DateTime.now(); // The Current data of Day
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}
