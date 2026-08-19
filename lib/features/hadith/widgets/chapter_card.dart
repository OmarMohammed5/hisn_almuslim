import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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
    final bgColor = isDark ? const Color(0xFF0F171A) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(12.w),
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
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.blue.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            ///  Chapter Number
            Container(
              width: 37.w,
              height: 37.w,
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
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),

            Gap(16.w),

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
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: "AlqalamQuranMajeed2",
                      color: isDark ? Colors.white : Color(0xFF1A1A2E),
                      height: 1.7,
                    ),
                  ),
                  Gap(6.h),
                  Row(
                    children: [
                      if (count != null) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
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
                                size: 12.sp,
                                color: isDark
                                    ? Colors.teal.shade600
                                    : Colors.teal.shade800,
                              ),
                              Gap(5.w),
                              Text(
                                '$count أحاديث',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.teal.shade300
                                      : Colors.teal.shade600,
                                  fontFamily: "Cairo",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (subtitle != null) ...[
                        if (count != null) Gap(8.w),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                            fontFamily: "Cairo",
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(8.w),
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
                size: 16.sp,
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