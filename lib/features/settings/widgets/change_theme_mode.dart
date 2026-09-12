import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/theme_cubit.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../core/responsive/app_responsive.dart';

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
      padding: EdgeInsets.symmetric(vertical: AppResponsive.heightValue(context, 8), horizontal: AppResponsive.widthValue(context, 4)),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey.shade900.withOpacity(0.3)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 16)),
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
            height: AppResponsive.heightValue(context, 1),
            indent: AppResponsive.widthValue(context, 16),
            endIndent: AppResponsive.widthValue(context, 16),
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
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        splashColor: isActive
            ? activeColor.withOpacity(0.1)
            : Colors.grey.withOpacity(0.05),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 10), vertical: AppResponsive.heightValue(context, 8)),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
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
                  borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
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
                  size: AppResponsive.iconSize(context, 20),
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
                      fontSize: AppResponsive.fontSize(context, 11),
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
                context: context,
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
    required BuildContext context,
    required bool isActive,
    required Color activeColor,
    required bool isDark,
    required VoidCallback? onChanged,
  }) {
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
