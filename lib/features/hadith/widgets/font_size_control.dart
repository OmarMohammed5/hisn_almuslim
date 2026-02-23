import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FontSizeControl extends StatelessWidget {
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final bool isDark;

  const FontSizeControl({
    super.key,
    required this.onIncrease,
    required this.onDecrease,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff22272b) : const Color(0xffe9eef0),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 6.w,
        children: [
          IconButton(
            icon: Icon(
              Icons.text_increase,
              size: 22.sp,
              color: Colors.teal.shade700,
            ),
            onPressed: onIncrease,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Text(
            'حجم الخط',
            style: TextStyle(fontSize: 11.sp, fontFamily: "Cairo"),
          ),
          IconButton(
            icon: Icon(
              Icons.text_decrease,
              size: 22.sp,
              color: Colors.teal.shade700,
            ),
            onPressed: onDecrease,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
