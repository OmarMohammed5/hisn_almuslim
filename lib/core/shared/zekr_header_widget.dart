import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/zekr_info_widget.dart';

class ZekrHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> zekr;
  final bool isDark;
  final void Function()? onFontTap;

  const ZekrHeaderWidget({
    super.key,
    required this.isDark,
    required this.zekr,
    this.onFontTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.4)
        : Colors.grey.shade300.withValues(alpha: 0.5);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: isDark
            ? Border.all(color: Colors.grey.shade800, width: 1)
            : Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: isDark ? 12 : 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        // spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Control of font size
          GestureDetector(
            onTap: onFontTap,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isDark ? Color(0xff273835) : Color(0xffe0efed),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Icon(
                Icons.text_fields,
                color: isDark ? Color(0xff61f9d5) : Color(0xff2f8a7e),
                size: 20.sp,
              ),
            ),
          ),
          ZekrInfoWidget(zekr: zekr, isDark: isDark),
        ],
      ),
    );
  }
}
