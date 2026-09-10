import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 16),
      ),
      child: GestureDetector(
        onTap: () => _openLectures(context),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final compact = width < 360;

            // Min height only — content can grow if needed
            final minCardHeight = compact
                ? 176.0
                : width < 600
                ? 188.0
                : width < 1024
                ? 204.0
                : 220.0;

            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: AppResponsive.heightValue(context, minCardHeight),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  border: Border.all(color: borderColor, width: 1),
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kPrimary.withValues(
                        alpha: isDark ? .02 : .08,
                      ),
                      blurRadius: AppResponsive.radius(context, 2),
                      offset: Offset(0, AppResponsive.heightValue(context, 2)),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    AppResponsive.widthValue(context, compact ? 12 : 16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopRow(context, isDark),
                      Gap(AppResponsive.heightValue(context, compact ? 6 : 8)),
                      _buildMainContent(context, isDark, scheme),
                      Gap(AppResponsive.heightValue(context, compact ? 6 : 8)),
                      _buildActionButton(context, isDark),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopRow(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.widthValue(context, 12),
              vertical: AppResponsive.heightValue(context, 8),
            ),
            decoration: BoxDecoration(
              color: AppColors.kPrimary.withValues(alpha: isDark ? .15 : .08),
              borderRadius: BorderRadius.circular(
                AppResponsive.radius(context, 30),
              ),
              border: Border.all(
                color: AppColors.kPrimary.withValues(alpha: isDark ? .12 : .06),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle_rounded,
                  size: AppResponsive.fontSize(context, 6),
                  color: const Color(0xFFC9A85D),
                ),
                Gap(AppResponsive.widthValue(context, 6)),
                Flexible(
                  child: CustomText(
                    'محتوى صوتي ومرئي',
                    fontSize: AppResponsive.fontSize(context, 9),
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : AppColors.kPrimary,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        Gap(AppResponsive.widthValue(context, 8)),
        Container(
          width: AppResponsive.widthValue(context, 32),
          height: AppResponsive.widthValue(context, 32),
          decoration: BoxDecoration(
            color: AppColors.kPrimary.withValues(alpha: isDark ? .12 : .06),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.kPrimary.withValues(alpha: isDark ? .15 : .08),
            ),
          ),
          child: Icon(
            Icons.headphones_rounded,
            size: AppResponsive.fontSize(context, 16),
            color: AppColors.kPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(
      BuildContext context,
      bool isDark,
      ColorScheme scheme,
      ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text side — Flexible, not Expanded
            Flexible(
              flex: compact ? 3 : 7,
              child: _buildTextContent(context, isDark, compact: compact),
            ),
            Gap(AppResponsive.widthValue(context, compact ? 8 : 12)),

          ],
        );
      },
    );
  }

  Widget _buildTextContent(
      BuildContext context,
      bool isDark, {
        bool compact = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          'محاضرات ودروس',
          fontSize: AppResponsive.fontSize(context, compact ? 14 : 14.6),
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : const Color(0xFF17342E),
          height: 1.1,
          maxLines: 1,
        ),
        Gap(AppResponsive.heightValue(context, compact ? 5 : 8)),
        CustomText(
          'استكشف محاضرات مختارة من قنوات YouTube الإسلامية',
          fontSize: AppResponsive.fontSize(context, compact ? 9 : 9.5),
          height: 1.4,
          maxLines: 2,
          color: isDark
              ? Colors.white70
              : const Color(0xFF17342E).withValues(alpha: .54),
        ),
        Gap(AppResponsive.heightValue(context, compact ? 7 : 11)),
        // Tags — allow horizontal scroll if too wide, but single row
        SizedBox(
          height: AppResponsive.heightValue(context, compact ? 20 : 24),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) =>
                Gap(AppResponsive.widthValue(context, 4)),
            itemBuilder: (context, i) {
              final tags = ['🎙️ بودكاست', '📚 دروس', '🎥 فيديوهات'];
              return _buildTag(context, tags[i], isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTag(BuildContext context, String text, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 6),
        vertical: AppResponsive.heightValue(context, 3),
      ),
      decoration: BoxDecoration(
        color: AppColors.kPrimary.withValues(alpha: isDark ? .12 : .06),
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, 10),
        ),
        border: Border.all(
          color: AppColors.kPrimary.withValues(alpha: isDark ? .08 : .04),
        ),
      ),
      child: Center(
        child: CustomText(
          text,
          fontSize: AppResponsive.fontSize(context, 7),
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white70 : AppColors.kPrimary,
          maxLines: 1,
        ),
      ),
    );
  }


  Widget _buildActionButton(BuildContext context, bool isDark) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.widthValue(context, 14),
          vertical: AppResponsive.heightValue(context, 8),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.kPrimary, AppColors.kPrimaryMedium],
          ),
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 30)),
          boxShadow: [
            BoxShadow(
              color: AppColors.kPrimary.withValues(alpha: .25),
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
              fontSize: AppResponsive.fontSize(context, 9),
              fontWeight: FontWeight.w700,
              color: Colors.white,
              maxLines: 1,
            ),
            Gap(AppResponsive.widthValue(context, 6)),
            Icon(
              Icons.arrow_forward_rounded,
              size: AppResponsive.fontSize(context, 13),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}