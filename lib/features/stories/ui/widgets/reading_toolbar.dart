import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        16.w,
        0,
        16.w,
        20.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: toolbarColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.25 : 0.07,
            ),
            blurRadius: 20.r,
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
                  size: 18.sp,
                  iconColor: iconColor,
                  backgroundColor: iconBackgroundColor,
                ),

                SizedBox(width: 4.w),

                // Current font indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 42.w,
                  height: 34.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    'Aa',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                      fontFamily: 'QuranFont',
                    ),
                  ),
                ),

                SizedBox(width: 4.w),

                _ToolbarIcon(
                  icon: Icons.add_rounded,
                  onTap: onIncreaseFontSize,
                  size: 18.sp,
                  iconColor: iconColor,
                  backgroundColor: iconBackgroundColor,
                ),
              ],
            ),
          ),

          // DIVIDER

          Container(
            width: 1.w,
            height: 24.h,
            margin: EdgeInsets.symmetric(horizontal: 6.w),
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
                  size: 18.sp,
                  iconColor: iconColor,
                  backgroundColor: iconBackgroundColor,
                ),

                SizedBox(width: 16.w),

                _ToolbarIcon(
                  icon: Icons.share_rounded,
                  onTap: onShare,
                  size: 18.sp,
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
        borderRadius: BorderRadius.circular(11.r),
        splashColor: Colors.teal.withValues(alpha: 0.12),
        highlightColor: Colors.teal.withValues(alpha: 0.06),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 34.w,
          height: 34.w,
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
