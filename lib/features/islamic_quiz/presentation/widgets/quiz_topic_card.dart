import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../../domain/entities/topic_entity.dart';
import '../theme/quiz_tokens.dart';
import 'quiz_press_scale.dart';

class QuizTopicCard extends StatelessWidget {
  const QuizTopicCard({
    super.key,
    required this.topic,
    required this.onTap,
    this.completedLevels = 0,
  });

  final TopicEntity topic;
  final VoidCallback onTap;
  final int completedLevels;

  @override
  Widget build(BuildContext context) {
    final total = topic.levels.length;
    final progress = total == 0 ? 0.0 : completedLevels / total;
    final hasProgress = completedLevels > 0;

    return QuizPressScale(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(QuizRadius.md.r),
          child: Ink(
            padding: EdgeInsets.all(17.w),
            decoration: BoxDecoration(
              color: QuizColors.card(context),
              borderRadius: BorderRadius.circular(QuizRadius.md.r),
              border: Border.all(color: QuizColors.border(context)),
            ),
            child: Row(
              children: [
                Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: QuizColors.primarySoft(context),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 20.sp,
                    color: AppColors.kPrimary,
                  ),
                ),
                SizedBox(width: QuizSpacing.md.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(topic.name,fontSize: 16.sp , fontWeight: FontWeight.w700,),
                      SizedBox(height: 6.h),
                      if (hasProgress) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(QuizRadius.pill),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: progress),
                            duration: QuizDurations.slow,
                            curve: Curves.easeOut,
                            builder: (context, value, _) => LinearProgressIndicator(
                              value: value,
                              minHeight: 6.h,
                              backgroundColor: QuizColors.border(context),
                              valueColor: AlwaysStoppedAnimation(QuizColors.primary(context)),
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        CustomText(
                          'اكتمل $completedLevels من $total مستويات',
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                      ] else
                        CustomText('$total مستويات',fontWeight: FontWeight.w400, fontSize: 11.sp,),
                    ],
                  ),
                ),
                SizedBox(width: QuizSpacing.sm.w),
                Container(
                  width: 27.w,
                  height: 27.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: QuizColors.primarySoft(
                      context,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14.sp,
                    color: AppColors.kPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
