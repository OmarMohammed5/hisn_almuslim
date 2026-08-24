import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/lecture.dart';
import '../../domain/entities/lecture_progress.dart';

class ContinueLectureCard extends StatelessWidget {
  final Lecture lecture;
  final LectureProgress progress;
  final VoidCallback onTap;

  const ContinueLectureCard({
    super.key,
    required this.lecture,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              scheme.primary.withValues(alpha: 0.16),
              scheme.primary.withValues(alpha: 0.06),
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: scheme.primary.withValues(alpha: 0.14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.play_circle_outline_rounded,
                  color: scheme.primary,
                  size: 22.sp,
                ),
                SizedBox(width: 7.w),
                Expanded(
                  child: Text(
                    'استكمل الاستماع',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: scheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 9.h),
            Text(
              lecture.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              lecture.channelName,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 10.sp,
                color: scheme.onSurface.withValues(alpha: 0.60),
              ),
            ),
            SizedBox(height: 11.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: LinearProgressIndicator(
                minHeight: 6.h,
                value: progress.percentage,
                backgroundColor: scheme.primary.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation(scheme.primary),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              '${(progress.percentage * 100).round()}% مكتمل',
              style: TextStyle(
                fontSize: 9.5.sp,
                color: scheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
