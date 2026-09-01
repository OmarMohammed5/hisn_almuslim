import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/prophet_story.dart';

class StoryCard extends StatelessWidget {
  final ProphetStory story;
  final int index;
  final VoidCallback onTap;

  const StoryCard({
    super.key,
    required this.story,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // COLORS

    final accentColor = isDark
        ? Colors.tealAccent.shade200
        : Colors.teal.shade700;

    final titleColor = isDark
        ? Colors.white
        : const Color(0xFF171A19);

    final previewColor = isDark
        ? Colors.white.withValues(alpha: 0.45)
        : Colors.black.withValues(alpha: 0.48);

    final surfaceColor = isDark
        ? const Color(0xFF171C1D)
        : Colors.white;

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.06);

    final indexColor = isDark
        ? Colors.white.withValues(alpha: 0.30)
        : Colors.black.withValues(alpha: 0.30);

    // PREVIEW

    final preview = story.story.trim();

    final previewText = preview.length > 110
        ? '${preview.substring(0, 110).trim()}...'
        : preview;

    // CARD

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          splashColor: accentColor.withValues(alpha: 0.06),
          highlightColor: accentColor.withValues(alpha: 0.03),
          child: Ink(
            padding: EdgeInsets.fromLTRB(
              18.w,
              16.h,
              18.w,
              14.h,
            ),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP ROW
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // STORY NUMBER
                    Text(
                      '${(index + 1).toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: indexColor,
                        fontFamily: 'Cairo',
                        letterSpacing: 0.5,
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // PROPHET NAME
                    Expanded(
                      child: Text(
                        story.prophet,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: titleColor,
                          fontFamily: 'Noon',
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),
                // STORY PREVIEW
                Padding(
                  padding: EdgeInsets.only(
                    left: 26.w,
                  ),
                  child: Text(
                    previewText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w400,
                      color: previewColor,
                      fontFamily: 'Noon',
                      height: 1.65,
                    ),
                  ),
                ),

                SizedBox(height: 14.h),

                // DIVIDER
                Container(
                  height: 1,
                  color: borderColor,
                ),

                SizedBox(height: 10.h),

                // READ ACTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'اقرأ القصة',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                        fontFamily: 'Noon',
                      ),
                    ),

                    SizedBox(width: 5.w),

                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 11.sp,
                      color: accentColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}