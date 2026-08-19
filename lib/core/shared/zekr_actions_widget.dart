import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/helpers/share_helper.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import 'custom_snack_bar.dart';

class ZekrActionsWidget extends StatelessWidget {

  final String zekrText;

  final int currentIndex;
  final PageController pageController;
  final int total;

  const ZekrActionsWidget({
    super.key,
    required this.zekrText,
    required this.currentIndex,
    required this.total,
    required this.pageController,
  });

  void _goToNext(BuildContext context) {
    if (currentIndex < total - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

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

    final cardColor = isDark
        ? const Color(0xFF1C2227)
        : Colors.white;

    final accentColor = isDark
        ? Colors.tealAccent.shade200
        : Colors.teal.shade700;

    final textColor = isDark
        ? Colors.white
        : const Color(0xFF1A1A1A);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 8.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.grey.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // =========================
          // COPY
          // =========================

          _buildActionButton(
            context: context,
            icon: Icons.copy_rounded,
            isDark: isDark,
            accentColor: accentColor,
            onTap: () {
              Clipboard.setData(
                ClipboardData(text: zekrText),
              );

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

          // =========================
          // NAVIGATION
          // =========================

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNavButton(
                icon: Icons.arrow_back_ios_rounded,
                onTap: () => _goToPrevious(context),
                isDark: isDark,
                accentColor: accentColor,
                isDisabled: currentIndex == 0,
              ),

              Gap(8.w),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: accentColor.withOpacity(0.2),
                    width: 1,
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
                      color: textColor.withOpacity(0.4),
                      fontSize: 12.sp,
                    ),

                    CustomText(
                      '$total',
                      color: textColor.withOpacity(0.6),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),

              Gap(8.w),

              _buildNavButton(
                icon: Icons.arrow_forward_ios_rounded,
                onTap: () => _goToNext(context),
                isDark: isDark,
                accentColor: accentColor,
                isDisabled: currentIndex == total - 1,
              ),
            ],
          ),

          // =========================
          // SHARE
          // =========================

          _buildActionButton(
            context: context,
            icon: Icons.share_outlined,
            isDark: isDark,
            accentColor: accentColor,
            onTap: () async {
              await ShareHelper.shareAsImage(
                context,
                zekrText,
                category: "أَذْكَارُ الْمَسَاءِ",
                isDark: isDark,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required bool isDark,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        splashColor: accentColor.withOpacity(0.3),
        highlightColor: accentColor.withOpacity(0.15),
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: accentColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: accentColor,
            size: 20.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
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
        borderRadius: BorderRadius.circular(12.r),
        splashColor: isDisabled
            ? Colors.transparent
            : accentColor.withOpacity(0.3),
        highlightColor: isDisabled
            ? Colors.transparent
            : accentColor.withOpacity(0.15),
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: isDisabled
                ? Colors.grey.withOpacity(0.1)
                : accentColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDisabled
                  ? Colors.grey.withOpacity(0.15)
                  : accentColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: isDisabled
                ? Colors.grey.withOpacity(0.4)
                : accentColor,
            size: 18.sp,
          ),
        ),
      ),
    );
  }
}