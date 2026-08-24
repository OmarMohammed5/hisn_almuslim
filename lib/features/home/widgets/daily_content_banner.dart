import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/shared/custom_text.dart';
import '../data/models/featured_banner_model.dart';

class DailyContentBanner extends StatelessWidget {
  final FeaturedBannerModel banner;
  final VoidCallback? onTap;

  const DailyContentBanner({super.key, required this.banner, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final primary = colorScheme.primary;

    // Teal Palette
    final backgroundStart = isDark
        ? const Color(0xFF174C47)
        : const Color(0xFF0F9D8D);

    final backgroundEnd = isDark
        ? const Color(0xFF0B302C)
        : const Color(0xFF08796D);

    final textColor = Colors.white;

    final secondaryTextColor = Colors.white.withValues(
      alpha: isDark ? .70 : .80,
    );

    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,

        margin: EdgeInsets.symmetric(horizontal: 4.w),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),

          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [backgroundStart, backgroundEnd],
          ),

          border: Border.all(
            color: primary.withValues(alpha: isDark ? .28 : .18),
          ),

        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.r),

          child: Stack(
            children: [
              // ==================================================
              // Decorative Circle - Bottom Left
              // ==================================================
              Positioned(
                left: -38.w,
                bottom: -48.h,

                child: IgnorePointer(
                  child: Container(
                    width: 125.w,
                    height: 125.w,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: Colors.white.withValues(
                        alpha: isDark ? .035 : .055,
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // Decorative Circle - Top Right
              // ==================================================
              Positioned(
                right: -48.w,
                top: -58.h,

                child: IgnorePointer(
                  child: Container(
                    width: 135.w,
                    height: 135.w,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: Colors.white.withValues(
                        alpha: isDark ? .025 : .04,
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // Main Content
              // ==================================================
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    // ============================================
                    // Header
                    // ============================================
                    _buildHeader(textColor: textColor, isDark: isDark),

                    SizedBox(height: 10.h),

                    // ============================================
                    // Main Content
                    // ============================================
                    _buildContent(textColor: textColor),

                    SizedBox(height: 10.h),

                    // ============================================
                    // Source
                    // ============================================
                    _buildSource(color: secondaryTextColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Header
  // ============================================================

  Widget _buildHeader({required Color textColor, required bool isDark}) {
    return Row(
      children: [
        // Icon
        Container(
          width: 36.w,
          height: 36.w,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: Colors.white.withValues(alpha: isDark ? .09 : .12),

            border: Border.all(
              color: Colors.white.withValues(alpha: isDark ? .12 : .18),
            ),
          ),

          child: Icon(_getIcon(), size: 18.sp, color: textColor),
        ),

        SizedBox(width: 9.w),

        // Title
        Expanded(
          child: CustomText(
            banner.title,

            maxLines: 1,

            textAlign: TextAlign.right,

            fontSize: 13.5.sp,

            fontWeight: FontWeight.w700,

            color: textColor,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Main Content
  // ============================================================

  Widget _buildContent({required Color textColor}) {
    final content = banner.content?.trim() ?? '';

    if (content.isEmpty) {
      return SizedBox(height: 35.h);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),

      child: LayoutBuilder(
        builder: (context, constraints) {
          final fontSize = _calculateFontSize(content, constraints.maxWidth);

          return CustomText(
            content,

            // More room for Quran / Hadith /
            // Dua / Dhikr.
            maxLines: _calculateMaxLines(content).toDouble(),

            textAlign: TextAlign.center,

            fontSize: fontSize,

            fontWeight: FontWeight.w700,

            height: _calculateLineHeight(content),

            color: textColor,
          );
        },
      ),
    );
  }

  // ============================================================
  // Source
  // ============================================================

  Widget _buildSource({required Color color}) {
    final source = banner.source?.trim() ?? '';

    if (source.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),

      child: CustomText(
        source,

        maxLines: 2,
        textAlign: TextAlign.center,

        fontSize: 9.5.sp,

        fontWeight: FontWeight.w500,

        height: 1.4,

        color: color,
      ),
    );
  }

  // ============================================================
  // Dynamic Font Size
  // ============================================================

  double _calculateFontSize(String text, double availableWidth) {
    final length = text.characters.length;

    // Short content
    if (length <= 45) {
      return 16.5.sp;
    }

    // Medium content
    if (length <= 80) {
      return 15.5.sp;
    }

    // Long content
    if (length <= 120) {
      return 14.5.sp;
    }

    // Very long content
    if (length <= 170) {
      return 13.5.sp;
    }

    // Extremely long content
    return 12.8.sp;
  }

  // ============================================================
  // Dynamic Max Lines
  // ============================================================

  int _calculateMaxLines(String text) {
    final length = text.characters.length;

    if (length <= 55) {
      return 3;
    }

    if (length <= 100) {
      return 4;
    }

    if (length <= 160) {
      return 5;
    }

    return 6;
  }

  // ============================================================
  // Dynamic Line Height
  // ============================================================

  double _calculateLineHeight(String text) {
    final length = text.characters.length;

    if (length <= 60) {
      return 1.7;
    }

    if (length <= 120) {
      return 1.65;
    }

    return 1.6;
  }

  // ============================================================
  // Icon According To Content Type
  // ============================================================

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
