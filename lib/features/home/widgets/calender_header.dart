import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
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
      padding: EdgeInsets.fromLTRB(AppResponsive.widthValue(context, 20), AppResponsive.heightValue(context, 18), AppResponsive.widthValue(context, 20), AppResponsive.heightValue(context, 16)),
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
                      width: AppResponsive.widthValue(context, 56),
                      height: AppResponsive.widthValue(context, 56),
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
                            fontSize: AppResponsive.fontSize(context, 32),
                            fontWeight: FontWeight.w900,
                            height: 1,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(AppResponsive.widthValue(context, 12)),
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
                            fontSize: AppResponsive.fontSize(context, 16),
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Gap(AppResponsive.widthValue(context, 6)),
                        Container(
                          width: AppResponsive.widthValue(context, 4),
                          height: AppResponsive.widthValue(context, 4),
                          decoration: const BoxDecoration(
                            color: _primaryLight,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Gap(AppResponsive.widthValue(context, 6)),
                        Text(
                          '${_toArabicNumber(widget.selectedHijri.hYear)} هـ',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: AppResponsive.fontSize(context, 12),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                    Gap(AppResponsive.heightValue(context, 4)),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: AppResponsive.fontSize(context, 12),
                        ),
                        Gap(AppResponsive.widthValue(context, 4)),
                        Text(
                          _getGregorianDate(widget.selectedDate),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: AppResponsive.fontSize(context, 10),
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
              padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 10), vertical: AppResponsive.heightValue(context, 6)),
              decoration: BoxDecoration(
                color: _primaryDark,
                borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
                boxShadow: [
                  BoxShadow(
                    color: _primaryDark.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: Offset(0, AppResponsive.heightValue(context, 4)),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.today_rounded, color: Colors.white, size: AppResponsive.fontSize(context, 12)),
                  Gap(AppResponsive.widthValue(context, 4)),
                  Text(
                    'اليوم',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppResponsive.fontSize(context, 10),
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
