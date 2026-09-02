import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

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
    final backgroundColor = isDark
        ? const Color(0xFF111614)
        : const Color(0xFFF8FAF9);

    final titleColor = isDark
        ? const Color(0xFFF1F5F3)
        : const Color(0xFF1D2925);

    final accentColor = isDark
        ? const Color(0xFF63DCC6)
        : const Color(0xFF087F73);

    return AppBar(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,

      leading: leading,
      actions: actions,

      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (subtitle == null) SizedBox(height: 3.h),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitleLine(accentColor),

              SizedBox(width: 12.w),

              CustomText(
                title,
                color: titleColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                maxLines: 1,
              ),

              SizedBox(width: 12.w),

              _buildTitleLine(accentColor),
            ],
          ),

          if (subtitle != null) ...[
            SizedBox(height: 4.h),

            CustomText(
              subtitle!,
              color: isDark ? const Color(0xFF929D99) : const Color(0xFF7D8985),
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              maxLines: 1,
            ),
          ],
        ],
      ),

      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.h),
        child: Container(
          height: 1.h,
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: .16),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }

  AppBar _buildRegularAppBar(BuildContext context, bool isDark) {
    final backgroundColor = isDark
        ? const Color(0xFF111614)
        : const Color(0xFFF8FAF9);

    final titleColor = isDark
        ? const Color(0xFFF1F5F3)
        : const Color(0xFF202A27);

    final accentColor = isDark
        ? const Color(0xFF63DCC6)
        : const Color(0xFF087F73);

    final iconColor = isDark
        ? const Color(0xFFE5ECE9)
        : const Color(0xFF26322F);

    return AppBar(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor,
      leading:
          (!isHomePage &&
              showBackButton &&
              ModalRoute.of(context)?.isFirst == false)
          ? _buildBackButton(context: context, iconColor: iconColor)
          : leading,

      actions: actions,

      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: CustomText(
              title,
              color: titleColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              maxLines: 1,
            ),
          ),
        ],
      ),

      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.h),
        child: Container(
          height: 1.h,
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
  Widget _buildTitleLine(Color color) {
    return Container(
      width: 3.w,
      height: 25.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }

  // BACK BUTTON
  Widget _buildBackButton({
    required BuildContext context,
    required Color iconColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: 12.w, top: 10.h, bottom: 10.h),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1A2723)
              : const Color(0xFFEAF2F0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
            side: BorderSide(
              color: const Color(0xFF087F73).withValues(alpha: .14),
            ),
          ),
        ),
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: iconColor,
          size: 17.sp,
        ),
        splashRadius: 20.r,
      ),
    );
  }
}
