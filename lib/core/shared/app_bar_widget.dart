import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../theme/app_colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    required this.title,
    this.isHomePage = false,
    this.showBackButton = true,
    this.actions,
    this.subtitle,
    this.leading,
  });

  final String title;
  final bool isHomePage;
  final bool showBackButton;
  final List<Widget>? actions;
  final String? subtitle;
  final Widget? leading;

  @override
  Size get preferredSize {
    return Size.fromHeight(subtitle != null ? 70.h : 58.h);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isHomePage) {
      return _buildHomeAppBar(context, isDark);
    }

    return _buildRegularAppBar(context, isDark);
  }

  AppBar _buildHomeAppBar(BuildContext context, bool isDark) {


    final titleColor = isDark
        ? const Color(0xFFF1F5F3)
        : const Color(0xFF1D2925);

    final accentColor = isDark
        ? const Color(0xFF63DCC6)
        : const Color(0xFF087F73);

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;

    return AppBar(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: bgColor,
      automaticallyImplyLeading: false,

      leading: leading,
      actions: actions,

      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (subtitle == null)
            SizedBox(height: AppResponsive.heightValue(context, 3)),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitleLine(context,accentColor),

              SizedBox(width: AppResponsive.widthValue(context, 12)),

              CustomText(
                title,
                color: titleColor,
                fontSize: AppResponsive.fontSize(context, 15),
                fontWeight: FontWeight.w800,
                maxLines: 1,
              ),

              SizedBox(width: AppResponsive.widthValue(context, 12)),

              _buildTitleLine(context,accentColor),
            ],
          ),

          if (subtitle != null) ...[
            SizedBox(height: AppResponsive.heightValue(context, 4)),

            CustomText(
              subtitle!,
              color: isDark ? const Color(0xFF929D99) : const Color(0xFF7D8985),
              fontSize: AppResponsive.fontSize(context, 10),
              fontWeight: FontWeight.w500,
              maxLines: 1,
            ),
          ],
        ],
      ),

      bottom: PreferredSize(
        preferredSize: Size.fromHeight(AppResponsive.heightValue(context, 1)),
        child: Container(
          height: AppResponsive.fontSize(context, 1),
          margin: EdgeInsets.symmetric(
            horizontal: AppResponsive.widthValue(context, 24),
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, 10),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildRegularAppBar(BuildContext context, bool isDark) {


    final titleColor = isDark
        ? const Color(0xFFF1F5F3)
        : const Color(0xFF202A27);

    final accentColor = isDark
        ? const Color(0xFF63DCC6)
        : const Color(0xFF087F73);

    final iconColor = isDark
        ? const Color(0xFFE5ECE9)
        : const Color(0xFF26322F);

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;


    return AppBar(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: bgColor,
      leading:
          (!isHomePage &&
              showBackButton &&
              ModalRoute.of(context)?.isFirst == false)
          ? BuildBackButton(context: context, iconColor: iconColor)
          : leading,

      actions: actions,

      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: CustomText(
              title,
              color: titleColor,
              fontSize: AppResponsive.fontSize(context, 15),
              fontWeight: FontWeight.w800,
              maxLines: 1,
            ),
          ),
        ],
      ),

      bottom: PreferredSize(
        preferredSize: Size.fromHeight(AppResponsive.heightValue(context, 1)),
        child: Container(
          height: AppResponsive.heightValue(context, 1),
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                accentColor.withValues(alpha: .22),
                accentColor.withValues(alpha: .22),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TITLE LINE
  Widget _buildTitleLine(BuildContext context, Color color) {
    return Container(
      width: AppResponsive.widthValue(context, 3),
      height: AppResponsive.heightValue(context, 25),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 10)),
      ),
    );
  }
}

// BACK BUTTON
Widget BuildBackButton({
  required BuildContext context,
  required Color iconColor,
}) {
  return Padding(
    padding: EdgeInsets.only(
      right: AppResponsive.widthValue(context, 12),
      top: AppResponsive.heightValue(context, 10),
      bottom: AppResponsive.heightValue(context, 10),
    ),
    child: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1A2723)
            : const Color(0xFFEAF2F0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular( AppResponsive.radius(context, 14)),
          side: BorderSide(
            color: const Color(0xFF087F73).withValues(alpha: .14),
          ),
        ),
      ),
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: iconColor,
        size: AppResponsive.iconSize(context, 17),
      ),
      splashRadius: 20.r,
    ),
  );
}
