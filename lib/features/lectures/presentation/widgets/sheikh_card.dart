import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../../domain/entities/sheikh.dart';

class SheikhCard extends StatelessWidget {
  final Sheikh sheikh;
  final VoidCallback onTap;
  final bool selected;

  const SheikhCard({
    super.key,
    required this.sheikh,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.r),
            color: selected ? Colors.grey[750] : Colors.grey[750]?.withValues(alpha: isDark ? 0.10 : 0.055,),
            border: Border.all(color: selected ? AppColors.kPrimary : AppColors.kPrimary.withValues(alpha: isDark ? 0.18 : 0.10,), width: 1,),
            boxShadow: [
              if (!selected)
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.06 : 0.025,),
                  blurRadius: 8.r,
                  offset:
                  Offset(0, 3.h),
                ),
            ],
          ),

          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 10.h,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Sheikh Image
              Container(
                width: 68.w,
                height: 68.w,
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                     AppColors.kPrimary,
                      AppColors.kPrimary.withValues(
                        alpha: 0.45,
                      ),
                    ],
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.onTertiary,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: sheikh.thumbnailUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) {
                        return Center(
                          child: CupertinoActivityIndicator(
                            color: AppColors.kPrimary,
                          ),
                        );
                      },

                      errorWidget: (_, __, ___) {
                        return Container(
                          color: AppColors.kPrimary.withValues(alpha: 0.08),
                          child: Icon(
                            Icons.person_rounded,
                            size: 28.sp,
                            color: AppColors.kPrimary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              // Sheikh Name
              Expanded(
                child: Center(
                  child: CustomText(
                    sheikh.name,
                    maxLines: 12,
                    textAlign: TextAlign.center,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              // Open Indicator
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 10.sp,
                color: AppColors.kPrimary.withValues(
                  alpha: 0.65,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}