import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/hadith/widgets/hadith_number.dart';
import 'package:hisn_almuslim/features/hadith/widgets/hadith_title.dart';

class Content extends StatelessWidget {
  const Content({
    super.key,
    required this.fontSize,
    required this.title,
    required this.content,
    required this.numberOfHadith,
  });
  final double fontSize;
  final String title;
  final String content;
  final int numberOfHadith;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      spacing: 24.h,
      children: [
        // Number of Hadith
        HadithNumber(number: numberOfHadith),

        // Title
        HadithTitle(title: title),

        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: isDark ? Color(0xff1c2227) : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            content,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: fontSize.sp,
              height: 2.0.h,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
              fontFamily: "Uthmani",
            ),
          ),
        ),
      ],
    );
  }
}
