import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/features/home/widgets/radio_icon_widget.dart';
import 'package:hisn_almuslim/features/home/widgets/radio_play_button.dart';
import '../../../core/shared/live_broadcast_indicator.dart';
import '../../../core/theme/app_colors.dart';
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

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;


    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    final radioMedium = isDark
        ? const Color(0xFF4BC2B6)
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
          margin: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 18)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            padding: EdgeInsets.all(AppResponsive.widthValue(context, 22)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppResponsive.radius(context, 22)),
              color: bgColor,
              border: Border.all(color: borderColor, width: 1),
              boxShadow:
              isDark
                  ? const []
                  : [
                BoxShadow(
                  color: AppColors.kPrimary.withValues(alpha: 0.05),
                  blurRadius: AppResponsive.radius(context, 6),
                  offset: Offset(0, AppResponsive.heightValue(context, 3)),
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

                SizedBox(width: AppResponsive.widthValue(context, 14)),

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
                              color: Colors.red.shade800,
                            ),

                            SizedBox(width: AppResponsive.widthValue(context, 6)),

                            CustomText(
                              'مباشر الآن',
                                fontSize: AppResponsive.fontSize(context, 11),
                                fontWeight: FontWeight.w700,
                                color: Colors.red.shade800,
                            ),

                            SizedBox(width: AppResponsive.widthValue(context, 10)),

                            // Sound waves
                            SoundWaveBars(
                              active: true,
                              color: Colors.red.shade800,
                              height: 12,
                              barWidth: 2.4,
                            ),
                          ] else
                            ...[
                              Container(
                                width: AppResponsive.widthValue(context, 7),
                                height: AppResponsive.widthValue(context, 7),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: radioMedium,
                                ),
                              ),

                              SizedBox(width: AppResponsive.widthValue(context, 6)),

                              CustomText(
                                'متوقف',
                                  fontSize: AppResponsive.fontSize(context, 11),
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.65,
                                ),
                              ),
                            ],
                        ],
                      ),

                      SizedBox(height: AppResponsive.heightValue(context, 12)),

                      // Main title
                      CustomText(
                        'إذاعة القرآن الكريم',
                        maxLines: 1,
                          fontSize: AppResponsive.fontSize(context, 13),
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                      ),

                      SizedBox(height: AppResponsive.heightValue(context, 7)),

                      // Location
                      CustomText(
                        'من القاهرة',
                          fontSize: AppResponsive.fontSize(context, 12),
                          color: colorScheme.onSurface.withValues(
                            alpha: 0.60,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: AppResponsive.widthValue(context, 10)),

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