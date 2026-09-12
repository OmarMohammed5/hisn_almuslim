import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/app_colors.dart';

class ChapterCard extends StatelessWidget {
  final int chapterId;
  final String chapterTitle;
  final int? count;
  final VoidCallback onTap;
  final String? subtitle;
  final IconData? trailingIcon;

  const ChapterCard({
    super.key,
    required this.chapterId,
    required this.onTap,
    required this.chapterTitle,
    this.count,
    this.subtitle,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppResponsive.widthValue(context, 6),
          vertical: AppResponsive.heightValue(context, 5),
        ),
        padding: EdgeInsets.all(AppResponsive.widthValue(context, 12)),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : Colors.blue.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: Offset(0, 6),
              spreadRadius: 2,
            ),
          ],
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          children: [
            ///  Chapter Number
            Container(
              width: AppResponsive.widthValue(context, 37),
              height: AppResponsive.widthValue(context, 37),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.teal.shade700,
                    Colors.teal.shade400,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  chapterId.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "Cairo",
                    fontSize: AppResponsive.fontSize(context, 18),
                  ),
                ),
              ),
            ),

            Gap(AppResponsive.widthValue(context, 12)),

            ///  Title + Count
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapterTitle,
                    maxLines: 20,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 17),
                      fontWeight: FontWeight.w700,
                      fontFamily: "Noon",
                      color: isDark ? Colors.white : Color(0xFF1A1A2E),
                      height: 1.7,
                    ),
                  ),
                  Gap(AppResponsive.heightValue(context, 6)),
                  Row(
                    children: [
                      if (count != null) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppResponsive.widthValue(context, 8),
                            vertical: AppResponsive.heightValue(context, 2),
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.blue.withValues(alpha: 0.15)
                                : Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.format_quote_rounded,
                                size: AppResponsive.iconSize(context, 12),
                                color: isDark
                                    ? Colors.teal.shade600
                                    : Colors.teal.shade800,
                              ),
                              Gap(AppResponsive.widthValue(context, 5)),
                              Text(
                                '$count أحاديث',
                                style: TextStyle(
                                  fontSize: AppResponsive.fontSize(context, 10),
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.teal.shade300
                                      : Colors.teal.shade600,
                                  fontFamily: "Noon",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (subtitle != null) ...[
                        if (count != null) Gap(AppResponsive.widthValue(context, 8)),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: AppResponsive.fontSize(context, 11),
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                            fontFamily: "Noon",
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade400.withValues(alpha: 0.1),
                    Colors.blue.shade700.withValues(alpha: 0.05),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.teal.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Icon(
                trailingIcon ?? Icons.arrow_forward_ios_rounded,
                size: AppResponsive.iconSize(context, 16),
                color: isDark
                    ? Colors.teal.shade500
                    : Colors.teal.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}