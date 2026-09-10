import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/shared/custom_text.dart';

class BasmalaWidget extends StatelessWidget {
  final bool dark;
  final Color gold;

  const BasmalaWidget({super.key, required this.dark, required this.gold});

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: EdgeInsets.only(top: AppResponsive.heightValue(context, 3), bottom: AppResponsive.heightValue(context, 17)),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppResponsive.widthValue(context, 22),
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, gold.withValues(alpha: .30)],
                ),
              ),
            ),

            SizedBox(width: AppResponsive.widthValue(context, 4)),
            CustomText(
              "﴿",
              fontSize: AppResponsive.fontSize(context, 12),
              color: gold.withValues(alpha: .45),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 10)),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  dark ? gold : const Color(0xFF9D8050),
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/images/basmala.png',
                  height: AppResponsive.heightValue(context, 36),
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            CustomText(
              "﴾",
              fontSize: AppResponsive.fontSize(context, 12),
              color: gold.withValues(alpha: .45),
              fontWeight: FontWeight.bold,
            ),

            SizedBox(width: AppResponsive.widthValue(context, 4)),

            Container(
              width: AppResponsive.widthValue(context, 22),
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
