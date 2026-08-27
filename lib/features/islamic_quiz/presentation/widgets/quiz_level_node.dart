import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/shared/custom_text.dart';
import '../../domain/entities/level_entity.dart';
import '../theme/quiz_tokens.dart';
import 'quiz_press_scale.dart';
import 'quiz_stars.dart';


class QuizLevelNode extends StatelessWidget {
  const QuizLevelNode({
    super.key,
    required this.level,
    required this.unlocked,
    required this.passed,
    required this.stars,
    required this.bestScore,
    required this.isLast,
    this.justUnlocked = false,
    this.onTap,
  });

  final LevelEntity level;
  final bool unlocked;
  final bool passed;
  final int stars;
  final int bestScore;
  final bool isLast;

  final bool justUnlocked;

  final VoidCallback? onTap;

  Color _nodeColor(BuildContext context) {
    if (passed) return QuizColors.success;
    if (unlocked) return QuizColors.primary(context);
    return QuizColors.locked;
  }

  IconData get _nodeIcon {
    if (passed) return Icons.check_rounded;
    if (unlocked) return Icons.play_arrow_rounded;
    return Icons.lock_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final color = _nodeColor(context);

    Widget circle = Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: unlocked ? .14 : .08),
        border: Border.all(color: color.withValues(alpha: unlocked ? .8 : .4), width: 2),
      ),
      alignment: Alignment.center,
      child: Icon(_nodeIcon, size: 28.sp, color: color),
    );

    if (justUnlocked) {
      circle = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: QuizDurations.slow,
        curve: Curves.easeOutBack,
        builder: (context, t, child) => Opacity(
          opacity: t.clamp(0, 1),
          child: Transform.scale(scale: .7 + (.3 * t), child: child),
        ),
        child: circle,
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              circle,
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 3.w,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                      color: passed
                          ? QuizColors.success.withValues(alpha: .5)
                          : QuizColors.border(context),
                      borderRadius: BorderRadius.circular(QuizRadius.pill),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: QuizSpacing.md.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : QuizSpacing.lg.h),
              child: QuizPressScale(
                enabled: unlocked,
                child: AnimatedOpacity(
                  opacity: unlocked ? 1 : .6,
                  duration: QuizDurations.normal,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: unlocked ? onTap : null,
                      borderRadius: BorderRadius.circular(QuizRadius.lg.r),
                      child: Ink(
                        padding: EdgeInsets.all(18.w),
                        decoration: BoxDecoration(
                          color: QuizColors.card(context),
                          borderRadius: BorderRadius.circular(QuizRadius.lg.r),
                          border: Border.all(
                            color: unlocked
                                ? color.withValues(alpha: .28)
                                : QuizColors.border(context),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomText(
                                    'المستوى ${level.levelNumber}',
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (unlocked)
                                  Icon(Icons.arrow_forward_ios_rounded,
                                      size: 14.sp, color: QuizColors.textSecondary(context)),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            CustomText(
                              unlocked
                                  ? '${level.questions.length} سؤال'
                                  : 'أكمل المستوى ${level.levelNumber - 1} لفتح هذا المستوى',
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                            ),
                            if (unlocked && (bestScore > 0 || stars > 0)) ...[
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  if (bestScore > 0) ...[
                                    CustomText(
                                      'أفضل نتيجة: $bestScore%',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.sp,
                                    ),
                                    SizedBox(width: QuizSpacing.sm.w),
                                  ],
                                  if (stars > 0) QuizStars(count: stars, size: 15),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
