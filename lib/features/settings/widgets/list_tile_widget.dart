import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../../../core/theme/app_colors.dart';

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
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.teal.shade800.withValues(alpha: 0.3)
              : Colors.teal.shade50,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, size: 22.sp, color: AppColors.kIconColor),
      ),
      title: CustomText(title, fontSize: 12.5.sp, fontWeight: FontWeight.w600),
      trailing: trailing,
      subtitle: subTitle,
    );
  }
}
