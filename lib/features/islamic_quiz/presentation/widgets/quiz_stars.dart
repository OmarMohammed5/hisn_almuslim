import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/quiz_tokens.dart';


class QuizStars extends StatelessWidget {
  const QuizStars({
    super.key,
    required this.count,
    this.size = 32,
    this.animate = false,
  });

  final int count;
  final double size;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final filled = index < count;
        final color = filled ? QuizColors.warning : QuizColors.locked;
        final icon = Icon(
          filled ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size.sp,
          color: color,
        );

        final star = Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: icon,
        );

        if (!animate) return star;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: QuizDurations.slow,
          curve: Curves.easeOutBack,
          builder: (context, t, child) => Opacity(
            opacity: t.clamp(0, 1),
            child: Transform.scale(scale: t, child: child),
          ),
          child: star,
        )
            .let((w) => _Delayed(delay: Duration(milliseconds: 140 * index), child: w));
      }),
    );
  }
}

class _Delayed extends StatefulWidget {
  const _Delayed({required this.delay, required this.child});
  final Duration delay;
  final Widget child;

  @override
  State<_Delayed> createState() => _DelayedState();
}

class _DelayedState extends State<_Delayed> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _ready ? 1 : 0,
      duration: const Duration(milliseconds: 1),
      child: _ready ? widget.child : Opacity(opacity: 0, child: widget.child),
    );
  }
}

extension _Let<T> on T {
  R let<R>(R Function(T) block) => block(this);
}
