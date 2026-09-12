import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../theme/quiz_tokens.dart';

class QuizNextButton extends StatelessWidget {
  const QuizNextButton({
    super.key,
    required this.visible,
    required this.label,
    required this.onPressed,
  });

  final bool visible;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: QuizDurations.normal,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, .15),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
      ),
      child: visible
          ? SizedBox(
              key: const ValueKey('next-visible'),
              width: double.infinity,
              height: AppResponsive.heightValue(context, 58),
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppResponsive.radius(context, QuizRadius.md),
                    ),
                  ),
                ),
                child: CustomText(
                  label,
                  fontSize: AppResponsive.fontSize(context, 13),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            )
          : const SizedBox.shrink(key: ValueKey('next-hidden')),
    );
  }
}
