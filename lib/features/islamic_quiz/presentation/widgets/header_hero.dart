import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../theme/quiz_tokens.dart';

class HeroHeader extends StatelessWidget {
  const HeroHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(22.w, 24.h, 22.w, 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            QuizColors.primarySoft(context),
            QuizColors.primarySoft(context).withValues(alpha: .55),
          ],
        ),
        borderRadius: BorderRadius.circular(QuizRadius.xl.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [

          // Content
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 62.w,
                height: 62.w,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).scaffoldBackgroundColor.withValues(alpha: .7),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  size: 30.sp,
                  color: QuizColors.primary(context),
                ),
              ),

              SizedBox(width: 16.w),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 7.h,
                  children: [
                    CustomText(
                      'اختبر معرفتك الدينيه',
                      fontSize: 13.sp,
                    ),
                    CustomText(
                      "وَقُل رَّبِّ زِدْنِي عِلْمًا",
                      maxLines: 3,
                      fontSize: 12.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
