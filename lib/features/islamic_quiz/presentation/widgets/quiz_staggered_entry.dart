import 'package:flutter/material.dart';

import '../theme/quiz_tokens.dart';

/// Wraps [child] with a subtle fade + slide-up entrance, delayed by
/// `index * QuizDurations.entranceStep`. Pure implicit animation (no
/// AnimationController) so it is cheap to use on every card in a list.
///
/// Usage: wrap each item in a `List.generate` with
/// `QuizStaggeredEntry(index: index, child: ...)`.
class QuizStaggeredEntry extends StatefulWidget {
  const QuizStaggeredEntry({
    super.key,
    required this.index,
    required this.child,
  });

  final int index;
  final Widget child;

  @override
  State<QuizStaggeredEntry> createState() => _QuizStaggeredEntryState();
}

class _QuizStaggeredEntryState extends State<QuizStaggeredEntry> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(QuizDurations.entranceStep * widget.index, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: QuizDurations.slow,
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, .08),
        duration: QuizDurations.slow,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
