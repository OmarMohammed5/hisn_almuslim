import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';

import '../../../../core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';
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

  bool get _showWrong =>
      widget.isAnswered && _isSelected && !widget.answer.isCorrect;

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

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;

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
        color: bgColor,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, QuizRadius.md),
        ),
        border: Border.all(color: borderColor, width: emphasized ? 2 : 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isAnswered ? null : widget.onTap,
          onTapDown: (_) => _setPressed(true),
          onTapCancel: () => _setPressed(false),
          onTapUp: (_) => _setPressed(false),
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, QuizRadius.md),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.widthValue(context, 18),
              vertical: AppResponsive.heightValue(context, 17),
            ),
            child: Row(
              children: [
                Container(
                  width: AppResponsive.widthValue(context, 38),
                  height: AppResponsive.widthValue(context, 38),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: bgColor,
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  alignment: Alignment.center,
                  child: icon != null
                      ? Icon(
                          icon,
                          size: AppResponsive.fontSize(context, 21),
                          color: iconColor,
                        )
                      : CustomText(
                          maxLines: 30,
                          "${widget.index + 1}",
                          fontSize: AppResponsive.fontSize(context, 14),
                          fontWeight: FontWeight.w800,
                        ),
                ),
                SizedBox(width: AppResponsive.widthValue(context, 13)),
                Expanded(
                  child: CustomText(
                    widget.answer.answer,
                    textAlign: TextAlign.right,
                    fontSize: AppResponsive.fontSize(context, 13),
                    maxLines: 30,
                    fontFamily: "Noon",
                    height: 1.6,
                    fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
                    color: isDark
                        ? const Color(0xFFF3F6F4)
                        : const Color(0xFF14211A),
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
