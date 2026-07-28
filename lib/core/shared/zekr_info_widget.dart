import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class ZekrInfoWidget extends StatelessWidget {
  final Map<String, dynamic> zekr;
  final bool isDark;

  const ZekrInfoWidget({super.key, required this.zekr, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final accentColor = isDark
        ? Colors.tealAccent.shade200
        : Colors.teal.shade700;
    final textColor = isDark ? Colors.white : Colors.black87;
    // final subTextColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 6.w,
        children: [
          // Count Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.3),
                width: 1.5.w,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.repeat_rounded, color: accentColor, size: 18.sp),
                Gap(8.w),
                CustomText(
                  "${zekr['count']}",
                  color: accentColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                Gap(4.w),
                CustomText(
                  "مرة",
                  color: textColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),

          // Info Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _showInfoDialog(context, accentColor, textColor);
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: accentColor,
                  size: 22.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(
    BuildContext context,
    Color accentColor,
    Color textColor,
  ) {
    final isDarkDialog = Theme.of(context).brightness == Brightness.dark;
    final dialogBgColor = isDarkDialog ? const Color(0xFF1E1E1E) : Colors.white;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: dialogBgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.book_outlined, color: accentColor, size: 22.sp),
            ),
            Gap(12.w),
            CustomText(
              "معلومات الذكر",
              color: textColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (zekr['source'].toString().isNotEmpty) ...[
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.2),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          color: accentColor,
                          size: 18.sp,
                        ),
                        Gap(8.w),
                        CustomText(
                          "المصدر",
                          color: accentColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    Gap(8.h),
                    Text(
                      zekr['source'],
                      style: TextStyle(
                        fontSize: 15.sp,
                        height: 1.8.h,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Amiri Quran",
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey, size: 20.sp),
                    Gap(12.w),

                    Expanded(
                      child: CustomText(
                        "لا توجد معلومات إضافية",
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (zekr['count'] != null) ...[
              Gap(12.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.repeat_rounded, color: accentColor, size: 18.sp),
                    Gap(8.w),
                    CustomText(
                      "عدد التكرار: ",
                      color: textColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomText(
                      "${zekr['count']} مرة",
                      color: accentColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: accentColor.withValues(alpha: 0.12),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: CustomText(
              "إغلاق",
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ],
        actionsPadding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
      ),
    );
  }
}
