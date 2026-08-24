import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/lectures/domain/entities/sheikh.dart';

import '../../../../core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';

class SheikhHeader extends StatelessWidget {
  final Sheikh sheikh;
  final ColorScheme scheme;
  final bool isDark;

  const SheikhHeader({super.key, required this.scheme, required this.isDark, required this.sheikh});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.fromLTRB(
        18.w,
        22.h,
        18.w,
        20.h,
      ),

      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.kPrimary.withValues(alpha: .2),),
      ),

      child: Column(
        children: [
          // Sheikh Image
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow

              Container(
                width: 124.w,
                height: 124.w,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color:
                  AppColors.kPrimary
                      .withValues(
                    alpha: .08,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color:
                      AppColors.kPrimary
                          .withValues(
                        alpha: .16,
                      ),
                      blurRadius: 25.r,
                      spreadRadius: 4.r,
                    ),
                  ],
                ),
              ),

              // Image border

              Container(
                width: 108.w,
                height: 108.w,

                padding:
                EdgeInsets.all(3.w),

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color:
                  AppColors.kPrimary,

                  boxShadow: [
                    BoxShadow(
                      color:
                      Colors.black
                          .withValues(
                        alpha:
                        isDark
                            ? .15
                            : .08,
                      ),
                      blurRadius: 12.r,
                      offset:
                      Offset(0, 5.h),
                    ),
                  ],
                ),

                child: ClipOval(
                  child:
                  CachedNetworkImage(
                    imageUrl: sheikh.thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) {
                      return Container(
                        color: scheme.surfaceContainerHighest,
                        child:
                        CupertinoActivityIndicator(
                          color:
                          AppColors
                              .kPrimary,
                        ),
                      );
                    },

                    errorWidget:
                        (_, __, ___) {
                      return Container(
                        color: scheme
                            .surfaceContainerHighest,
                        child: Icon(
                          Icons
                              .person_rounded,
                          color:
                          AppColors
                              .kPrimary,
                          size: 44.sp,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          Gap(18.h),

          // Sheikh Name
          CustomText(
            sheikh.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            fontSize: 19.sp,
            fontWeight: FontWeight.w900,
            height: 1.25,
          ),

          Gap(8.h),

          // Description
          CustomText(
            'استكشف السلاسل والمحاضرات المتاحة',

            textAlign:
            TextAlign.center,

            fontSize: 10.5.sp,

            fontWeight:
            FontWeight.w500,

            color: scheme.onSurface
                .withValues(
              alpha: .55,
            ),

            height: 1.4,
          ),

          Gap(16.h),

          // Video Count
          Container(
            padding:
            EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 8.h,
            ),

            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(
                30.r,
              ),

              color: AppColors.kPrimary
                  .withValues(
                alpha: isDark
                    ? .13
                    : .07,
              ),

              border: Border.all(
                color: scheme.primary
                    .withValues(
                  alpha: .10,
                ),
              ),
            ),

            child: Row(
              mainAxisSize:
              MainAxisSize.min,

              children: [
                Icon(
                  Icons
                      .play_circle_outline_rounded,
                  size: 17.sp,
                  color:
                  AppColors.kPrimary,
                ),

                SizedBox(width: 7.w),

                CustomText(
                  '${sheikh.videoCount} فيديو',

                  fontSize: 11.sp,

                  fontWeight:
                  FontWeight.w800,

                  color:
                  AppColors.kPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );


  }
}

