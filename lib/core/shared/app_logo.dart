import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFB4923F).withValues(alpha: 0.43) ,
            width: 1.5.w,
          ),
          color: const Color(0xFF063F3A),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withValues(alpha: 0.4),
              blurRadius: 2,
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
