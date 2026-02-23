import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ZekrCardWidget extends StatelessWidget {
  const ZekrCardWidget({super.key, required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isDark ? Color(0xff1c2227) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Logo & Title of Zekr
              Expanded(
                child: Row(
                  spacing: 12.w,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: isDark
                          ? const Color(0xFF272a2e)
                          : const Color(0xffE9EEF0),
                      child: Image.asset(
                        "assets/images/decoor.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19.sp,
                          fontFamily: "Uthmani",
                        ),
                        maxLines: 10,
                      ),
                    ),
                  ],
                ),
              ),
              // Icon(Icons.arrow_forward_ios_rounded, size: 20),
              Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF272a2e)
                      : const Color(0xffE9EEF0),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_forward_ios, size: 16.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
