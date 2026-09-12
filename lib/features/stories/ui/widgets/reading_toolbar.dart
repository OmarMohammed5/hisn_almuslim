import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/responsive/app_responsive.dart';
import '../../domain/entities/prophet_story.dart';

class ReadingToolbar extends StatelessWidget {
  final ProphetStory story;
  final double fontSize;
  final VoidCallback onIncreaseFontSize;
  final VoidCallback onDecreaseFontSize;
  final VoidCallback onShare;
  final VoidCallback onCopy;

  const ReadingToolbar({
    super.key,
    required this.story,
    required this.fontSize,
    required this.onIncreaseFontSize,
    required this.onDecreaseFontSize,
    required this.onShare,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // APP ACCENT

    final accentColor = isDark
        ? Colors.tealAccent.shade200
        : Colors.teal.shade700;

    // TOOLBAR COLORS

    final toolbarColor = isDark
        ? const Color(0xFF171C1D)
        : const Color(0xFFFFFFFF);

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.06);

    final iconBackgroundColor = isDark
        ? const Color(0xFF202827)
        : const Color(0xFFF2F7F6);

    final iconColor = isDark
        ? Colors.white.withValues(alpha: 0.72)
        : Colors.black.withValues(alpha: 0.60);

    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08);

    return Container(
      margin: EdgeInsets.fromLTRB(
        AppResponsive.widthValue(context, 16),
        0,
        AppResponsive.widthValue(context, 16),
        AppResponsive.heightValue(context, 20),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 10),
        vertical: AppResponsive.heightValue(context, 8),
      ),
      decoration: BoxDecoration(
        color: toolbarColor,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
        border: Border.all(
          color: borderColor,
          width: AppResponsive.widthValue(context, 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.25 : 0.07,
            ),
            blurRadius: 12.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // FONT SIZE CONTROLS

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ToolbarIcon(
                  icon: Icons.remove_rounded,
                  onTap: onDecreaseFontSize,
                  size: AppResponsive.iconSize(context, 18),
                  iconColor: iconColor,
                  backgroundColor: iconBackgroundColor,
                ),

                SizedBox(width: AppResponsive.widthValue(context, 4)),

                // Current font indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: AppResponsive.widthValue(context, 42),
                  height: AppResponsive.heightValue(context, 34),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppResponsive.radius(context, 10)),
                  ),
                  child: Text(
                    'Aa',
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 15),
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                      fontFamily: 'Noon',
                    ),
                  ),
                ),

                SizedBox(width: AppResponsive.widthValue(context, 4)),

                _ToolbarIcon(
                  icon: Icons.add_rounded,
                  onTap: onIncreaseFontSize,
                  size: AppResponsive.iconSize(context, 18),
                  iconColor: iconColor,
                  backgroundColor: iconBackgroundColor,
                ),
              ],
            ),
          ),

          // DIVIDER

          Container(
            width: AppResponsive.widthValue(context, 1),
            height: AppResponsive.heightValue(context, 24),
            margin: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 6)),
            color: dividerColor,
          ),

          // ACTIONS

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ToolbarIcon(
                  icon: Icons.copy_rounded,
                  onTap: onCopy,
                  size: AppResponsive.iconSize(context, 18),
                  iconColor: iconColor,
                  backgroundColor: iconBackgroundColor,
                ),

                SizedBox(width: AppResponsive.widthValue(context, 16)),

                _ToolbarIcon(
                  icon: Icons.share_rounded,
                  onTap: onShare,
                  size: AppResponsive.iconSize(context, 18),
                  iconColor: iconColor,
                  backgroundColor: iconBackgroundColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// TOOLBAR ICON

class _ToolbarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color iconColor;
  final Color backgroundColor;

  const _ToolbarIcon({
    required this.icon,
    required this.onTap,
    required this.size,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 11)),
        splashColor: Colors.teal.withValues(alpha: 0.12),
        highlightColor: Colors.teal.withValues(alpha: 0.06),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: AppResponsive.widthValue(context, 34),
          height:AppResponsive.heightValue(context, 34),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(11.r),
          ),
          child: Icon(
            icon,
            size: size,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
