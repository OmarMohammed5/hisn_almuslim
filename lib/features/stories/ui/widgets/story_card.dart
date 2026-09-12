import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/responsive/app_responsive.dart';
import '../../../../core/theme/app_colors.dart';
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


    final indexColor = isDark
        ? Colors.white.withValues(alpha: 0.30)
        : Colors.black.withValues(alpha: 0.30);

    // PREVIEW

    final preview = story.story.trim();

    final previewText = preview.length > 110
        ? '${preview.substring(0, 110).trim()}...'
        : preview;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return Padding(
      padding: EdgeInsets.only(bottom:AppResponsive.heightValue(context, 12)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
          splashColor: accentColor.withValues(alpha: 0.06),
          highlightColor: accentColor.withValues(alpha: 0.03),
          child: Ink(
            padding: EdgeInsets.fromLTRB(
              AppResponsive.widthValue(context, 18),
              AppResponsive.heightValue(context, 16),
              AppResponsive.widthValue(context, 18),
              AppResponsive.heightValue(context, 14),
            ),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: borderColor, width: AppResponsive.widthValue(context, 1)),
              borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
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
                        fontSize: AppResponsive.fontSize(context, 12),
                        fontWeight: FontWeight.w700,
                        color: indexColor,
                        fontFamily: 'Cairo',
                        letterSpacing: 0.5,
                      ),
                    ),

                    SizedBox(width: AppResponsive.widthValue(context, 12)),

                    // PROPHET NAME
                    Expanded(
                      child: Text(
                        story.prophet,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 16),
                          fontWeight: FontWeight.w800,
                          color: titleColor,
                          fontFamily: 'Noon',
                          height: AppResponsive.heightValue(context, 1.35),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppResponsive.heightValue(context, 10)),
                // STORY PREVIEW
                Padding(
                  padding: EdgeInsets.only(
                    left: AppResponsive.widthValue(context, 26),
                  ),
                  child: Text(
                    previewText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 12.5),
                      fontWeight: FontWeight.w400,
                      color: previewColor,
                      fontFamily: 'Noon',
                      height: AppResponsive.heightValue(context, 1.65),
                    ),
                  ),
                ),

                SizedBox(height: AppResponsive.heightValue(context, 14)),

                // DIVIDER
                Container(
                  height: AppResponsive.heightValue(context, 1),
                  color: borderColor,
                ),

                SizedBox(height: AppResponsive.heightValue(context, 10)),

                // READ ACTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'اقرأ القصة',
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 11),
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                        fontFamily: 'Noon',
                      ),
                    ),

                    SizedBox(width: AppResponsive.widthValue(context, 5)),

                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: AppResponsive.iconSize(context, 12),
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