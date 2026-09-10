import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/responsive/app_responsive.dart';

class CustomSwitchWidget extends StatelessWidget {
  final bool isActive;
  final Color activeColor;
  final bool isDark;
  final VoidCallback onChanged;

  const CustomSwitchWidget({super.key,
    required this.isActive,
    required this.activeColor,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: AppResponsive.widthValue(context, 48),
        height: AppResponsive.heightValue(context, 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 14)),
          color: isActive
              ? activeColor
              : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: activeColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Track
            Container(
              width: AppResponsive.widthValue(context, 48),
              height: AppResponsive.heightValue(context, 28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppResponsive.radius(context, 14)),
                gradient: isActive
                    ? LinearGradient(
                  colors: [activeColor, activeColor.withOpacity(0.7)],
                )
                    : null,
              ),
            ),
            // Thumb
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: isActive
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 3)),
                child: Container(
                  width: AppResponsive.widthValue(context, 22),
                  height: AppResponsive.widthValue(context, 22),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isActive ? Icons.check_rounded : Icons.close_rounded,
                    size: AppResponsive.iconSize(context, 14),
                    color: isActive ? activeColor : Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
