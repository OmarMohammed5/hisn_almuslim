import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/features/lectures/domain/entities/sheikh.dart';

import '../../../../core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';

class SheikhHeader extends StatelessWidget {
  final Sheikh sheikh;
  final ColorScheme scheme;
  final bool isDark;

  const SheikhHeader({
    super.key,
    required this.scheme,
    required this.isDark,
    required this.sheikh,
  });

  @override
  Widget build(BuildContext context) {
    final bannerHeight = AppResponsive.heightValue(context, 110);
    final avatarSize = AppResponsive.widthValue(context, 86);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
        border: Border.all(color: AppColors.kPrimary.withValues(alpha: .10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .18 : .04),
            blurRadius: AppResponsive.radius(context, 14),
            offset: Offset(0, AppResponsive.heightValue(context, 5)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================================
          // 1. BANNER (YouTube style cover image area)
          // ============================================
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppResponsive.radius(context, 20)),
            ),
            child: Container(
              height: bannerHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppColors.kPrimary.withValues(alpha: isDark ? .45 : .25),
                    AppColors.kPrimary.withValues(alpha: isDark ? .15 : .08),
                  ],
                ),
              ),
              // Optional: subtle pattern/overlay
              child: Stack(
                children: [
                  Positioned(
                    top: -20,
                    left: -20,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: .05),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    right: -10,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: .04),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ============================================
          // 2. AVATAR + NAME + BUTTON (overlapping area)
          // ============================================
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.widthValue(context, 16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Avatar (overlapping the banner) ---
                Transform.translate(
                  offset: Offset(0, -avatarSize * 0.45),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Avatar with ring
                      Container(
                        width: avatarSize,
                        height: avatarSize,
                        padding: EdgeInsets.all(AppResponsive.widthValue(context, 3)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: scheme.surface,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? .3 : .12),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Container(
                          padding: EdgeInsets.all(AppResponsive.widthValue(context, 2)),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                AppColors.kPrimary,
                                AppColors.kPrimary.withValues(alpha: 0.4),
                              ],
                            ),
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: sheikh.thumbnailUrl,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                color: scheme.surfaceContainerHighest,
                                child: CupertinoActivityIndicator(
                                  color: AppColors.kPrimary,
                                  radius: 12,
                                ),
                              ),
                              errorWidget: (_, __, ___) => Container(
                                color: scheme.surfaceContainerHighest,
                                child: Icon(
                                  Icons.person_rounded,
                                  color: AppColors.kPrimary,
                                  size: AppResponsive.fontSize(context, 32),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Subscribe / Action Button (YouTube style)
                      Transform.translate(
                        offset: Offset(0, -AppResponsive.heightValue(context, 6)),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppResponsive.widthValue(context, 18),
                            vertical: AppResponsive.heightValue(context, 9),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.kPrimary,
                            borderRadius: BorderRadius.circular(
                              AppResponsive.radius(context, 30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.kPrimary.withValues(alpha: .3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_circle_fill_rounded,
                                size: AppResponsive.fontSize(context, 16),
                                color: Colors.white,
                              ),
                              SizedBox(width: AppResponsive.widthValue(context, 6)),
                              CustomText(
                                'مشاهدة',
                                fontSize: AppResponsive.fontSize(context, 11.5),
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- Name ---
                Transform.translate(
                  offset: Offset(0, -avatarSize * 0.25),
                  child: CustomText(
                    sheikh.name,
                    maxLines: 12,
                    textAlign: TextAlign.start,
                    fontSize: AppResponsive.fontSize(context, 14),
                    fontWeight: FontWeight.w600,
                    height: AppResponsive.heightValue(context, 1.2),
                  ),
                ),

                Gap(AppResponsive.heightValue(context, 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}