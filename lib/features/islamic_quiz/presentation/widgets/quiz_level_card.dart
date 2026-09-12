import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/level_entity.dart';

class QuizLevelCard extends StatelessWidget {
  const QuizLevelCard({
    super.key,
    required this.level,
    required this.unlocked,
    required this.stars,
    required this.bestScore,
    required this.onTap,
  });

  final LevelEntity level;
  final bool unlocked;
  final int stars;
  final int bestScore;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: unlocked ? 1 : .55,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, 25),
          ),
          child: Ink(
            padding: EdgeInsets.all(AppResponsive.widthValue(context, 20)),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(
                AppResponsive.radius(context, 25),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: AppResponsive.widthValue(context, 62),
                  height: AppResponsive.widthValue(context, 62),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: unlocked
                        ? Colors.green.withValues(alpha: .12)
                        : Colors.grey.withValues(alpha: .1),
                  ),
                  child: Icon(
                    unlocked ? Icons.play_arrow_rounded : Icons.lock_rounded,
                    size: AppResponsive.fontSize(context, 32),
                  ),
                ),

                SizedBox(width: AppResponsive.widthValue(context, 16)),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المستوى ${level.levelNumber}',
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 18),
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      SizedBox(height: AppResponsive.heightValue(context, 6)),

                      Text(
                        '${level.questions.length} سؤال',
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 13),
                          color: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withValues(alpha: .6),
                        ),
                      ),

                      if (unlocked && bestScore > 0) ...[
                        SizedBox(height: AppResponsive.heightValue(context, 8)),
                        Text(
                          'أفضل نتيجة: $bestScore%',
                          style: TextStyle(
                            fontSize: AppResponsive.fontSize(context, 12),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],

                      if (stars > 0) ...[
                        SizedBox(height: AppResponsive.heightValue(context, 7)),
                        Row(
                          children: List.generate(
                            3,
                            (index) => Icon(
                              index < stars
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: AppResponsive.fontSize(context, 18),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                if (unlocked)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: AppResponsive.fontSize(context, 16),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
