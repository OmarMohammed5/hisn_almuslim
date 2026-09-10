import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../../../core/responsive/app_responsive.dart';

class CategoriesHeader extends StatelessWidget {
  const CategoriesHeader({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final tealColor = isDark ? Colors.teal.shade400 : Colors.teal.shade600;

    return Container(
      margin: EdgeInsets.fromLTRB(AppResponsive.widthValue(context, 16), AppResponsive.heightValue(context, 12), AppResponsive.widthValue(context, 16), AppResponsive.heightValue(context, 12)),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppResponsive.widthValue(context, 6),
                height: AppResponsive.heightValue(context, 6),
                decoration: BoxDecoration(
                  color: tealColor.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
              Gap(AppResponsive.heightValue(context, 3)),

              Container(
                width: AppResponsive.widthValue(context, 2),
                height: AppResponsive.heightValue(context, 24),
                decoration: BoxDecoration(
                  color: tealColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(AppResponsive.radius(context, 2)),
                ),
              ),
              Gap(AppResponsive.heightValue(context, 3)),

              Container(
                width: AppResponsive.widthValue(context, 6),
                height: AppResponsive.heightValue(context, 6),
                decoration: BoxDecoration(
                  color: tealColor.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          Gap(AppResponsive.widthValue(context, 12)),

          Expanded(
            child: CustomText(
              'الأقسام',
              fontSize: AppResponsive.fontSize(context, 16),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              fontFamily: "QuranFont",
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 8), vertical: AppResponsive.heightValue(context, 6)),
            decoration: BoxDecoration(
              color: isDark
                  ? tealColor.withOpacity(0.1)
                  : Colors.teal.shade50.withOpacity(0.6),
              borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
              border: Border.all(
                color: tealColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.apps_rounded,
              color: tealColor,
              size: AppResponsive.fontSize(context, 14),
            ),
          ),
        ],
      ),
    );
  }
}