import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    required this.title,
    this.isHomePage = false,
    this.showBackButton = true,
    this.actions,
    this.subtitle,
  });

  final String title;
  final bool isHomePage;
  final bool showBackButton;
  final List<Widget>? actions;
  final String? subtitle;

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 65.h : 70.h);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isHomePage) {
      return _buildHomeAppBar(context, isDark);
    } else {
      return _buildRegularAppBar(context, isDark);
    }
  }

  AppBar _buildHomeAppBar(BuildContext context, bool isDark) {
    return AppBar(
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: isDark ? Color(0xFF0F1419) : Color(0xFFF5F7FA),
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: actions,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Color(0xFF1A4D4D).withValues(alpha: 0.1), Colors.transparent]
                : [
                    Colors.teal.shade50.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      title: Column(
        children: [
          Gap(10.h),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.teal.shade700, Colors.teal.shade600]
                    : [Colors.teal.shade500, Colors.teal.shade600],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.mosque, color: Colors.white, size: 24.sp),
          ),
          Gap(8.h),
          CustomText(
            title,
            color: isDark ? Colors.white : Color(0xFF1A1A2E),
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
          if (subtitle != null) ...[
            Gap(4.h),
            CustomText(
              subtitle!,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              fontSize: 12.sp,
            ),
          ],
        ],
      ),
    );
  }

  AppBar _buildRegularAppBar(BuildContext context, bool isDark) {
    return AppBar(
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: isDark ? Color(0xFF1A1A1A) : Colors.white,
      elevation: 0,
      leading:
          (!isHomePage &&
              showBackButton &&
              ModalRoute.of(context)?.isFirst == false)
          ? Container(
              margin: EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.teal.shade900.withValues(alpha: .2)
                        : Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.teal.shade700,
                    size: 18,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,

      actions: actions,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Container(
            width: 3,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.teal.shade600,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Flexible(
            child: CustomText(
              title,
              color: isDark ? Colors.white : Color(0xFF2D3748),
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              maxLines: 1,
            ),
          ),
          Container(
            width: 3,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.teal.shade600,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(
          height: 1,
          margin: EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.teal.shade400,
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
