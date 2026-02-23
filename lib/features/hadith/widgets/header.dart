import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatelessWidget {
  const Header({super.key, this.onFontTap});

  final void Function()? onFontTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      margin: EdgeInsets.only(left: 7.w, right: 7.w),
      decoration: BoxDecoration(
        color: isDark ? Color(0xff1c2227) : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Color(0xFF677C8D).withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 80.w,
            children: [
              // Back Button
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: isDark ? Colors.white : Color(0xFF3E4D5C),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              // Page Title
              Text(
                'الأربعون النووية',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Uthmani",
                ),
              ),
            ],
          ),

          IconButton(
            icon: Icon(Icons.text_fields, color: Colors.teal.shade700),
            onPressed: onFontTap,
          ),
        ],
      ),
    );
  }
}
