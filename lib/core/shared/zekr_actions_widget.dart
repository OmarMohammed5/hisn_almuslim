import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hisn_almuslim/core/helpers/share_helper.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'custom_snack_bar.dart';

class ZekrActionsWidget extends StatelessWidget {
  final Map<String, dynamic> zekr;
  final int currentIndex;
  final PageController pageController;
  final int total;

  const ZekrActionsWidget({
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
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: isDark
            ? Border.all(color: Colors.grey.shade800, width: 1)
            : Border.all(color: Colors.grey.shade200, width: 1),
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
              Clipboard.setData(ClipboardData(text: zekr['text']));
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
            children: [
              // Previous Button
              _compactNavButton(
                icon: Icons.arrow_back_ios_rounded,
                onTap: () => _goToPrevious(context),
                isDark: isDark,
                accentColor: accentColor,
                isDisabled: currentIndex == 0,
              ),

              const SizedBox(width: 12),

              // Counter
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      '${currentIndex + 1}',
                      color: accentColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      ' / ',
                      color: textColor.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                    CustomText(
                      '$total',
                      color: textColor.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

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
              await ShareHelper.shareAsImage(context, zekr['text']);
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDisabled
                ? Colors.grey.withValues(alpha: 0.1)
                : accentColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDisabled
                  ? Colors.grey.withValues(alpha: 0.2)
                  : accentColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: isDisabled
                ? Colors.grey.withValues(alpha: 0.4)
                : accentColor,
            size: 18,
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
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(icon, color: accentColor, size: 20),
        ),
      ),
    );
  }
}
