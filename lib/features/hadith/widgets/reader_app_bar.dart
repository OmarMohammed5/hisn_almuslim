import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ReaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int totalCount;
  final int currentPage;
  final VoidCallback? onFontTap;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onShareTap;
  final bool isUiVisible;
  final bool showBookmark;
  final bool isBookmarked;

  const ReaderAppBar({
    super.key,
    required this.title,
    required this.totalCount,
    required this.currentPage,
    this.onFontTap,
    this.onBookmarkTap,
    this.onShareTap,
    this.isUiVisible = true,
    this.showBookmark = true,
    this.isBookmarked = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(70.h);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
            Color(0xFF0F1419),
            Color(0xFF1A2A3A),
          ]
              : [
            Colors.teal.shade100,
            Colors.white,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.blue.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            children: [
              // Back Button
              _buildBackButton(context, isDark),

              Gap(8.w),

              // Title Section
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: "QuranFont",
                        color: isDark ? Colors.white : Color(0xFF1A1A2E),
                        height: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Gap(2.h),
                    // Page indicator with elegant design
                    if (isUiVisible)
                      _buildPageIndicator(isDark),
                  ],
                ),
              ),

              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(
                    icon: Icons.text_fields_rounded,
                    onPressed: onFontTap,
                    isDark: isDark,
                  ),
                  Gap(4.w),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.blue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.blue.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18.sp,
          color: isDark ? Colors.white : Color(0xFF1A1A2E),
        ),
      ),
    );
  }

  Widget _buildPageIndicator(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.withValues(alpha: 0.1),
            Colors.blue.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Colors.teal.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 12.sp,
            color: isDark ? Colors.teal.shade300 : Colors.teal.shade600,
          ),
          Gap(4.w),
          Text(
            '${currentPage + 1} / $totalCount',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              fontFamily: "Cairo",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isDark,
    Color? color,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.blue.withValues(alpha: 0.05),
          width: 0.5,
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 20.sp,
          color: color ?? (isDark ? Colors.white : Color(0xFF1A1A2E)),
        ),
        onPressed: onPressed,
        padding: EdgeInsets.all(8.w),
        constraints: BoxConstraints(minWidth: 36.w, minHeight: 36.h),
        splashRadius: 20.r,
      ),
    );
  }
}