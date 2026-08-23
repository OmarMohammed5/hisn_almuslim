import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/shared/custom_text.dart';
import '../data/models/featured_banner_model.dart';

class DailyContentBanner extends StatelessWidget {
  final FeaturedBannerModel banner;
  final VoidCallback? onTap;

  const DailyContentBanner({
    super.key,
    required this.banner,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark =
        theme.brightness == Brightness.dark;

    final primary = colorScheme.primary;

    // ----------------------------------------------------------
    // Teal Palette
    // ----------------------------------------------------------

    final backgroundStart = isDark
        ? const Color(0xFF123F3A)
        : const Color(0xFF0F9D8D);

    final backgroundEnd = isDark
        ? const Color(0xFF0B2E2A)
        : const Color(0xFF08796D);

    final textColor = isDark
        ? Colors.white
        : Colors.white;

    final secondaryTextColor = Colors.white.withValues(
      alpha: isDark ? 0.70 : 0.78,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 4.w,
        ),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            22.r,
          ),

          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              backgroundStart,
              backgroundEnd,
            ],
          ),

          border: Border.all(
            color: primary.withValues(
              alpha: isDark ? 0.28 : 0.18,
            ),
            width: 1,
          ),

          boxShadow: [
            BoxShadow(
              color: primary.withValues(
                alpha: isDark ? 0.10 : 0.07,
              ),
              blurRadius: 16.r,
              offset: Offset(
                0,
                6.h,
              ),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            22.r,
          ),
          child: Stack(
            children: [
              // ==================================================
              // Decorative Background Elements
              // ==================================================

              Positioned(
                left: -35.w,
                bottom: -45.h,
                child: IgnorePointer(
                  child: Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(
                        alpha: isDark
                            ? 0.035
                            : 0.055,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                right: -45.w,
                top: -55.h,
                child: IgnorePointer(
                  child: Container(
                    width: 130.w,
                    height: 130.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(
                        alpha: isDark
                            ? 0.025
                            : 0.04,
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // Content
              // ==================================================

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),

                child: Column(
                  children: [
                    // ==================================================
                    // Header
                    // ==================================================

                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        // Icon
                        Container(
                          width: 34.w,
                          height: 34.w,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,

                            color: Colors.white.withValues(
                              alpha: isDark
                                  ? 0.09
                                  : 0.12,
                            ),

                            border: Border.all(
                              color: Colors.white.withValues(
                                alpha: isDark
                                    ? 0.12
                                    : 0.18,
                              ),
                              width: 1,
                            ),
                          ),

                          child: Icon(
                            _getIcon(),
                            size: 18.sp,
                            color: textColor,
                          ),
                        ),

                        SizedBox(width: 9.w),

                        // Title
                        Expanded(
                          child: CustomText(
                            banner.title,
                            maxLines: 1,
                            textAlign:
                            TextAlign.right,
                            fontSize: 13.5.sp,
                            fontWeight:
                            FontWeight.w700,
                            color: textColor,
                          ),
                        ),

                      ],
                    ),

                    // ==================================================
                    // Main Content
                    // ==================================================

                    Expanded(
                      child: Center(
                        child: Padding(
                          padding:
                          EdgeInsets.symmetric(
                            horizontal: 2.w,
                          ),

                          child: CustomText(
                            banner.content ?? '',
                            maxLines: 2,
                            textAlign:
                            TextAlign.center,
                            fontSize: 15.5.sp,
                            fontWeight:
                            FontWeight.w700,
                            height: 1.65,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),

                    // ==================================================
                    // Source
                    // ==================================================

                    CustomText(
                      banner.source ?? '',
                      maxLines: 1,
                      textAlign:
                      TextAlign.center,
                      fontSize: 9.5.sp,
                      fontWeight:
                      FontWeight.w500,
                      color: secondaryTextColor,
                    ),
                    Gap(8.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // Icon According To Content Type
  // ==============================================================

  IconData _getIcon() {
    switch (banner.type) {
      case FeaturedBannerType.ayah:
        return FlutterIslamicIcons.solidQuran2;

      case FeaturedBannerType.hadith:
        return Icons.auto_stories_rounded;

      case FeaturedBannerType.dhikr:
        return FlutterIslamicIcons.tasbihHand;

      case FeaturedBannerType.dua:
        return FlutterIslamicIcons.prayer;

      case FeaturedBannerType.image:
        return Icons.auto_awesome_rounded;
    }
  }
}