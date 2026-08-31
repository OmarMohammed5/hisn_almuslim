import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/shared/live_broadcast_indicator.dart';
import '../../../core/theme/radio_colors.dart';

class RadioIconWidget extends StatelessWidget {
  final bool isPlaying;
  final Animation<double> iconBreathAnimation;

  const RadioIconWidget({super.key, required this.isPlaying, required this.iconBreathAnimation});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    final radioPrimary = isDark
        ? RadioColors.darkPrimary
        : RadioColors.lightPrimary;

    final radioMedium = isDark
        ? RadioColors.darkTealMedium
        : RadioColors.lightTealMedium;

    final radioLight = isDark
        ? RadioColors.darkTealLight
        : RadioColors.lightTealLight;

    final radioSoft = isDark
        ? RadioColors.darkTealSoft
        : RadioColors.lightTealSoft;


    final tealMedium = isDark
        ? const Color(0xFF4BC2B6)
        : RadioColors.lightTealMedium;

    final tealSoft = isDark
        ? const Color(0xFF173632)
        : RadioColors.lightTealSoft;


    return RadarPulse(
      active: isPlaying,
      color: radioLight,
      ringCount: 2,
      maxScale: 1.7,
      child: AnimatedBuilder(
        animation: iconBreathAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isPlaying
                ? iconBreathAnimation.value
                : 1,
            child: child,
          );
        },

        child: Container(
          width: 62.w,
          height: 62.w,

          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPlaying
                ? radioSoft.withValues(
              alpha: isDark ? 0.85 : 0.9,
            )
                : radioSoft.withValues(
              alpha: isDark ? 0.60 : 0.70,
            ),
            border: Border.all(
              color: isPlaying
                  ? radioMedium.withValues(
                alpha: isDark ? 0.70 : 0.45,
              )
                  : radioMedium.withValues(
                alpha: isDark ? 0.40 : 0.25,
              ),
              width: 1,
            ),
          ),

          child: Stack(
            alignment: Alignment.center,
            children: [
              // Inner Animated Ring
              if (isPlaying)
                Container(
                  width: 62.w,
                  height: 62.w,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: tealSoft.withValues(alpha: isDark ? 0.45 : 0.85),
                    border: Border.all(
                      color: tealMedium.withValues(alpha: isDark ? 0.20 : 0.25),
                    ),

                  ),
                ),

              // Radio Icon
              Icon(
                Icons.radio_rounded,
                size: 30.sp,
                color: radioPrimary,
              ),
            ],
          ),
        ),
      ),
    );

  }
}
