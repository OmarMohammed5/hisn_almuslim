import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  static const Color _bgColor = Color(0xFFE8EDF2);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(24.r),
          // shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Image.asset(
          'assets/icons/loogo.png',
          width: 120.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
