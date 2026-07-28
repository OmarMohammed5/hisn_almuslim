import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/shared/custom_text.dart';


class SurahTitle extends StatelessWidget {
  final String arabicName;
  final String englishName;

  const SurahTitle({
    super.key,
    required this.arabicName,
    required this.englishName,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: Column(
        key: ValueKey('$arabicName-$englishName'),
        children: [
          Text(
            arabicName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Al mushaf',
              height: 1.3,
            ),
          ),
          SizedBox(height: 4.h),
          CustomText(
            englishName,
            textAlign: TextAlign.center,
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}