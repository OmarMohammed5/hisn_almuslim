import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TasbeehTapAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? accentColor;

  const TasbeehTapAnimation({
    super.key,
    required this.child,
    required this.onTap,
    this.accentColor,
  });

  @override
  State<TasbeehTapAnimation> createState() => _TasbeehTapAnimationState();
}

class _TasbeehTapAnimationState extends State<TasbeehTapAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadePlusOne;
  late final Animation<Offset> _slidePlusOne;

  bool _showPlusOne = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: .965),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: .965, end: 1.0),
        weight: 65,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadePlusOne = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0),
        weight: 18,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0),
        weight: 82,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _slidePlusOne = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _showPlusOne = false);
      }
    });
  }

  void _handleTap() {
    // Do not lock the user for the duration of the animation.
    // Every tap is immediately forwarded to the counter.
    setState(() => _showPlusOne = true);
    _controller.forward(from: 0);
    widget.onTap();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = widget.accentColor ??
        (isDark ? Colors.tealAccent.shade200 : Colors.teal.shade700);

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: widget.child,
          ),
          if (_showPlusOne)
            Positioned(
              top: -7.h,
              right: 18.w,
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadePlusOne.value,
                      child: Transform.translate(
                        offset: _slidePlusOne.value * 34.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: .10),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: accentColor.withValues(alpha: .18),
                            ),
                          ),
                          child: Text(
                            '+١',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                              color: accentColor,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
