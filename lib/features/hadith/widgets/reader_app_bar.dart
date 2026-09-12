import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
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
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [Color(0xFF0F1419), Color(0xFF1A2A3A)]
              : [Colors.teal.shade100, Colors.white],
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
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.widthValue(context, 8),
            vertical: AppResponsive.heightValue(context, 8),
          ),
          child: Row(
            children: [
              // Back Button
              _buildBackButton(context, isDark),

              Gap(AppResponsive.widthValue(context, 8)),

              // Title Section
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 17),
                        fontWeight: FontWeight.w700,
                        fontFamily: "QuranFont",
                        color: isDark ? Colors.white : Color(0xFF1A1A2E),
                        height: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Gap(AppResponsive.heightValue(context, 2)),
                    // Page indicator with elegant design
                    if (isUiVisible) _buildPageIndicator(context, isDark),
                  ],
                ),
              ),

              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(
                    context: context,
                    icon: Icons.text_fields_rounded,
                    onPressed: onFontTap,
                    isDark: isDark,
                  ),
                  Gap(AppResponsive.widthValue(context, 4)),
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
        padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.blue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, 12),
          ),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.blue.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: AppResponsive.iconSize(context, 18),
          color: isDark ? Colors.white : Color(0xFF1A1A2E),
        ),
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 10),
        vertical: AppResponsive.heightValue(context, 3),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.withValues(alpha: 0.1),
            Colors.blue.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 8)),
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
            size: AppResponsive.iconSize(context, 12),
            color: isDark ? Colors.teal.shade300 : Colors.teal.shade600,
          ),
          Gap(AppResponsive.widthValue(context, 4)),
          Text(
            '${currentPage + 1} / $totalCount',
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 11),
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
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isDark,
    Color? color,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 2),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 10)),
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
          size: AppResponsive.iconSize(context, 20),
          color: color ?? (isDark ? Colors.white : Color(0xFF1A1A2E)),
        ),
        onPressed: onPressed,
        padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
        constraints: BoxConstraints(
          minWidth: AppResponsive.widthValue(context, 36),
          minHeight: AppResponsive.heightValue(context, 36),
        ),
        splashRadius: AppResponsive.radius(context, 20),
      ),
    );
  }
}
