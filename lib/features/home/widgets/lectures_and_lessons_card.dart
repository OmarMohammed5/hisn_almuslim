import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/shared/custom_text.dart';

class LecturesAndLessonsCard extends StatelessWidget {
  const LecturesAndLessonsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
      ),
      child: InkWell(
        onTap: () async{
          final preferences = await SharedPreferences.getInstance();
          Navigator.pushNamed(
            context,
            AppRoutes.lectures,
            arguments: preferences,
          );
        },
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: AppColors.kPrimary.withValues(alpha: 0.08),
            border: Border.all(
              color: AppColors.kPrimary.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: AppColors.kPrimary,
                size: 30.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'المحاضرات والدروس',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                    ),
                    SizedBox(height: 10.h),
                    CustomText(
                      'استمع إلى دروس ومحاضرات إيمانية',
                      fontSize: 10.5.sp,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
