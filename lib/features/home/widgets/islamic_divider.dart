import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import '../../../core/responsive/app_responsive.dart';

class IslamicDivider extends StatelessWidget {
  const IslamicDivider({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppResponsive.heightValue(context, 20)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: AppResponsive.heightValue(context, 1),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    isDark ? Colors.teal.shade700 : Colors.teal.shade400,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 16)),
            child: Container(
              padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.teal.shade900.withValues(alpha: 0.3)
                    : Colors.teal.shade50,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? Colors.teal.shade700 : Colors.teal.shade400,
                  width: AppResponsive.widthValue(context, 2),
                ),
              ),
              child: Icon(
                FlutterIslamicIcons.islam,
                color: isDark ? Colors.teal.shade400 : Colors.teal.shade700,
                size: AppResponsive.fontSize(context, 16),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: AppResponsive.heightValue(context, 1),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    isDark ? Colors.teal.shade700 : Colors.teal.shade400,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
