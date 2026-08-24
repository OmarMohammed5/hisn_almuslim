import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final String title;
  final IconData icon;

  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);

    final isDark =
        theme.brightness ==
            Brightness.dark;

    final teal =
    isDark
        ? AppColors.kPrimaryLight
        : AppColors.kPrimary;

    return SizedBox(
      height: 38.h,
      child: Row(
        children: [

          // Section title
          Container(
            width: 4.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: teal,
              borderRadius:
              BorderRadius.circular(10.r),
            ),
          ),

          SizedBox(width: 9.w),

          Expanded(
            child: CustomText(
              title,
              fontSize: 17.sp,
              fontWeight:
              FontWeight.w900,
              color:
              theme.colorScheme.onSurface,
              maxLines: 1,
            ),
          ),


          // Optional action
          if (actionLabel != null &&
              onAction != null)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onAction,
                borderRadius:
                BorderRadius.circular(
                  12.r,
                ),
                splashColor:
                teal.withValues(
                  alpha: .08,
                ),
                highlightColor:
                teal.withValues(
                  alpha: .04,
                ),
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(
                    horizontal: 7.w,
                    vertical: 6.h,
                  ),
                  child: Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      CustomText(
                        actionLabel!,
                        fontSize: 11.5.sp,
                        fontWeight:
                        FontWeight.w700,
                        color: teal,
                      ),

                      SizedBox(width: 4.w),

                      AnimatedRotation(
                        turns:
                        actionLabel ==
                            'عرض أقل'
                            ? -.5
                            : 0,
                        duration:
                        const Duration(
                          milliseconds: 280,
                        ),
                        curve:
                        Curves.easeOutCubic,
                        child: Icon(
                          actionIcon ??
                              Icons
                                  .arrow_back_ios_new_rounded,
                          size: 11.sp,
                          color: teal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Section icon
          if (actionLabel == null ||
              onAction == null)
            SizedBox(width: 8.w),

          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: teal.withValues(
                alpha: isDark ? .13 : .07,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 17.sp,
              color: teal,
            ),
          ),
        ],
      ),
    );
  }
}