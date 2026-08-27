import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../theme/quiz_tokens.dart';

/// The "next question / finish level" button. Renders empty (zero
/// height) until [visible] flips to true, then fades + slides up —
/// matching the "appears only after answering" requirement without
/// the caller needing to manage an AnimationController.
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
              height: 54.h,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(QuizRadius.md.r),
                  ),
                ),
                child: CustomText(
                  label,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            )
          : const SizedBox.shrink(key: ValueKey('next-hidden')),
    );
  }
}
