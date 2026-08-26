import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/theme_cubit.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey.shade900.withOpacity(0.3)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? Colors.grey.shade800.withOpacity(0.3)
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          /// Light Mode
          _buildThemeTile(
            context: context,
            title: "الوضع الفاتح",
            icon: Icons.wb_sunny_outlined,
            isActive: isLight,
            isDark: isDark,
            onChanged: isLight
                ? null
                : () {
                    context.read<ThemeCubit>().toggleTheme();
                  },
            activeColor: Colors.orange.shade600,
          ),

          Divider(
            color: isDark
                ? Colors.grey.shade800.withOpacity(0.3)
                : Colors.grey.shade400.withValues(alpha: 0.5),
            height: 1.h,
            indent: 16.w,
            endIndent: 16.w,
          ),

          /// Dark Mode
          _buildThemeTile(
            context: context,
            title: "الوضع الداكن",
            icon: Icons.dark_mode_outlined,
            isActive: isDark,
            isDark: isDark,
            onChanged: isDark
                ? null
                : () {
                    context.read<ThemeCubit>().toggleTheme();
                  },
            activeColor: Colors.teal.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isActive,
    required bool isDark,
    required VoidCallback? onChanged,
    required Color activeColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onChanged,
        borderRadius: BorderRadius.circular(12.r),
        splashColor: isActive
            ? activeColor.withOpacity(0.1)
            : Colors.grey.withOpacity(0.05),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? LinearGradient(
                          colors: [
                            activeColor.withOpacity(0.15),
                            activeColor.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isDark
                      ? (isActive
                            ? activeColor.withOpacity(0.15)
                            : Colors.grey.shade800.withOpacity(0.2))
                      : (isActive
                            ? activeColor.withOpacity(0.08)
                            : Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isActive
                        ? activeColor.withOpacity(0.2)
                        : (isDark
                              ? Colors.grey.shade700.withOpacity(0.1)
                              : Colors.grey.shade200),
                    width: isActive ? 1.5 : 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isActive
                      ? activeColor
                      : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                  size: 20.sp,
                ),
              ),

              Gap(14.w),

              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title,
                      fontSize: 13.sp,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                      color: isActive
                          ? (isDark ? Colors.white : Colors.black87)
                          : (isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade700),
                    ),
                  ],
                ),
              ),

              // Custom Switch
              _buildCustomSwitch(
                isActive: isActive,
                activeColor: activeColor,
                isDark: isDark,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomSwitch({
    required bool isActive,
    required Color activeColor,
    required bool isDark,
    required VoidCallback? onChanged,
  }) {
    return GestureDetector(
      onTap: onChanged,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 48.w,
        height: 28.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
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
              width: 48.w,
              height: 28.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
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
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Container(
                  width: 22.w,
                  height: 22.w,
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
                    size: 14.sp,
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
