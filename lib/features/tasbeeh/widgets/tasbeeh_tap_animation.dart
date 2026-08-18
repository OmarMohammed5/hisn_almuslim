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
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadePlusOne;
  late Animation<Offset> _slidePlusOne;

  bool _showPlusOne = false;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // ✅ Scale: ينكمش ويرجع ببساطة
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.90),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.90, end: 1.0),
        weight: 60,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // ✅ +1 Fade
    _fadePlusOne = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 70,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _slidePlusOne = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.8),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showPlusOne = false;
          _isAnimating = false;
        });
        _controller.reset();
      }
    });
  }

  void _handleTap() {
    if (_isAnimating) return;

    setState(() {
      _showPlusOne = true;
      _isAnimating = true;
    });

    _controller.forward(from: 0.0);
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
        alignment: Alignment.topCenter,
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
              top: -10.h,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadePlusOne.value,
                    child: Transform.translate(
                      offset: _slidePlusOne.value * 50.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          '+1',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                            fontFamily: 'QuranFont',
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}