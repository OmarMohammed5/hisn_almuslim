import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/prophet_story.dart';

class StoryHeader extends StatelessWidget {
  final ProphetStory story;
  final int currentIndex;
  final int totalStories;

  const StoryHeader({super.key,
    required this.story,
    required this.currentIndex,
    required this.totalStories,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accentColor = isDark
        ? Colors.tealAccent.shade200
        : Colors.teal.shade700;

    final titleColor = isDark
        ? Colors.white
        : const Color(0xFF151817);

    final secondaryColor = isDark
        ? Colors.white.withValues(alpha: 0.42)
        : Colors.black.withValues(alpha: 0.42);

    final mutedColor = isDark
        ? Colors.white.withValues(alpha: 0.22)
        : Colors.black.withValues(alpha: 0.22);

    final progress = totalStories > 0
        ? (currentIndex + 1) / totalStories
        : 0.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20.w,
        10.h,
        20.w,
        14.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TOP META
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Story number
              Row(
                children: [
                  // PROPHET NAME
                  Text(
                    story.prophet,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                      fontFamily: 'Noon',
                      height: 1.25,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${(currentIndex + 1).toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                        fontFamily: 'QuranFont',
                      ),
                    ),
                  ),
                  SizedBox(width: 7.w),

                  Text(
                    'من $totalStories',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: mutedColor,
                      fontFamily: 'Noon',
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4.h),
          // POSITION
          Text(
            'القصة ${currentIndex + 1} من $totalStories',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w500,
              color: secondaryColor,
              fontFamily: 'Noon',
            ),
          ),

          SizedBox(height: 14.h),

          // PROGRESS
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Stack(
              children: [
                // Background
                Container(
                  height: 3.h,
                  width: double.infinity,
                  color: accentColor.withValues(alpha: 0.08),
                ),

                // Progress
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
