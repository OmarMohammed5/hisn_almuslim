import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/responsive/app_responsive.dart';
import '../../../../core/theme/app_colors.dart';

class AudioWaveAnimation extends StatefulWidget {
  final bool isPlaying;
  final Color? color;
  final double size;

  const AudioWaveAnimation({
    super.key,
    required this.isPlaying,
    this.color,
    this.size = 20,
  });

  @override
  State<AudioWaveAnimation> createState() => _AudioWaveAnimationState();
}

class _AudioWaveAnimationState extends State<AudioWaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animations = List.generate(5, (index) {
      final delay = index * 0.12;
      return Tween<double>(
        begin: 0.2,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            delay,
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AudioWaveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.kPrimary;

    return SizedBox(
      width: AppResponsive.widthValue(context, widget.size),
      height: AppResponsive.widthValue(context, widget.size),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(5, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double height = 0.3;
                if (widget.isPlaying) {
                  final phase = (index / 5) * 2 * pi;
                  final time = _controller.value * 2 * pi;
                  final sinValue = sin(time + phase);
                  height = 0.35 + 0.65 * (0.5 + 0.5 * sinValue);
                }
                final width = AppResponsive.widthValue(context, index == 2 ? 4 : 3);
                final opacity = 0.3 + (height * 0.5);

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 1.5)),
                  width: width,
                  height: AppResponsive.heightValue(context, widget.size * 0.25 + height * widget.size * 0.55),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        color.withValues(alpha: 0.3 + height * 0.3),
                        color.withValues(alpha: opacity),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}