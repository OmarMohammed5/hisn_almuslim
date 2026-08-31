import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/arabic_digits.dart';
import '../domain/entities/mushaf_page_entity.dart';
import '../theme/mushaf_colors.dart';

class PageFooter extends StatelessWidget {
  final MushafPageEntity page;

  const PageFooter({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color =
    (isDark ? MushafColors.goldDark : MushafColors.gold).withOpacity(0.85);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('صفحة ${toArabicDigits(page.pageNumber)}',
              style: TextStyle(fontSize: 11.sp, color: color)),
          _dot(color),
          Text('جزء ${toArabicDigits(page.juz)}',
              style: TextStyle(fontSize: 11.sp, color: color)),
          _dot(color),
          Text('حزب ${toArabicDigits(page.hizbQuarter)}',
              style: TextStyle(fontSize: 11.sp, color: color)),
        ],
      ),
    );
  }

  Widget _dot(Color color) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.w),
    child: Container(
      width: 3.w,
      height: 3.w,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    ),
  );
}