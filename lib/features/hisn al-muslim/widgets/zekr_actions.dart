import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/models/content_item.dart';
import 'package:hisn_almuslim/core/helpers/share_helper.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../core/shared/custom_snack_bar.dart';

class ZekrActions extends StatelessWidget {
  final Zekr zekr;
  final int currentIndex;
  final PageController pageController;
  final int total;

  const ZekrActions({
    super.key,
    required this.zekr,
    required this.currentIndex,
    required this.total,
    required this.pageController,
  });

  // Go to next page
  void _goToNext(BuildContext context) {
    if (currentIndex < total - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Go to previous page
  void _goToPrevious(BuildContext context) {
    if (currentIndex > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme-aware colors
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final accentColor = isDark
        ? Colors.tealAccent.shade200
        : Colors.teal.shade700;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: isDark
            ? Border.all(color: Colors.grey.shade800, width: 1.w)
            : Border.all(color: Colors.grey.shade200, width: 1.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Copy Button
          _compactActionButton(
            icon: Icons.copy_rounded,
            isDark: isDark,
            accentColor: accentColor,
            onTap: () {
              Clipboard.setData(ClipboardData(text: zekr.title));
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(
                  "تم نسخ الذكر بنجاح",
                  Icons.check_circle,
                  context,
                  lightColor: Colors.teal,
                  darkColor: Colors.teal.shade400,
                ),
              );
            },
          ),

          // Navigation Section
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12.w,
            children: [
              // Previous Button
              _compactNavButton(
                icon: Icons.arrow_back_ios_rounded,
                onTap: () => _goToPrevious(context),
                isDark: isDark,
                accentColor: accentColor,
                isDisabled: currentIndex == 0,
              ),

              // Counter
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.2),
                    width: 1.w,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      '${currentIndex + 1}',
                      color: accentColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      ' / ',
                      color: textColor.withValues(alpha: 0.4),
                      fontSize: 12.sp,
                    ),
                    CustomText(
                      '$total',
                      color: textColor.withValues(alpha: 0.6),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),

              // Next Button
              _compactNavButton(
                icon: Icons.arrow_forward_ios_rounded,
                onTap: () => _goToNext(context),
                isDark: isDark,
                accentColor: accentColor,
                isDisabled: currentIndex == total - 1,
              ),
            ],
          ),

          // Share Button
          _compactActionButton(
            icon: Icons.share_outlined,
            isDark: isDark,
            accentColor: accentColor,
            onTap: () async {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              ShareHelper.shareAsImage(context, zekr.content[currentIndex].text, isDark: isDark ,category: zekr.title);
            },
          ),
        ],
      ),
    );
  }

  Widget _compactNavButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    required Color accentColor,
    bool isDisabled = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: isDisabled
                ? Colors.grey.withValues(alpha: 0.1)
                : accentColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isDisabled
                  ? Colors.grey.withValues(alpha: 0.2)
                  : accentColor.withValues(alpha: 0.2),
              width: 1.w,
            ),
          ),
          child: Icon(
            icon,
            color: isDisabled
                ? Colors.grey.withValues(alpha: 0.4)
                : accentColor,
            size: 18.sp,
          ),
        ),
      ),
    );
  }

  Widget _compactActionButton({
    required IconData icon,
    required bool isDark,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.2),
              width: 1.w,
            ),
          ),
          child: Icon(icon, color: accentColor, size: 20.sp),
        ),
      ),
    );
  }
}
