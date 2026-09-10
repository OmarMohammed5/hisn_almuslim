import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/responsive/app_responsive.dart';

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
              fontSize: AppResponsive.fontSize(context, 26),
              fontWeight: FontWeight.bold,
              fontFamily: 'Al mushaf',
              height: 1.3,
            ),
          ),
          SizedBox(height: AppResponsive.heightValue(context, 4)),
          CustomText(
            englishName,
            textAlign: TextAlign.center,
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: AppResponsive.fontSize(context, 13),
              fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}