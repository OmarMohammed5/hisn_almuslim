import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../../domain/entities/lecture.dart';

class LectureCard extends StatelessWidget {
  final Lecture lecture;
  final VoidCallback onTap;

  const LectureCard({
    super.key,
    required this.lecture,
    required this.onTap,
  });

  String _duration() {
    final h = lecture.duration.inHours;

    final m = lecture.duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final s = lecture.duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return h > 0
        ? '$h:$m:$s'
        : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(18.r),
      child: Container(
        margin:
        EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius:
          BorderRadius.circular(18.r),
          border: Border.all(
            color: scheme.primary
                .withValues(alpha: .10),
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
              BorderRadius.circular(14.r),
              child: SizedBox(
                width: 126.w,
                height: 78.h,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                      lecture.thumbnailUrl,
                      fit: BoxFit.cover,
                      placeholder:
                          (_, __) =>
                      const Center(
                        child:
                        CupertinoActivityIndicator(),
                      ),
                      errorWidget:
                          (_, __, ___) =>
                          Icon(
                            Icons
                                .ondemand_video_rounded,
                            color:
                            AppColors.kPrimary,
                          ),
                    ),
                    Positioned(
                      left: 6.w,
                      bottom: 6.h,
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 3.h,
                        ),
                        decoration:
                        BoxDecoration(
                          color: Colors.black
                              .withValues(
                            alpha: .72,
                          ),
                          borderRadius:
                          BorderRadius.circular(
                            6.r,
                          ),
                        ),
                        child: CustomText(
                          _duration(),
                          color:
                          Colors.white,
                          fontSize: 9.sp,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  CustomText(
                    lecture.title,
                    maxLines: 3,
                    fontSize: 13.5.sp,
                    fontWeight:
                    FontWeight.w700,
                    height: 1.35,
                  ),
                  SizedBox(height: 12.h),
                  CustomText(
                    lecture.channelName,
                    maxLines: 2,
                    fontSize: 10.5.sp,
                    color: scheme.onSurface
                        .withValues(
                      alpha: .60,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
