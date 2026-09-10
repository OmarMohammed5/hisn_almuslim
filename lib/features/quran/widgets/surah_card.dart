import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/shared/custom_text.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/entities/surah_entity.dart';

class SurahCard extends StatelessWidget {
  final SurahEntity surah;
  final VoidCallback onTap;
  final double progress;

  const SurahCard({
    super.key,
    required this.surah,
    required this.onTap,
    this.progress = 0.0,
  });


  static const Color _lightText = Color(0xFF292C29);

  static const Color _darkText = Color(0xFFE8E0CC);

  static const Color _lightTeal = Color(0xFF16877D);

  static const Color _darkTeal = Color(0xFF66C7BB);

  static const Color _lightGold = Color(0xFFB59A5A);

  static const Color _darkGold = Color(0xFFCDB878);


  static const Color _darkCard = Color(0xFF202724);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isMeccan = surah.isMeccan;

    final accentColor = isDark ? _darkTeal : _lightTeal;

    final goldColor = isDark ? _darkGold : _lightGold;

    final textColor = isDark ? _darkText : _lightText;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: EdgeInsets.only(bottom: AppResponsive.heightValue(context, 9)),

        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 18)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.045),

              blurRadius: AppResponsive.radius(context, 14),

              offset: Offset(0, AppResponsive.heightValue(context, 5)),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 18)),

          child: Stack(
            children: [
              // Subtle Accent Line
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,

                child: Container(
                  width: AppResponsive.widthValue(context, 3),

                  decoration: BoxDecoration(
                    color: isMeccan ? accentColor : goldColor,
                  ),
                ),
              ),

              // Main Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 14), vertical: AppResponsive.heightValue(context, 12)),

                child: Row(
                  children: [
                    // Surah Number
                    _buildSurahNumber(
                      context: context,
                      isDark: isDark,
                      accentColor: accentColor,
                      goldColor: goldColor,
                    ),

                    SizedBox(width: AppResponsive.widthValue(context, 13)),

                    // Surah Information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // Surah Name
                          CustomText(
                            surah.displayName,
                            fontSize: AppResponsive.fontSize(context, 13),
                            fontFamily: 'Noon',
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            height: 1.35,
                          ),

                          SizedBox(height: AppResponsive.heightValue(context, 7)),

                          // Metadata
                          Row(
                            spacing: AppResponsive.widthValue(context, 10),
                            children: [
                              Image.asset(
                                isMeccan
                                    ? "assets/icons/Makka.png"
                                    : "assets/icons/Madina.png",
                                fit: BoxFit.cover,
                                height: AppResponsive.heightValue(context, 20),
                                width: AppResponsive.widthValue(context, 20),
                              ),
                              _buildInfoChip(
                                context: context,
                                label: '${surah.totalAyahs} آية',
                                color: textColor.withValues(alpha: 0.65),
                                isDark: isDark,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: AppResponsive.widthValue(context, 10)),

                    // Arrow
                    _buildArrow(context: context, accentColor: accentColor, isDark: isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Surah Number
  Widget _buildSurahNumber({
    required BuildContext context,
    required bool isDark,
    required Color accentColor,
    required Color goldColor,
  }) {
    final color = surah.isMeccan ? accentColor : goldColor;

    return SizedBox(
      width: AppResponsive.widthValue(context, 46),
      height: AppResponsive.widthValue(context, 46),

      child: Stack(
        alignment: Alignment.center,

        children: [
          // Outer Diamond
          Transform.rotate(
            angle: 0.785398,

            child: Container(
              width: AppResponsive.widthValue(context, 31),
              height: AppResponsive.widthValue(context, 31),

              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.10 : 0.075),

                border: Border.all(
                  color: color.withValues(alpha: isDark ? 0.45 : 0.35),

                  width: 1.1,
                ),

                borderRadius: BorderRadius.circular(AppResponsive.radius(context, 6)),
              ),
            ),
          ),

          // Number
          CustomText(
            '${surah.number}',
            fontSize: surah.number > 99 ? AppResponsive.fontSize(context, 10) : AppResponsive.fontSize(context, 12),
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ],
      ),
    );
  }

  // Info Chip
  Widget _buildInfoChip({
    required BuildContext context,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 7), vertical: AppResponsive.heightValue(context, 3.5)),

      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.08 : 0.055),

        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 7)),

        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.13 : 0.10),

          width: 0.6,
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            label,
            fontSize: AppResponsive.fontSize(context, 9.5),

            fontWeight: FontWeight.w500,

            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildArrow({required BuildContext context, required Color accentColor, required bool isDark}) {
    return Container(
      width: AppResponsive.widthValue(context, 31),
      height: AppResponsive.widthValue(context, 31),

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        color: accentColor.withValues(alpha: isDark ? 0.07 : 0.055),
      ),

      child: Icon(
        Icons.arrow_forward_ios_rounded,

        size: AppResponsive.fontSize(context, 12),

        color: accentColor.withValues(alpha: 0.75),
      ),
    );
  }
}
