import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/shared/custom_text.dart';
import '../data/models/featured_banner_model.dart';

class FeaturedBannerCard extends StatelessWidget {
  final FeaturedBannerModel banner;
  final VoidCallback onTap;

  const FeaturedBannerCard({
    super.key,
    required this.banner,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Deep teal used across the card (base color + overlay gradient).
    const baseColor = Color(0xFF0B332F);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.r),
          child: Stack(
            fit: StackFit.expand,
            children: [

              const DecoratedBox(
                decoration: BoxDecoration(color: baseColor),
              ),



              Positioned.fill(
                child: Image.asset(
                  banner.image!,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                ),
              ),


              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          baseColor.withValues(alpha: 0.98),
                          baseColor.withValues(alpha: 0.94),
                          baseColor.withValues(alpha: 0.55),
                          baseColor.withValues(alpha: 0.18),
                        ],
                        stops: const [0.0, 0.42, 0.62, 1.0],
                      ),
                    ),
                  ),
                ),
              ),



              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.10),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.16),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // Hairline border for a crisp, defined card edge.
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              Positioned(
                top: 0,
                bottom: 0,
                left: 20.w,
                right: 160.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 14.h,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      CustomText(
                        banner.title,
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        color: Colors.white,
                      ),

                      SizedBox(height: 5.h),

                      // Subtitle
                      CustomText(
                        banner.subtitle,
                        maxLines: 2,
                        textAlign: TextAlign.right,
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                        color: Colors.white.withValues(
                          alpha: 0.78,
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Action Button
                      GestureDetector(
                        onTap: onTap,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade500,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: 0.12,
                                ),
                                blurRadius: 6.r,
                                offset: Offset(0, 2.h),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                'اكتشف الآن',
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),

                              SizedBox(width: 5.w),

                              Icon(
                                Icons.arrow_forward,
                                size: 13.sp,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Subtle Decorative Glow
              Positioned(
                left: -30.w,
                bottom: -35.h,
                child: IgnorePointer(
                  child: Container(
                    width: 110.w,
                    height: 110.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primary.withValues(
                        alpha: isDark ? 0.06 : 0.08,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}