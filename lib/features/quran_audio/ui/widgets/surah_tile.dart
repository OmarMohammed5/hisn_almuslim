import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/responsive/app_responsive.dart';
import 'package:gap/gap.dart';
import '../../../../core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/surah_audio_model.dart';
import 'audio_wave_animation.dart';

class SurahTile extends StatelessWidget {
  final SurahAudioModel surah;
  final int index;
  final bool isCurrentSurah;
  final bool isPlaying;
  final bool isPaused;
  final bool isCompleted;
  final VoidCallback onPressed;

  const SurahTile({
    super.key,
    required this.surah,
    required this.index,
    required this.onPressed,
    this.isCurrentSurah = false,
    this.isPlaying = false,
    this.isPaused = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isActive = isCurrentSurah && isPlaying;
    final isPausedState = isCurrentSurah && isPaused && !isPlaying;
    final isCompletedState = isCurrentSurah && isCompleted;

    Color getTextColor() {
      if (isActive) return AppColors.kPrimary;
      if (isPausedState) return Colors.orange;
      if (isCompletedState) return Colors.grey;
      return isDark ? Colors.white : const Color(0xff1a1f24);
    }

    Color getBadgeColor() {
      if (isActive) return AppColors.kPrimary;
      if (isPausedState) return Colors.orange;
      if (isCompletedState) return Colors.grey;
      return Colors.transparent;
    }

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;
        final wide = constraints.maxWidth >= 480;

        return GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(vertical: 6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: bgColor,
              border: Border.all(color: borderColor, width: 1),
              boxShadow: isActive || isPausedState
                  ? [
                      BoxShadow(
                        color: getBadgeColor().withValues(alpha: 0.12),
                        blurRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.widthValue(
                  context,
                  compact ? 10 : 14,
                ),
                vertical: AppResponsive.heightValue(
                  context,
                  compact ? 8 : (wide ? 8 : 10),
                ),
              ),
              child: Row(
                children: [
                  _buildSurahNumber(
                    context: context,
                    isActive: isActive,
                    isPaused: isPausedState,
                    isCompleted: isCompletedState,
                    isDark: isDark,
                  ),
                  Gap(AppResponsive.widthValue(context, compact ? 9 : 14)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                "سورة ${surah.nameArabic}",
                                style: TextStyle(
                                  fontSize: AppResponsive.fontSize(
                                    context,
                                    compact ? 15 : (wide ? 16 : 17),
                                  ),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Noon',
                                  color: getTextColor(),
                                  height: 1.2,
                                ),
                              ),
                            ),
                            if (isCurrentSurah) ...[
                              SizedBox(
                                width: AppResponsive.widthValue(context, 8),
                              ),
                              _buildStatusBadge(
                                context: context,
                                isActive: isActive,
                                isPaused: isPausedState,
                                isCompleted: isCompletedState,
                              ),
                            ],
                          ],
                        ),
                        Gap(AppResponsive.heightValue(context, 4)),
                        Text(
                          surah.nameEnglish,
                          style: TextStyle(
                            fontSize: AppResponsive.fontSize(
                              context,
                              compact ? 9 : 10,
                            ),
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.4)
                                : Colors.black.withValues(alpha: 0.3),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.widthValue(context, 10),
                      vertical: AppResponsive.heightValue(context, 4),
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(
                        AppResponsive.radius(context, 12),
                      ),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          "${surah.versesCount}",
                          fontSize: AppResponsive.fontSize(context, 9),
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.6)
                              : Colors.black.withValues(alpha: 0.5),
                        ),
                        SizedBox(width: AppResponsive.widthValue(context, 3)),
                        Icon(
                          Icons.menu_book_rounded,
                          size: AppResponsive.iconSize(context, 12),
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.4)
                              : Colors.black.withValues(alpha: 0.35),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Cases
  Widget _buildStatusBadge({
    required BuildContext context,
    required bool isActive,
    required bool isPaused,
    required bool isCompleted,
  }) {
    String text;
    Color color;
    IconData? icon;

    if (isActive) {
      text = 'يُتلى الآن';
      color = AppColors.kPrimary;
      icon = null;
    } else if (isPaused) {
      text = 'متوقف مؤقتاً';
      color = Colors.orange;
      icon = Icons.pause_circle_outline_rounded;
    } else if (isCompleted) {
      text = 'انتهى';
      color = Colors.grey;
      icon = Icons.check_circle_outline_rounded;
    } else {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, size: AppResponsive.iconSize(context, 12), color: color),
          if (isActive)
            Container(
              width: AppResponsive.widthValue(context, 5),
              height: AppResponsive.heightValue(context, 5),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          SizedBox(width: AppResponsive.widthValue(context, 4)),
          CustomText(
            text,
            fontSize: AppResponsive.fontSize(context, 8),
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildSurahNumber({
    required BuildContext context,
    required bool isActive,
    required bool isPaused,
    required bool isCompleted,
    required bool isDark,
  }) {
    final Color circleColor = isActive
        ? AppColors.kPrimary
        : isPaused
        ? Colors.orange
        : isCompleted
        ? Colors.grey
        : (isDark ? const Color(0xff2d3338) : const Color(0xffE9EEF0));

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: AppResponsive.widthValue(context, 42),
          height: AppResponsive.heightValue(context, 42),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: (isActive || isPaused)
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      circleColor.withValues(alpha: 0.25),
                      circleColor.withValues(alpha: 0.1),
                    ],
                  )
                : null,
            color: (isActive || isPaused)
                ? null
                : isCompleted
                ? Colors.grey.withValues(alpha: 0.15)
                : (isDark ? const Color(0xff2d3338) : const Color(0xffE9EEF0)),
            border: (isActive || isPaused)
                ? Border.all(
                    color: circleColor.withValues(alpha: 0.5),
                    width: AppResponsive.widthValue(context, 1.5),
                  )
                : null,
          ),
          child: Center(
            child: Text(
              '${surah.number}',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 13),
                fontWeight: FontWeight.w700,
                fontFamily: 'Al mushaf',
                color: (isActive || isPaused) ? circleColor : null,
              ),
            ),
          ),
        ),
        if (isActive)
          Positioned.fill(
            child: AudioWaveAnimation(
              isPlaying: true,
              color: AppColors.kPrimary,
              size: AppResponsive.iconSize(context, 50),
            ),
          ),
        if (isPaused)
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: AudioWaveAnimation(
                isPlaying: false,
                color: Colors.orange,
                size: AppResponsive.iconSize(context, 50),
              ),
            ),
          ),
        if (isActive)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 2000),
            builder: (context, value, child) {
              return Container(
                width: AppResponsive.widthValue(context, 42) + (value * 20),
                height: AppResponsive.heightValue(context, 42) + (value * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.kPrimary.withValues(
                      alpha: 0.15 * (1 - value),
                    ),
                    width: AppResponsive.widthValue(context, 1.2),
                  ),
                ),
              );
            },
          ),
        if (isPaused)
          Container(
            width: AppResponsive.widthValue(context, 50),
            height: AppResponsive.heightValue(context, 50),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.orange.withValues(alpha: 0.15),
                width: AppResponsive.widthValue(context, 1),
              ),
            ),
          ),
      ],
    );
  }
}
