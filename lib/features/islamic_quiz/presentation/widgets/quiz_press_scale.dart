import 'package:flutter/material.dart';

import '../theme/quiz_tokens.dart';

class QuizPressScale extends StatefulWidget {
  const QuizPressScale({super.key, required this.child, this.enabled = true});

  final Widget child;

  final bool enabled;

  @override
  State<QuizPressScale> createState() => _QuizPressScaleState();
}

class _QuizPressScaleState extends State<QuizPressScale> {
  bool _pressed = false;

  void _set(bool value) {
    if (!widget.enabled) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _pressed ? .97 : 1,
        duration: QuizDurations.fast,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
