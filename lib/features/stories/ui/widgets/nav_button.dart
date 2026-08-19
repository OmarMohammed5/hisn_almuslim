import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isNext;

  const NavButton({
    super.key,
    required this.label,
    this.onTap,
    required this.enabled,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // APP ACCENT

    final accentColor = isDark
        ? Colors.tealAccent.shade200
        : Colors.teal.shade700;

    // BACKGROUND

    final backgroundColor = enabled
        ? (isDark
        ? const Color(0xFF19332F)
        : const Color(0xFFE6F2EF))
        : (isDark
        ? const Color(0xFF24282A)
        : const Color(0xFFF1F3F3));

    // TEXT

    final textColor = enabled
        ? (isDark ? Colors.white : const Color(0xFF164C45))
        : (isDark
        ? Colors.white.withValues(alpha: 0.35)
        : Colors.black.withValues(alpha: 0.30));

    // ICON

    final iconColor = enabled
        ? accentColor
        : (isDark
        ? Colors.white.withValues(alpha: 0.25)
        : Colors.black.withValues(alpha: 0.25));

    // BORDER

    final borderColor = enabled
        ? accentColor.withValues(alpha: isDark ? 0.18 : 0.15)
        : Colors.transparent;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1 : 0.85,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(14.r),
          splashColor: accentColor.withValues(alpha: 0.10),
          highlightColor: accentColor.withValues(alpha: 0.05),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              horizontal: 18.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // PREVIOUS

                if (!isNext) ...[
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 14.sp,
                    color: iconColor,
                  ),
                  SizedBox(width: 6.w),
                ],

                // LABEL

                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    fontFamily: 'QuranFont',
                    height: 1.2,
                  ),
                ),

                // NEXT

                if (isNext) ...[
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14.sp,
                    color: iconColor,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}