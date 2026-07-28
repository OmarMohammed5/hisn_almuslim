import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class ZekrHeader extends StatefulWidget {
  final String source;
  final int count;
  final void Function()? onFontTap;

  const ZekrHeader({
    super.key,
    required this.source,
    required this.count,
    required this.onFontTap,
  });

  @override
  State<ZekrHeader> createState() => _ZekrHeaderState();
}

class _ZekrHeaderState extends State<ZekrHeader> {
  // Show Zekr info
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          spacing: 12.w,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.book_outlined, color: accentColor, size: 22.sp),
            ),

            CustomText(
              "معلومات الذكر",
              color: isDarkDialog ? Colors.white : Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.source.toString().isNotEmpty) ...[
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
                        Gap(8.2.w),
                        CustomText(
                          "المصدر",
                          color: accentColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    Gap(12.h),
                    Text(
                      widget.source,
                      style: TextStyle(
                        fontSize: 15.sp,
                        height: 1.8.h,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Amiri Quran",

                        color: isDarkDialog ? Colors.white : Colors.black,
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
                  spacing: 12.w,
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey, size: 20.sp),
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
            if (widget.count != 0) ...[
              Gap(12.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.w,
                  children: [
                    Icon(Icons.repeat_rounded, color: accentColor, size: 18.sp),

                    CustomText(
                      " عدد التكرار :  ",
                      color: isDarkDialog ? Colors.white : Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomText(
                      "${widget.count} مرة",
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? Color(0xff1c1c1c) : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: isDark ? Color(0xff383838) : Colors.white),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Control of font size
              GestureDetector(
                onTap: widget.onFontTap,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xff273835) : Color(0xffe0efed),
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: Colors.teal.shade200),
                  ),
                  child: Icon(
                    Icons.text_fields,
                    color: isDark ? Color(0xff61f9d5) : Color(0xff2f8a7e),
                    size: 25.sp,
                  ),
                ),
              ),

              /// Info and number of Repeating
              Row(
                spacing: 4.w,
                children: [
                  _chip(icon: Icons.repeat, label: "${widget.count} مرة"),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => _showInfoDialog(
                            context,
                            Colors.teal,
                            Colors.black87,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Color(0xff273835)
                                  : Color(0xffe0efed),
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(color: Colors.teal.shade200),
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: isDark
                                  ? Color(0xff61f9d5)
                                  : Color(0xff2f8a7e),
                              size: 25.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isDark ? Color(0xff273835) : Color(0xffe0efed),

          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: Colors.teal.shade200),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDark ? Color(0xff61f9d5) : Color(0xff2f8a7e),
              size: 20.sp,
            ),
            if (label.isNotEmpty) ...[
              Gap(6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Cairo",
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
