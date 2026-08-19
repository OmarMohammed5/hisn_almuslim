import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_snack_bar.dart';
import 'package:hisn_almuslim/features/hadith/widgets/hadith_number.dart';
import 'package:hisn_almuslim/features/hadith/widgets/hadith_title.dart';

import '../../../core/helpers/share_helper.dart';

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

  void _copyContent(BuildContext context) {
    Clipboard.setData(ClipboardData(text: content.trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(
        "تم نسخ الحديث",
        Icons.check_circle,
        context,
        lightColor: Colors.teal,
        darkColor: Colors.teal.shade400,
      ),
    );
  }

  void _shareContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ShareHelper.shareAsImage(context, content.trim(), isDark: isDark, category: "الأربعون النووية");
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      spacing: 16.h,
      children: [
        // Number of Hadith
        HadithNumber(number: numberOfHadith),

        // Title
        HadithTitle(title: title),

        Gap(8.h),

        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF1A1A2E) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? Colors.grey.shade800
                  : Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    context: context,
                    icon: Icons.copy_rounded,
                    label: 'نسخ',
                    onTap: () => _copyContent(context),
                    isDark: isDark,
                  ),
                  Gap(16.w),
                  _buildActionButton(
                    context: context,
                    icon: Icons.share_rounded,
                    label: 'مشاركة',
                    onTap: () => _shareContent(context),
                    isDark: isDark,
                  ),
                ],
              ),
              Gap(16.h),

              Container(
                height: 1.h,
                color: isDark
                    ? Colors.grey.shade800
                    : Colors.grey.shade200,
              ),

              Gap(16.h),

              Text(
                content.trim(),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: fontSize.sp,
                  height: 2.2.h,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  fontFamily: "Uthmani",
                  color: isDark ? Colors.white : Color(0xFF1A1A2E),
                ),
              ),

              Gap(20.h),



            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            Gap(6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                fontFamily: "QuranFont",
              ),
            ),
          ],
        ),
      ),
    );
  }
}