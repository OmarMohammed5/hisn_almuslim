import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/features/home/widgets/radio_icon_widget.dart';
import 'package:hisn_almuslim/features/home/widgets/radio_play_button.dart';
import '../../../core/shared/live_broadcast_indicator.dart';
import '../../../core/theme/radio_colors.dart';
import '../../radio/presentation/cubit/radio_cubit.dart';
import '../../radio/presentation/cubit/radio_state.dart';
import 'live_dot.dart';

class CairoRadioCard extends StatefulWidget {
  const CairoRadioCard({super.key});

  @override
  State<CairoRadioCard> createState() => _CairoRadioCardState();
}

class _CairoRadioCardState extends State<CairoRadioCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _iconBreathController;
  late final Animation<double> _iconBreathAnimation;

  @override
  void initState() {
    super.initState();

    _iconBreathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _iconBreathAnimation = Tween<double>(
      begin: 0.96,
      end: 1.06,
    ).animate(
      CurvedAnimation(
        parent: _iconBreathController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _iconBreathController.dispose();
    super.dispose();
  }

  void _updateAnimation(RadioState state) {
    if (state is RadioPlaying) {
      if (!_iconBreathController.isAnimating) {
        _iconBreathController.repeat(reverse: true);
      }

      return;
    }

    if (_iconBreathController.isAnimating) {
      _iconBreathController.stop();
    }

    _iconBreathController.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final radioPrimary = isDark
        ? RadioColors.darkPrimary
        : RadioColors.lightPrimary;

    final radioDark = isDark
        ? RadioColors.darkTealDark
        : RadioColors.lightTealDark;

    final radioMedium = isDark
        ? RadioColors.darkTealMedium
        : RadioColors.lightTealMedium;


    return BlocConsumer<RadioCubit, RadioState>(
      listener: (context, state) {
        _updateAnimation(state);

        if (state is RadioError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isPlaying = state is RadioPlaying;
        final isPaused = state is RadioPaused;
        final isLoading = state is RadioLoading;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 18.w),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            padding: EdgeInsets.all(22.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  radioPrimary.withValues(
                    alpha: isDark ? 0.25 : 0.12,
                  ),
                  radioDark.withValues(
                    alpha: isDark ? 0.12 : 0.05,
                  ),
                ],
              ),
              border: Border.all(
                color: radioMedium.withValues(
                  alpha: isDark ? 0.55 : 0.30,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: radioPrimary.withValues(
                    alpha: isDark ? 0.18 : 0.08,
                  ),
                  blurRadius: 20.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),

            child: Row(
              children: [
                // Radio Icon
                RadioIconWidget(
                  isPlaying: isPlaying,
                  iconBreathAnimation: _iconBreathAnimation,
                ),

                SizedBox(width: 14.w),

                // Radio Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isPlaying) ...[
                            // Live indicator
                            LiveDot(
                              color: radioMedium,
                            ),

                            SizedBox(width: 6.w),

                            CustomText(
                              'مباشر الآن',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: radioMedium,
                            ),

                            SizedBox(width: 10.w),

                            // Sound waves
                            SoundWaveBars(
                              active: true,
                              color: radioMedium,
                              height: 12,
                              barWidth: 2.4,
                            ),
                          ] else
                            ...[
                              Container(
                                width: 7.w,
                                height: 7.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: radioMedium,
                                ),
                              ),

                              SizedBox(width: 6.w),

                              CustomText(
                                'متوقف',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.65,
                                ),
                              ),
                            ],
                        ],
                      ),

                      SizedBox(height: 10.h),

                      // Main title
                      CustomText(
                        'إذاعة القرآن الكريم',
                        maxLines: 1,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                      ),

                      SizedBox(height: 5.h),

                      // Location
                      CustomText(
                        'من القاهرة',
                          fontSize: 13.sp,
                          color: colorScheme.onSurface.withValues(
                            alpha: 0.60,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10.w),

                // Play / Pause Button
                RadioPlayButton(
                  isPlaying: isPlaying,
                  isPaused: isPaused,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}