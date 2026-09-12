import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/responsive/app_responsive.dart';

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
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 14)),
          splashColor: accentColor.withValues(alpha: 0.10),
          highlightColor: accentColor.withValues(alpha: 0.05),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.widthValue(context, 18),
              vertical:AppResponsive.heightValue(context, 10),
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppResponsive.radius(context, 14)),
              border: Border.all(
                color: borderColor,
                width: AppResponsive.widthValue(context, 1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // PREVIOUS

                if (!isNext) ...[
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size:AppResponsive.iconSize(context, 14),
                    color: iconColor,
                  ),
                  SizedBox(width: AppResponsive.widthValue(context, 6)),
                ],

                // LABEL

                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 13),
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    fontFamily: 'Noon',
                    height:AppResponsive.heightValue(context, 1.2),
                  ),
                ),

                // NEXT

                if (isNext) ...[
                  SizedBox(width: AppResponsive.widthValue(context, 6)),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size:AppResponsive.iconSize(context, 14),
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