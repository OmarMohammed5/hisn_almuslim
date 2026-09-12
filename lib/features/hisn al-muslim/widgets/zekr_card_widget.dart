import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/responsive/app_responsive.dart';
import '../../../core/theme/app_colors.dart';

class ZekrCardWidget extends StatelessWidget {
  const ZekrCardWidget({super.key, required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;


    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 6), vertical: AppResponsive.heightValue(context, 4)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 16)),
          splashColor: Colors.teal.shade200.withOpacity(0.4),
          highlightColor: Colors.teal.shade200.withOpacity(0.2),
          child: Container(
            padding: EdgeInsets.all(AppResponsive.widthValue(context, 12)),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: borderColor, width: AppResponsive.widthValue(context, 1)),
              borderRadius: BorderRadius.circular(AppResponsive.radius(context, 16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Logo & Title of Zekr
                Expanded(
                  child: Row(
                    spacing: AppResponsive.widthValue(context, 12),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: AppResponsive.widthValue(context, 44),
                        height: AppResponsive.heightValue(context, 44),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF272A2E)
                              : const Color(0xffE9EEF0),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.teal.shade700.withOpacity(0.1),
                            width: AppResponsive.widthValue(context, 1.5),
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/images/decoor.png",
                            width: AppResponsive.widthValue(context, 28),
                            height: AppResponsive.heightValue(context, 28),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppResponsive.fontSize(context, 15),
                            fontFamily: "Noon",
                            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                            height: AppResponsive.heightValue(context, 1.4),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(AppResponsive.widthValue(context, 4)),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF272A2E)
                        : const Color(0xffE9EEF0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: AppResponsive.iconSize(context, 14),
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}