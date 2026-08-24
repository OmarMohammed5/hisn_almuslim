import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/lectures/domain/entities/lecture.dart';

import '../../../../core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';

class PlayerMainContent extends StatelessWidget {
  final Lecture lecture;
  const PlayerMainContent({super.key, required this.lecture});

  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context).colorScheme;

    return  Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          // Category / Label
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 11.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.kPrimary
                  .withValues(alpha: .08),
              borderRadius:
              BorderRadius.circular(10.r),
              border: Border.all(
                color: AppColors.kPrimary
                    .withValues(alpha: .12),
              ),
            ),
            child: Row(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                Icon(
                  Icons.play_circle_outline_rounded,
                  size: 15.sp,
                  color:
                  AppColors.kPrimary,
                ),
                SizedBox(width: 6.w),
                CustomText(
                  'محاضرة',
                  fontSize: 10.5.sp,
                  fontWeight:
                  FontWeight.w700,
                  color:
                  AppColors.kPrimary,
                ),
              ],
            ),
          ),

          Gap(12.h),

          // Lecture Title

          CustomText(
            lecture.title,
            fontSize: 20.sp,
            fontWeight:
            FontWeight.w900,
            height: 1.45,
            maxLines: 5,
          ),

          Gap(18.h),

          // Sheikh / Channel Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 13.h,
            ),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius:
              BorderRadius.circular(16.r),
              border: Border.all(
                color: scheme.onSurface
                    .withValues(alpha: .07),
              ),
            ),
            child: Row(
              children: [

                // Avatar
                Container(
                  width: 42.w,
                  height: 42.w,
                  decoration:
                  BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors
                        .kPrimary
                        .withValues(
                      alpha: .10,
                    ),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 23.sp,
                    color:
                    AppColors.kPrimary,
                  ),
                ),

                SizedBox(width: 11.w),

                // Name
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'المحاضر',
                        fontSize: 9.5.sp,
                        fontWeight:
                        FontWeight.w600,
                        color: scheme
                            .onSurface
                            .withValues(
                          alpha: .45,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      CustomText(
                        lecture.channelName,
                        fontSize: 12.sp,
                        fontWeight:
                        FontWeight.w800,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),

                // Author icon
                Icon(
                  Icons.verified_outlined,
                  size: 20.sp,
                  color:
                  AppColors.kPrimary,
                ),
              ],
            ),
          ),

          Gap(22.h),

          // About Section
          Row(
            children: [
              Container(
                width: 4.w,
                height: 20.h,
                decoration:
                BoxDecoration(
                  color:
                  AppColors.kPrimary,
                  borderRadius:
                  BorderRadius.circular(
                    10.r,
                  ),
                ),
              ),

              SizedBox(width: 9.w),

              CustomText(
                'عن المحاضرة',
                fontSize: 16.sp,
                fontWeight:
                FontWeight.w900,
              ),
            ],
          ),

          Gap(10.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(
              15.w,
            ),
            decoration: BoxDecoration(
              color: AppColors.kPrimary
                  .withValues(alpha: .045),
              borderRadius:
              BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.kPrimary
                    .withValues(alpha: .08),
              ),
            ),
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 20.sp,
                  color:
                  AppColors.kPrimary,
                ),

                SizedBox(width: 10.w),

                Expanded(
                  child: CustomText(
                    'استمع إلى هذه المحاضرة واستفد من محتواها الدعوي والإيماني.',
                    fontSize: 11.5.sp,
                    height: 1.7,
                    color: scheme
                        .onSurface
                        .withValues(
                      alpha: .65,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Gap(22.h),

          // Bottom Info
          Row(
            children: [

              Expanded(
                child: _InfoItem(
                  icon:
                  Icons.video_library_outlined,
                  title: 'المحتوى',
                  value: 'محاضرة إسلامية',
                ),
              ),

              SizedBox(width: 10.w),

              Expanded(
                child: _InfoItem(
                  icon:
                  Icons.headphones_outlined,
                  title: 'الاستماع',
                  value: 'متاح الآن',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius:
        BorderRadius.circular(14.r),
        border: Border.all(
          color: scheme.onSurface
              .withValues(alpha: .07),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19.sp,
            color: AppColors.kPrimary,
          ),

          SizedBox(width: 8.w),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  fontSize: 9.sp,
                  color: scheme.onSurface
                      .withValues(alpha: .45),
                ),

                SizedBox(height: 3.h),

                CustomText(
                  value,
                  fontSize: 10.5.sp,
                  fontWeight:
                  FontWeight.w700,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



