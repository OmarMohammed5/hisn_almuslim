import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/responsive/app_responsive.dart';

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    super.key,
    this.icon,
    required this.title,
    this.trailing,
    this.subTitle,
  });
  final IconData? icon;
  final String title;
  final Widget? trailing;
  final Widget? subTitle;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(AppResponsive.widthValue(context, 6)),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.teal.shade800.withValues(alpha: 0.3)
              : Colors.teal.shade50,
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 8)),
        ),
        child: Icon(icon, size: AppResponsive.iconSize(context, 22), color: AppColors.kIconColor),
      ),
      title: CustomText(title, fontSize: AppResponsive.fontSize(context, 12), fontWeight: FontWeight.w600),
      trailing: trailing,
      subtitle: subTitle,
    );
  }
}
