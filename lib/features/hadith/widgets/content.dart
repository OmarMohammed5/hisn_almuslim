import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_snack_bar.dart';
import 'package:hisn_almuslim/features/hadith/widgets/hadith_number.dart';
import 'package:hisn_almuslim/features/hadith/widgets/hadith_title.dart';

import '../../../core/helpers/share_helper.dart';
import '../../../core/theme/app_colors.dart';

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

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return Column(
      spacing: 16.h,
      children: [
        // Number of Hadith
        HadithNumber(number: numberOfHadith),

        // Title
        HadithTitle(title: title),

        Gap(AppResponsive.heightValue(context, 8)),

        Container(
          padding: EdgeInsets.all(AppResponsive.widthValue(context, 20)),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(16.r),
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
                  Gap(AppResponsive.widthValue(context, 16)),
                  _buildActionButton(
                    context: context,
                    icon: Icons.share_rounded,
                    label: 'مشاركة',
                    onTap: () => _shareContent(context),
                    isDark: isDark,
                  ),
                ],
              ),
              Gap(AppResponsive.heightValue(context, 16)),

              Container(
                height: 1,
                color: isDark
                    ? Colors.grey.shade800
                    : Colors.grey.shade200,
              ),

              Gap(AppResponsive.heightValue(context, 16)),

              Text(
                content.trim(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  height: 2.2,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  fontFamily: "Uthmani",
                  color: isDark ? Colors.white : Color(0xFF1A1A2E),
                ),
              ),

              Gap(AppResponsive.heightValue(context, 20)),



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
        padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 16), vertical: AppResponsive.heightValue(context, 8)),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 8)),
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
              size: AppResponsive.iconSize(context, 16),
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            Gap(AppResponsive.widthValue(context, 6)),
            Text(
              label,
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 13),
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