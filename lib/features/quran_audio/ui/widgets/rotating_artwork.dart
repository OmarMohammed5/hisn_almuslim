import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RotatingArtwork extends StatefulWidget {
  final bool isPlaying;
  final Widget child;
  final double size;

  const RotatingArtwork({
    super.key,
    required this.isPlaying,
    required this.child,
    this.size = 220,
  });

  @override
  State<RotatingArtwork> createState() => _RotatingArtworkState();
}

class _RotatingArtworkState extends State<RotatingArtwork>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // One full rotation every 18 seconds — slow & elegant, not a vinyl spin.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );
    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant RotatingArtwork oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        // AnimationController.repeat() continues from the controller's
        // current value, so rotation resumes from the exact angle it
        // stopped at rather than restarting from zero.
        _controller.repeat();
      } else {
        _controller.stop(canceled: false);
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
    final double size = widget.size.w;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: child,
        );
      },
      child: Container(
        width: 170.w,
        height: 170.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2ED9B8).withValues(alpha: 0.35),
              blurRadius: 40,
              spreadRadius: 4,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 2.5,
          ),
        ),
        padding: const EdgeInsets.all(6),
        child: ClipOval(child: widget.child),
      ),
    );
  }
}