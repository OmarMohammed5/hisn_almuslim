import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/responsive/app_responsive.dart';
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

        margin: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 4)),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 22)),

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
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 22)),

          child: Stack(
            children: [
              // ==================================================
              // Decorative Circle - Bottom Left
              // ==================================================
              Positioned(
                left: -AppResponsive.widthValue(context, 38),
                bottom: -AppResponsive.heightValue(context, 48),

                child: IgnorePointer(
                  child: Container(
                    width: AppResponsive.widthValue(context, 125),
                    height: AppResponsive.widthValue(context, 125),

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
                right: -AppResponsive.widthValue(context, 48),
                top: -AppResponsive.heightValue(context, 58),

                child: IgnorePointer(
                  child: Container(
                    width: AppResponsive.widthValue(context, 135),
                    height: AppResponsive.widthValue(context, 135),

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
                padding: EdgeInsets.fromLTRB(AppResponsive.widthValue(context, 12), AppResponsive.heightValue(context, 12), AppResponsive.widthValue(context, 12), AppResponsive.heightValue(context, 12)),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    // ============================================
                    // Header
                    // ============================================
                    _buildHeader(context, textColor: textColor, isDark: isDark),

                    SizedBox(height: AppResponsive.heightValue(context, 10)),

                    // ============================================
                    // Main Content
                    // ============================================
                    _buildContent(context, textColor: textColor),

                    SizedBox(height: AppResponsive.heightValue(context, 10)),

                    // ============================================
                    // Source
                    // ============================================
                    _buildSource(context, color: secondaryTextColor),
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

  Widget _buildHeader(BuildContext context, {required Color textColor, required bool isDark}) {
    return Row(
      children: [
        // Icon
        Container(
          width: AppResponsive.widthValue(context, 36),
          height: AppResponsive.widthValue(context, 36),

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: Colors.white.withValues(alpha: isDark ? .09 : .12),

            border: Border.all(
              color: Colors.white.withValues(alpha: isDark ? .12 : .18),
            ),
          ),

          child: Icon(_getIcon(), size: AppResponsive.fontSize(context, 18), color: textColor),
        ),

        SizedBox(width: AppResponsive.widthValue(context, 9)),

        // Title
        Expanded(
          child: CustomText(
            banner.title,

            maxLines: 1,

            textAlign: TextAlign.right,

            fontSize: AppResponsive.fontSize(context, 13.5),

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

  Widget _buildContent(BuildContext context, {required Color textColor}) {
    final content = banner.content?.trim() ?? '';

    if (content.isEmpty) {
      return SizedBox(height: AppResponsive.heightValue(context, 35));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 4)),

      child: LayoutBuilder(
        builder: (context, constraints) {
          final fontSize = _calculateFontSize(context, content, constraints.maxWidth);

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

  Widget _buildSource(BuildContext context, {required Color color}) {
    final source = banner.source?.trim() ?? '';

    if (source.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 6)),

      child: CustomText(
        source,

        maxLines: 2,
        textAlign: TextAlign.center,

        fontSize: AppResponsive.fontSize(context, 9.5),

        fontWeight: FontWeight.w500,

        height: 1.4,

        color: color,
      ),
    );
  }

  // ============================================================
  // Dynamic Font Size
  // ============================================================

  double _calculateFontSize(BuildContext context, String text, double availableWidth) {
    final length = text.characters.length;

    // Short content
    if (length <= 45) {
      return AppResponsive.fontSize(context, 16.5);
    }

    // Medium content
    if (length <= 80) {
      return AppResponsive.fontSize(context, 15.5);
    }

    // Long content
    if (length <= 120) {
      return AppResponsive.fontSize(context, 14.5);
    }

    // Very long content
    if (length <= 170) {
      return AppResponsive.fontSize(context, 13.5);
    }

    // Extremely long content
    return AppResponsive.fontSize(context, 12.8);
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
