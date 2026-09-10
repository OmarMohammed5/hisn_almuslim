import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../../domain/entities/lecture.dart';

class FeaturedLectureCard extends StatelessWidget {
  final Lecture lecture;
  final VoidCallback onTap;

  const FeaturedLectureCard({
    super.key,
    required this.lecture,
    required this.onTap,
  });

  String _duration() {
    if (lecture.duration == Duration.zero) return '';
    final minutes = lecture.duration.inMinutes;
    final hours = minutes ~/ 60;
    final remaining = minutes % 60;
    return hours > 0 ? '${hours}س ${remaining}د' : '$minutes د';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          width: 252.w,
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.kPrimary.withValues(alpha: .10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark ? .04 : .025,
                ),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.r),
                ),
                child: SizedBox(
                  height: 124.h,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: lecture.thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => ColoredBox(
                      color: AppColors.kPrimary.withValues(alpha: .06),
                      child: const Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                    errorWidget: (_, __, ___) => ColoredBox(
                      color: AppColors.kPrimary.withValues(alpha: .07),
                      child: Icon(
                        Icons.ondemand_video_rounded,
                        color: AppColors.kPrimary,
                        size: 32.sp,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 11.h, 12.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      lecture.title,
                      maxLines: 2,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.35,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_outline_rounded,
                          size: 14.sp,
                          color: AppColors.kPrimary,
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: CustomText(
                            lecture.channelName,
                            maxLines: 1,
                            fontSize: 9.5.sp,
                            color: scheme.onSurface.withValues(alpha: .55),
                          ),
                        ),
                        if (_duration().isNotEmpty)
                          CustomText(
                            _duration(),
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.kPrimary,
                          ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      'YouTube',
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface.withValues(alpha: .42),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
