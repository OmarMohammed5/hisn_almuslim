import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hijri/hijri_calendar.dart';

class CalenderHeader extends StatefulWidget {
  final bool isDark;
  final HijriCalendar selectedHijri;
  final DateTime selectedDate;
  final bool selectedIsToday;

  const CalenderHeader({
    super.key,
    required this.isDark,
    required this.selectedHijri,
    required this.selectedDate,
    required this.selectedIsToday,
  });

  @override
  State<CalenderHeader> createState() => _CalenderHeaderState();
}

class _CalenderHeaderState extends State<CalenderHeader> {
  static const Color _primary = Color(0xFF0E8A78);
  static const Color _primaryLight = Color(0xFF1CAA96);
  static const Color _primaryDark = Color(0xFF0A6B5D);

  // Gregorian Date
  String _getGregorianDate(DateTime date) {
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
    return '${_toArabicNumber(date.day)} ${months[date.month - 1]} ${_toArabicNumber(date.year)} م';
  }

  // Arabic Hijri Months
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

  // Arabic Numbers
  String _toArabicNumber(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((digit) => arabicDigits[int.parse(digit)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: widget.isDark
              ? [
                  const Color(0xFF0B5148),
                  const Color(0xFF073C37),
                  const Color(0xFF052A26),
                ]
              : [_primaryLight, _primary, _primaryDark],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Hijri Date
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Day number with decorative circle
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _toArabicNumber(widget.selectedHijri.hDay),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w900,
                            height: 1,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(12.w),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _getArabicMonth(widget.selectedHijri.hMonth),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Gap(6.w),
                        Container(
                          width: 4.w,
                          height: 4.w,
                          decoration: const BoxDecoration(
                            color: _primaryLight,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Gap(6.w),
                        Text(
                          '${_toArabicNumber(widget.selectedHijri.hYear)} هـ',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                    Gap(4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 12.sp,
                        ),
                        Gap(4.w),
                        Text(
                          _getGregorianDate(widget.selectedDate),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Today Badge
          if (widget.selectedIsToday)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: _primaryDark,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: _primaryDark.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.today_rounded, color: Colors.white, size: 12.sp),
                  Gap(4.w),
                  Text(
                    'اليوم',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
