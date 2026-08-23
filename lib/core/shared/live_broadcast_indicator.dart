import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/radio_colors.dart';


// ================================================================
// RADAR PULSE
// ================================================================

class RadarPulse extends StatefulWidget {
  const RadarPulse({
    super.key,
    required this.child,
    required this.active,
    required this.color,
    this.ringCount = 3,
    this.maxScale = 1.9,
    this.duration = const Duration(milliseconds: 2200),
  });

  final Widget child;
  final bool active;
  final Color color;
  final int ringCount;
  final double maxScale;
  final Duration duration;

  @override
  State<RadarPulse> createState() => _RadarPulseState();
}

class _RadarPulseState extends State<RadarPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.active) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant RadarPulse oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.active && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.active && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {



    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (widget.active)
              ...List.generate(
                widget.ringCount,
                    (i) {
                  final offset = i / widget.ringCount;
                  final t = (_controller.value + offset) % 1.0;

                  final scale =
                      1 + (widget.maxScale - 1) * t;

                  final opacity =
                  (1 - t).clamp(0.0, 1.0);

                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity * 0.40,
                      child: Container(
                        width: 62.w,
                        height: 62.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.color.withValues(
                              alpha: 0.45,
                            ),
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            child!,
          ],
        );
      },
      child: widget.child,
    );
  }
}

// ================================================================
// SOUND WAVE BARS
// ================================================================

class SoundWaveBars extends StatefulWidget {
  const SoundWaveBars({
    super.key,
    required this.active,
    required this.color,
    this.barCount = 4,
    this.height = 14,
    this.barWidth = 3,
  });

  final bool active;
  final Color color;
  final int barCount;
  final double height;
  final double barWidth;

  @override
  State<SoundWaveBars> createState() => _SoundWaveBarsState();
}

class _SoundWaveBarsState extends State<SoundWaveBars>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  static const List<int> _durationsMs = [
    420,
    560,
    480,
    640,
    500,
  ];

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      widget.barCount,
          (i) {
        final controller = AnimationController(
          vsync: this,
          duration: Duration(
            milliseconds:
            _durationsMs[i % _durationsMs.length],
          ),
        );

        if (widget.active) {
          controller.repeat(reverse: true);
        }

        return controller;
      },
    );
  }

  @override
  void didUpdateWidget(
      covariant SoundWaveBars oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    for (final controller in _controllers) {
      if (widget.active && !controller.isAnimating) {
        controller.repeat(reverse: true);
      } else if (!widget.active && controller.isAnimating) {
        controller.stop();
        controller.value = 0;
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return SizedBox(
      height: widget.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          widget.barCount,
              (i) {
            return AnimatedBuilder(
              animation: _controllers[i],
              builder: (context, _) {
                const minHeightFactor = 0.25;

                final value = widget.active
                    ? minHeightFactor +
                    (1 - minHeightFactor) *
                        _controllers[i].value
                    : minHeightFactor;

                return Container(
                  width: widget.barWidth,
                  height: widget.height * value,
                  margin: EdgeInsets.symmetric(
                    horizontal: widget.barWidth / 2,
                  ),
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(
                      widget.barWidth,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}