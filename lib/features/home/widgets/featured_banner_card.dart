import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
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
        margin: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 4)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 22)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 22)),
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
                      borderRadius: BorderRadius.circular(AppResponsive.radius(context, 22)),
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
                left: AppResponsive.widthValue(context, 20),
                right: AppResponsive.widthValue(context, 160),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppResponsive.heightValue(context, 14),
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
                        fontSize: AppResponsive.fontSize(context, 18),
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        color: Colors.white,
                      ),

                      SizedBox(height: AppResponsive.heightValue(context, 5)),

                      // Subtitle
                      CustomText(
                        banner.subtitle,
                        maxLines: 2,
                        textAlign: TextAlign.right,
                        fontSize: AppResponsive.fontSize(context, 10.5),
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                        color: Colors.white.withValues(
                          alpha: 0.78,
                        ),
                      ),

                      SizedBox(height: AppResponsive.heightValue(context, 12)),

                      // Action Button
                      GestureDetector(
                        onTap: onTap,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppResponsive.widthValue(context, 12),
                            vertical: AppResponsive.heightValue(context, 6),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade500,
                            borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: 0.12,
                                ),
                                blurRadius: AppResponsive.radius(context, 6),
                                offset: Offset(0, AppResponsive.heightValue(context, 2)),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                'اكتشف الآن',
                                fontSize: AppResponsive.fontSize(context, 10.5),
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),

                              SizedBox(width: AppResponsive.widthValue(context, 5)),

                              Icon(
                                Icons.arrow_forward,
                                size: AppResponsive.fontSize(context, 13),
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
                left: -AppResponsive.widthValue(context, 30),
                bottom: -AppResponsive.heightValue(context, 35),
                child: IgnorePointer(
                  child: Container(
                    width: AppResponsive.widthValue(context, 110),
                    height: AppResponsive.widthValue(context, 110),
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