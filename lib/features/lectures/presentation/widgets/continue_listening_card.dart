import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import '../../../../core/helpers/lecture_progress_storage.dart';
import '../../domain/entities/lecture.dart';

class ContinueListeningCard
    extends StatelessWidget {
  final Lecture lecture;
  final LectureProgressData progress;
  final VoidCallback onContinue;

  const ContinueListeningCard({
    super.key,
    required this.lecture,
    required this.progress,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(22.r),
        color: scheme.surfaceContainerHighest
            .withValues(alpha: .45),
        border: Border.all(
          color: AppColors.kPrimary
              .withValues(alpha: .20),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.kPrimary
                      .withValues(alpha: .10),
                  borderRadius:
                  BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  'متابعة الاستماع',
                  fontSize: 10.5.sp,
                  fontWeight:
                  FontWeight.w800,
                  color: AppColors.kPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(16.r),
                child: CachedNetworkImage(
                  imageUrl:
                  lecture.thumbnailUrl,
                  width: 115.w,
                  height: 78.h,
                  fit: BoxFit.cover,
                  errorWidget:
                      (_, __, ___) {
                    return Container(
                      width: 115.w,
                      height: 78.h,
                      color: AppColors.kPrimary
                          .withValues(alpha: .08),
                      child: Icon(
                        Icons.play_circle_outline,
                        color:
                        AppColors.kPrimary,
                      ),
                    );
                  },
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      lecture.title,
                      maxLines: 3,
                      fontSize: 13.sp,
                      fontWeight:
                      FontWeight.w800,
                      height: 1.4,
                    ),

                    SizedBox(height: 6.h),

                    CustomText(
                      lecture.channelName,
                      maxLines: 3,
                      fontSize: 10.5.sp,
                      color: scheme.onSurface
                          .withValues(
                        alpha: .55,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Progress
          ClipRRect(
            borderRadius:
            BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress.percentage,
              minHeight: 5.h,
              backgroundColor:
              AppColors.kPrimary
                  .withValues(alpha: .08),
              valueColor:
              AlwaysStoppedAnimation(
                AppColors.kPrimary,
              ),
            ),
          ),

          SizedBox(height: 10.h),

          Row(
            children: [
              CustomText(
                '${progress.percentageInt} % مكتمل',
                fontSize: 13.sp,
                fontWeight:
                FontWeight.w600,
                color: scheme.onSurface
                    .withValues(alpha: .50),
              ),

              const Spacer(),

              Material(
                color: AppColors.kPrimary,
                borderRadius:
                BorderRadius.circular(14.r),
                child: InkWell(
                  onTap: onContinue,
                  borderRadius:
                  BorderRadius.circular(14.r),
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 9.h,
                    ),
                    child: Row(
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          size: 17.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5.w),
                        CustomText(
                          'متابعة',
                          fontSize: 11.sp,
                          fontWeight:
                          FontWeight.w800,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}