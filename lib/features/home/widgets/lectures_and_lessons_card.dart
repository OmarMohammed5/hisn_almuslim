import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/responsive/app_responsive.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/shared/custom_text.dart';
import '../../../core/theme/app_colors.dart';

class LecturesAndLessonsCard extends StatelessWidget {
  const LecturesAndLessonsCard({super.key});

  Future<void> _openLectures(BuildContext context) async {
    final preferences = await SharedPreferences.getInstance();
    if (!context.mounted) return;
    Navigator.pushNamed(context, AppRoutes.lectures, arguments: preferences);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scheme = theme.colorScheme;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.04);

    final titleColor = isDark ? Colors.white : const Color(0xFF17342E);
    final subtitleColor = isDark
        ? Colors.white.withValues(alpha: 0.60)
        : const Color(0xFF17342E).withValues(alpha: 0.55);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 16),
        vertical: AppResponsive.heightValue(context, 8),
      ),
      child: GestureDetector(
        onTap: () => _openLectures(context),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppResponsive.radius(context, 24)),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : AppColors.kPrimary.withValues(alpha: 0.06),
                blurRadius: AppResponsive.radius(context, 20),
                offset: Offset(0, AppResponsive.heightValue(context, 6)),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppResponsive.radius(context, 24)),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: AppResponsive.widthValue(context, 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.kPrimary,
                          AppColors.kPrimary.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(
                        AppResponsive.widthValue(context, 18),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTopRow(context, isDark, scheme),

                          Gap(AppResponsive.heightValue(context, 16)),

                          CustomText(
                            'محاضرات ودروس',
                            fontSize: AppResponsive.fontSize(context, 18),
                            fontWeight: FontWeight.w900,
                            color: titleColor,
                            height: 1.1,
                            maxLines: 1,
                          ),

                          Gap(AppResponsive.heightValue(context, 8)),

                          CustomText(
                            'استكشف محاضرات مختارة من قنوات YouTube الإسلامية',
                            fontSize: AppResponsive.fontSize(context, 10.5),
                            height: 1.5,
                            maxLines: 2,
                            color: subtitleColor,
                          ),

                          Gap(AppResponsive.heightValue(context, 16)),

                          Wrap(
                            spacing: AppResponsive.widthValue(context, 8),
                            runSpacing: AppResponsive.heightValue(context, 8),
                            children: [
                              _buildTag(context, '🎙️ بودكاست', isDark, scheme),
                              _buildTag(context, '📚 دروس', isDark, scheme),
                              _buildTag(context, '🎥 فيديوهات', isDark, scheme),
                            ],
                          ),

                          Gap(AppResponsive.heightValue(context, 20)),

                          // 5. Action Button
                          _buildActionButton(context, isDark),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildTopRow(BuildContext context, bool isDark, ColorScheme scheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Badge
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.widthValue(context, 10),
            vertical: AppResponsive.heightValue(context, 6),
          ),
          decoration: BoxDecoration(
            color: AppColors.kPrimary.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(AppResponsive.radius(context, 30)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFC9A85D), // Gold dot
                ),
              ),
              Gap(AppResponsive.widthValue(context, 6)),
              CustomText(
                'محتوى صوتي ومرئي',
                fontSize: AppResponsive.fontSize(context, 9),
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white70 : AppColors.kPrimary,
                maxLines: 1,
              ),
            ],
          ),
        ),

        // Headphones Icon Circle
        Container(
          width: AppResponsive.widthValue(context, 36),
          height: AppResponsive.widthValue(context, 36),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.kPrimary.withValues(alpha: isDark ? 0.15 : 0.08),
          ),
          child: Icon(
            Icons.headphones_rounded,
            size: AppResponsive.fontSize(context, 18),
            color: isDark ? Colors.white : AppColors.kPrimary,
          ),
        ),
      ],
    );
  }


  Widget _buildTag(BuildContext context, String text, bool isDark, ColorScheme scheme) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 10),
        vertical: AppResponsive.heightValue(context, 6),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : const Color(0xFF17342E).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : const Color(0xFF17342E).withValues(alpha: 0.06),
        ),
      ),
      child: CustomText(
        text,
        fontSize: AppResponsive.fontSize(context, 9),
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white70 : const Color(0xFF17342E).withValues(alpha: 0.7),
        maxLines: 1,
      ),
    );
  }



  Widget _buildActionButton(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 18),
        vertical: AppResponsive.heightValue(context, 11),
      ),
      decoration: BoxDecoration(
        color: AppColors.kPrimary,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimary.withValues(alpha: isDark ? 0.3 : 0.25),
            blurRadius: AppResponsive.radius(context, 12),
            offset: Offset(0, AppResponsive.heightValue(context, 4)),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            'استكشف الآن',
            fontSize: AppResponsive.fontSize(context, 10.5),
            fontWeight: FontWeight.w800,
            color: Colors.white,
            maxLines: 1,
          ),
          Gap(AppResponsive.widthValue(context, 8)),
          Icon(
            Icons.arrow_forward_rounded,
            size: AppResponsive.fontSize(context, 14),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}