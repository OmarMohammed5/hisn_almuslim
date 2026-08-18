import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    Color getCardColor() {
      if (isActive) return AppColors.kPrimary.withValues(alpha: 0.12);
      if (isPausedState) return Colors.orange.withValues(alpha: 0.10);
      if (isCompletedState) return Colors.grey.withValues(alpha: 0.08);
      return isDark ? const Color(0xff1a1f24) : const Color(0xffFAFBFC);
    }

    Color getBorderColor() {
      if (isActive) return AppColors.kPrimary.withValues(alpha: 0.6);
      if (isPausedState) return Colors.orange.withValues(alpha: 0.4);
      if (isCompletedState) return Colors.grey.withValues(alpha: 0.3);
      return isDark ? const Color(0xff2d3338) : const Color(0xffE5E7EC);
    }

    double getBorderWidth() {
      if (isActive || isPausedState) return 1.8.w;
      return 1.2.w;
    }

    Color getTextColor() {
      if (isActive) return AppColors.kPrimary;
      if (isPausedState) return Colors.orange;
      if (isCompletedState) return Colors.grey;
      return isDark ? Colors.white : const Color(0xff1a1f24);
    }

    String getStatusText() {
      if (isActive) return 'يُتلى الآن';
      if (isPausedState) return 'متوقف مؤقتاً';
      if (isCompletedState) return 'انتهى';
      return '';
    }

    Color getBadgeColor() {
      if (isActive) return AppColors.kPrimary;
      if (isPausedState) return Colors.orange;
      if (isCompletedState) return Colors.grey;
      return Colors.transparent;
    }

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: getBorderColor(),
            width: getBorderWidth(),
          ),
          boxShadow: isActive || isPausedState
              ? [
            BoxShadow(
              color: getBadgeColor().withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: Row(
            children: [
              _buildSurahNumber(
                isActive: isActive,
                isPaused: isPausedState,
                isCompleted: isCompletedState,
                isDark: isDark,
              ),
              Gap(14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "سورة ${surah.nameArabic}",
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Al mushaf',
                            color: getTextColor(),
                            height: 1.2,
                          ),
                        ),
                        if (isCurrentSurah) ...[
                          SizedBox(width: 8.w),
                          _buildStatusBadge(
                            isActive: isActive,
                            isPaused: isPausedState,
                            isCompleted: isCompletedState,
                          ),
                        ],
                      ],
                    ),
                    Gap(4.h),
                    Text(
                      surah.nameEnglish,
                      style: TextStyle(
                        fontSize: 10.sp,
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
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12.r),
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
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.6)
                          : Colors.black.withValues(alpha: 0.5),
                    ),
                    SizedBox(width: 3.w),
                    Icon(
                      Icons.menu_book_rounded,
                      size: 12.sp,
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
  }

/// Cases
  Widget _buildStatusBadge({
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
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 12.sp,
              color: color,
            ),
          if (isActive)
            Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          SizedBox(width: 4.w),
          CustomText(
            text,
            fontSize: 8.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildSurahNumber({
    required bool isActive,
    required bool isPaused,
    required bool isCompleted,
    required bool isDark,
  }) {
    final bool showWave = isActive || isPaused;
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
          width: 42.w,
          height: 42.h,
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
              width: 1.5.w,
            )
                : null,
          ),
          child: Center(
            child: Text(
              '${surah.number}',
              style: TextStyle(
                fontSize: 13.sp,
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
              size: 50.w,
            ),
          ),
        if (isPaused)
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: AudioWaveAnimation(
                isPlaying: false,
                color: Colors.orange,
                size: 50.w,
              ),
            ),
          ),
        if (isActive)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 2000),
            builder: (context, value, child) {
              return Container(
                width: 42.w + (value * 20),
                height: 42.w + (value * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.kPrimary.withValues(alpha: 0.15 * (1 - value)),
                    width: 1.2.w,
                  ),
                ),
              );
            },
          ),
        if (isPaused)
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.orange.withValues(alpha: 0.15),
                width: 1.w,
              ),
            ),
          ),
      ],
    );
  }
}