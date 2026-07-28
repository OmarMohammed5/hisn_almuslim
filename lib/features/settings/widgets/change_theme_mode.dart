import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/theme_cubit.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../../../core/theme/app_colors.dart';

class ChangeThemeMode extends StatelessWidget {
  const ChangeThemeMode({
    super.key,
    required this.isDark,
    required this.isLight,
  });

  final bool isDark;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Light Mode
        ListTile(
          title: CustomText(
            "الوضع الفاتح",
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w600,
          ),
          leading: Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.teal.shade800.withValues(alpha: 0.3)
                  : Colors.teal.shade50,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.wb_sunny_outlined,
              color: AppColors.kIconColor,
              size: 22.sp,
            ),
          ),
          trailing: Switch(
            value: isLight,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.kIconColor,
            inactiveThumbColor: Colors.white70,
            inactiveTrackColor: Colors.white,
            onChanged: isLight
                ? null
                : (__) {
                    /// Change theme
                    context.read<ThemeCubit>().toggleTheme();
                  },
          ),
        ),
        Gap(6.h),
        Divider(color: isDark ? const Color(0xff023d22) : Colors.grey.shade300),
        Gap(6.h),
        // Dark Mode
        ListTile(
          title: CustomText(
            "الوضع الداكن",
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w600,
          ),
          leading: Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.teal.shade800.withValues(alpha: 0.3)
                  : Colors.teal.shade50,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.dark_mode_outlined,
              color: AppColors.kIconColor,
              size: 22.sp,
            ),
          ),
          trailing: Switch(
            value: isDark,
            activeThumbColor: Colors.white,
            activeTrackColor: Colors.teal.shade800,
            inactiveThumbColor: Colors.teal.shade900,
            inactiveTrackColor: Colors.white,
            onChanged: isDark
                ? null
                : (_) {
                    /// Change theme

                    context.read<ThemeCubit>().toggleTheme();
                  },
          ),
        ),
      ],
    );
  }
}
