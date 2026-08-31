import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/shared/custom_text.dart';
import '../../domain/entities/answer_entity.dart';
import '../theme/quiz_tokens.dart';


class QuizAnswerCard extends StatefulWidget {
  const QuizAnswerCard({
    super.key,
    required this.answer,
    required this.index,
    required this.selectedIndex,
    required this.isAnswered,
    required this.onTap,
  });

  final AnswerEntity answer;
  final int index;
  final int? selectedIndex;
  final bool isAnswered;
  final VoidCallback onTap;

  @override
  State<QuizAnswerCard> createState() => _QuizAnswerCardState();
}

class _QuizAnswerCardState extends State<QuizAnswerCard> {
  bool _pressed = false;
  int _shakeTrigger = 0;

  bool get _isSelected => widget.selectedIndex == widget.index;
  bool get _showCorrect => widget.isAnswered && widget.answer.isCorrect;
  bool get _showWrong => widget.isAnswered && _isSelected && !widget.answer.isCorrect;

  @override
  void didUpdateWidget(covariant QuizAnswerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final justAnswered = !oldWidget.isAnswered && widget.isAnswered;
    if (justAnswered && _isSelected) {
      if (widget.answer.isCorrect) {
        HapticFeedback.lightImpact();
      } else {
        HapticFeedback.mediumImpact();
        setState(() => _shakeTrigger++);
      }
    }
  }

  void _setPressed(bool value) {
    if (widget.isAnswered) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = QuizColors.border(context);
    Color? backgroundColor;
    IconData? icon;
    Color? iconColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_showCorrect) {
      borderColor = QuizColors.success;
      backgroundColor = QuizColors.successSoft;
      icon = Icons.check_circle_rounded;
      iconColor = QuizColors.success;
    } else if (_showWrong) {
      borderColor = QuizColors.error;
      backgroundColor = QuizColors.errorSoft;
      icon = Icons.cancel_rounded;
      iconColor = QuizColors.error;
    }

    final emphasized = _showCorrect || _showWrong;

    Widget card = AnimatedContainer(
      duration: QuizDurations.normal,
      curve: Curves.easeOut,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? QuizColors.card(context),
        borderRadius: BorderRadius.circular(QuizRadius.md.r),
        border: Border.all(color: borderColor, width: emphasized ? 2 : 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isAnswered ? null : widget.onTap,
          onTapDown: (_) => _setPressed(true),
          onTapCancel: () => _setPressed(false),
          onTapUp: (_) => _setPressed(false),
          borderRadius: BorderRadius.circular(QuizRadius.md.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 17.h),
            child: Row(
              children: [
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isAnswered
                        ? borderColor.withValues(alpha: .14)
                        : QuizColors.primarySoft(context),
                  ),
                  alignment: Alignment.center,
                  child: icon != null
                      ? Icon(icon, size: 21.sp, color: iconColor)
                      : CustomText(
                          maxLines: 30,
                          "${widget.index + 1}",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                        ),
                ),
                SizedBox(width: 13.w),
                Expanded(
                  child: CustomText(
                    widget.answer.answer,
                    textAlign: TextAlign.right,
                    fontSize: 16.sp,
                    maxLines: 30,
                    fontFamily: "Noon",
                    height: 1.6,
                    fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
                    color: isDark ? const Color(0xFFF3F6F4) : const Color(0xFF14211A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    card = AnimatedScale(
      scale: _pressed ? .98 : 1,
      duration: QuizDurations.fast,
      child: card,
    );

    // One-shot horizontal shake, replayed whenever _shakeTrigger changes.
    return TweenAnimationBuilder<double>(
      key: ValueKey(_shakeTrigger),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOut,
      builder: (context, t, child) {
        final dx = _shakeTrigger == 0
            ? 0.0
            : math.sin(t * math.pi * 4) * (1 - t) * 6.0;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: card,
    );
  }
}
