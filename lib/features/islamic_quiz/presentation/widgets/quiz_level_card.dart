import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return AnimatedOpacity(
      duration:
      const Duration(milliseconds: 250),
      opacity: unlocked ? 1 : .55,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
          BorderRadius.circular(25.r),
          child: Ink(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xff1C2227)
                  : Colors.white,
              borderRadius:
              BorderRadius.circular(25.r),
              border: Border.all(
                color: unlocked
                    ? Colors.green.withValues(
                  alpha: .25,
                )
                    : Colors.grey.withValues(
                  alpha: .2,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 62.w,
                  height: 62.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: unlocked
                        ? Colors.green.withValues(
                      alpha: .12,
                    )
                        : Colors.grey.withValues(
                      alpha: .1,
                    ),
                  ),
                  child: Icon(
                    unlocked
                        ? Icons.play_arrow_rounded
                        : Icons.lock_rounded,
                    size: 32.sp,
                  ),
                ),

                SizedBox(width: 16.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المستوى ${level.levelNumber}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),

                      SizedBox(height: 6.h),

                      Text(
                        '${level.questions.length} سؤال',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withValues(
                            alpha: .6,
                          ),
                        ),
                      ),

                      if (unlocked &&
                          bestScore > 0) ...[
                        SizedBox(height: 8.h),
                        Text(
                          'أفضل نتيجة: $bestScore%',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],

                      if (stars > 0) ...[
                        SizedBox(height: 7.h),
                        Row(
                          children:
                          List.generate(
                            3,
                                (index) => Icon(
                              index < stars
                                  ? Icons.star_rounded
                                  : Icons
                                  .star_outline_rounded,
                              size: 18.sp,
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
                    size: 16.sp,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}