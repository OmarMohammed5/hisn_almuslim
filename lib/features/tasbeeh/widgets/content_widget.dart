import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ContentWidget extends StatelessWidget {
  const ContentWidget({
    super.key,
    required this.isDark,
    required this.contentType,
  });

  final bool isDark;
  final String contentType;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            /// Decorative Line
            Container(
              width: 60.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),

            Gap(24.h),

            /// Tasbeeh Text
            Text(
              contentType,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                height: 2.h,
                fontFamily: "Noon",
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
