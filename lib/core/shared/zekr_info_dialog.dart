import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import '../responsive/app_responsive.dart';

import 'custom_text.dart';

class ZekrInfoDialog {
  const ZekrInfoDialog._();

  static Future<void> show(
    BuildContext context, {
    String? source,
    String? count,
    Color? accentColor,
    Color? textColor,
    String title = 'معلومات الذكر',
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final finalAccentColor =
        accentColor ??
        (isDark ? Colors.tealAccent.shade200 : Colors.teal.shade700);

    final finalTextColor =
        textColor ?? (isDark ? Colors.white : Colors.black87);

    final dialogBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    // Safely handle nullable values.
    final safeSource = source?.trim() ?? '';
    final safeCount = count?.trim() ?? '';

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: dialogBgColor,
          insetPadding: EdgeInsets.symmetric(
            horizontal: AppResponsive.widthValue(context, 24),
            vertical: AppResponsive.heightValue(context, 24),
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, 20),
            ),
          ),

          // =========================
          // TITLE
          // =========================
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
                decoration: BoxDecoration(
                  color: AppColors.kPrimary,
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 10),
                  ),
                ),
                child: Icon(
                  Icons.book_outlined,
                  color: Colors.white,
                  size: AppResponsive.iconSize(context, 22),
                ),
              ),

              Gap(AppResponsive.widthValue(context, 12)),

              Expanded(
                child: CustomText(
                  title,
                  color: finalTextColor,
                  fontSize: AppResponsive.fontSize(context, 13),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // =========================
          // CONTENT
          // =========================
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================
                // SOURCE
                // =========================
                if (safeSource.isNotEmpty)
                  _buildSourceSection(
                    context: context,
                    source: safeSource,
                    accentColor: finalAccentColor,
                    textColor: finalTextColor,
                  )
                else
                  _buildEmptyInfoSection(context),

                // =========================
                // COUNT
                // =========================
                if (safeCount.isNotEmpty) ...[
                  Gap(AppResponsive.heightValue(context, 16)),

                  _buildCountSection(
                    context: context,
                    count: safeCount,
                    accentColor: finalAccentColor,
                    textColor: finalTextColor,
                  ),
                ],
              ],
            ),
          ),

          // =========================
          // ACTIONS
          // =========================
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              style: TextButton.styleFrom(
                backgroundColor: AppColors.kPrimary,

                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.widthValue(context, 24),
                  vertical: 12,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 10),
                  ),
                ),
              ),

              child: CustomText(
                'إغلاق',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: AppResponsive.fontSize(context, 11),
              ),
            ),
          ],

          actionsPadding: EdgeInsets.only(
            bottom: AppResponsive.heightValue(context, 16),
            left: AppResponsive.widthValue(context, 16),
            right: AppResponsive.widthValue(context, 16),
          ),
        );
      },
    );
  }

  // ============================================================
  // SOURCE SECTION
  // ============================================================

  static Widget _buildSourceSection({
    required BuildContext context,
    required String source,
    required Color accentColor,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.widthValue(context, 16)),

      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        border: Border.all(color: accentColor.withValues(alpha: 0.2), width: 1),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: accentColor,
                size: AppResponsive.iconSize(context, 18),
              ),

              Gap(AppResponsive.widthValue(context, 8)),

              CustomText(
                'المصدر',
                color: accentColor,
                fontSize: AppResponsive.fontSize(context, 13),
                fontWeight: FontWeight.bold,
              ),
            ],
          ),

          Gap(8),

          Text(
            source,
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 15),
              height: AppResponsive.heightValue(context, 1.8),
              fontWeight: FontWeight.w600,
              fontFamily: 'Noon',
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY INFORMATION SECTION
  // ============================================================

  static Widget _buildEmptyInfoSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.widthValue(context, 16)),

      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
      ),

      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.grey,
            size: AppResponsive.iconSize(context, 20),
          ),

          Gap(AppResponsive.widthValue(context, 12)),

          Expanded(
            child: CustomText(
              'لا توجد معلومات إضافية',
              color: Colors.grey,
              fontSize: AppResponsive.fontSize(context, 14),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COUNT SECTION
  // ============================================================

  static Widget _buildCountSection({
    required BuildContext context,
    required String count,
    required Color accentColor,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.widthValue(context, 12)),

      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.repeat_rounded,
            color: accentColor,
            size: AppResponsive.iconSize(context, 18),
          ),

          Gap(AppResponsive.widthValue(context, 8)),

          CustomText(
            'عدد التكرار: ',
            color: textColor,
            fontSize: AppResponsive.fontSize(context, 12),
            fontWeight: FontWeight.w600,
          ),

          CustomText(
            '$count مرة',
            color: accentColor,
            fontSize: AppResponsive.fontSize(context, 12),
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
