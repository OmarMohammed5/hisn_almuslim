import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
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
      padding: EdgeInsets.symmetric(vertical: AppResponsive.heightValue(context, 8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('صفحة ${toArabicDigits(page.pageNumber)}',
              style: TextStyle(fontSize: AppResponsive.fontSize(context, 11), color: color)),
          _dot(context, color),
          Text('جزء ${toArabicDigits(page.juz)}',
              style: TextStyle(fontSize: AppResponsive.fontSize(context, 11), color: color)),
          _dot(context, color),
          Text('حزب ${toArabicDigits(page.hizbQuarter)}',
              style: TextStyle(fontSize: AppResponsive.fontSize(context, 11), color: color)),
        ],
      ),
    );
  }

  Widget _dot(BuildContext context, Color color) => Padding(
    padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 10)),
    child: Container(
      width: AppResponsive.widthValue(context, 3),
      height: AppResponsive.widthValue(context, 3),
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    ),
  );
}