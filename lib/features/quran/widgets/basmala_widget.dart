import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/shared/custom_text.dart';

class BasmalaWidget extends StatelessWidget {
  final bool dark;
  final Color gold;

  const BasmalaWidget({super.key, required this.dark, required this.gold});

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: EdgeInsets.only(top: 3.h, bottom: 17.h),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22.w,
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, gold.withValues(alpha: .30)],
                ),
              ),
            ),

            SizedBox(width: 4.w),
            CustomText(
              "﴿",
              fontSize: 12.sp,
              color: gold.withValues(alpha: .45),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  dark ? gold : const Color(0xFF9D8050),
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/images/basmala.png',
                  height: 36.h,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            CustomText(
              "﴾",
              fontSize: 12.sp,
              color: gold.withValues(alpha: .45),
              fontWeight: FontWeight.bold,
            ),

            SizedBox(width: 4.w),

            Container(
              width: 22.w,
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [gold.withValues(alpha: .30), Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
