import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';

import '../../../../core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';
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

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    Widget circle = Container(
      width: AppResponsive.widthValue(context, 64),
      height: AppResponsive.widthValue(context, 64),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
      ),
      alignment: Alignment.center,
      child: Icon(
        _nodeIcon,
        size: AppResponsive.fontSize(context, 28),
        color: color,
      ),
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
                    width: AppResponsive.widthValue(context, 3),
                    margin: EdgeInsets.symmetric(
                      vertical: AppResponsive.heightValue(context, 4),
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      border: Border.all(color: borderColor, width: 1),
                      borderRadius: BorderRadius.circular(QuizRadius.pill),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: AppResponsive.widthValue(context, QuizSpacing.md)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast
                    ? 0
                    : AppResponsive.heightValue(context, QuizSpacing.lg),
              ),
              child: QuizPressScale(
                enabled: unlocked,
                child: AnimatedOpacity(
                  opacity: unlocked ? 1 : .6,
                  duration: QuizDurations.normal,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: unlocked ? onTap : null,
                      borderRadius: BorderRadius.circular(
                        AppResponsive.radius(context, QuizRadius.lg),
                      ),
                      child: Ink(
                        padding: EdgeInsets.all(
                          AppResponsive.widthValue(context, 18),
                        ),
                        decoration: BoxDecoration(
                          color: bgColor,
                          border: Border.all(color: borderColor, width: 1),
                          borderRadius: BorderRadius.circular(
                            AppResponsive.radius(context, 18),
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
                                    fontSize: AppResponsive.fontSize(
                                      context,
                                      15,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (unlocked)
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: AppResponsive.fontSize(context, 14),
                                    color: QuizColors.textSecondary(context),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: AppResponsive.heightValue(context, 10),
                            ),
                            CustomText(
                              unlocked
                                  ? '${level.questions.length} سؤال'
                                  : 'أكمل المستوى ${level.levelNumber - 1} لفتح هذا المستوى',
                              fontWeight: FontWeight.w400,
                              fontSize: AppResponsive.fontSize(context, 12),
                            ),
                            if (unlocked && (bestScore > 0 || stars > 0)) ...[
                              SizedBox(
                                height: AppResponsive.heightValue(context, 10),
                              ),
                              Row(
                                children: [
                                  if (bestScore > 0) ...[
                                    CustomText(
                                      'أفضل نتيجة: $bestScore%',
                                      fontWeight: FontWeight.w600,
                                      fontSize: AppResponsive.fontSize(
                                        context,
                                        13,
                                      ),
                                    ),
                                    SizedBox(
                                      width: AppResponsive.widthValue(
                                        context,
                                        QuizSpacing.sm,
                                      ),
                                    ),
                                  ],
                                  if (stars > 0)
                                    QuizStars(count: stars, size: 15),
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
