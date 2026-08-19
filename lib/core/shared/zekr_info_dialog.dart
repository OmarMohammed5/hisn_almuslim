// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
//
// import 'custom_text.dart';
//
// class ZekrInfoDialog {
//   const ZekrInfoDialog._();
//
//   /// Example:
//   /// ZekrInfoDialog.show(
//   ///   context,
//   ///   zekr: currentZekr,
//   ///   accentColor: Colors.teal,
//   ///   textColor: Colors.black87,
//   /// );
//   static Future<void> show(
//       BuildContext context, {
//         required Map<String, dynamic> zekr,
//         required Color accentColor,
//         required Color textColor,
//         String title = 'معلومات الذكر',
//       }) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     final dialogBgColor = isDark
//         ? const Color(0xFF1E1E1E)
//         : Colors.white;
//
//     // Read values safely.
//     final source = zekr['source']?.toString().trim() ?? '';
//     final count = zekr['count']?.toString().trim() ?? '';
//
//     return showDialog<void>(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           backgroundColor: dialogBgColor,
//
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.r),
//           ),
//
//           // =========================
//           // Title
//           // =========================
//
//           title: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8.w),
//                 decoration: BoxDecoration(
//                   color: accentColor.withValues(alpha: 0.12),
//                   borderRadius: BorderRadius.circular(10.r),
//                 ),
//                 child: Icon(
//                   Icons.book_outlined,
//                   color: accentColor,
//                   size: 22.sp,
//                 ),
//               ),
//
//               Gap(12.w),
//
//               Expanded(
//                 child: CustomText(
//                   title,
//                   color: textColor,
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//
//           // =========================
//           // Content
//           // =========================
//
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // =========================
//                 // Source
//                 // =========================
//
//                 if (source.isNotEmpty)
//                   _buildSourceSection(
//                     source: source,
//                     accentColor: accentColor,
//                     textColor: textColor,
//                   )
//                 else
//                   _buildEmptyInfoSection(),
//
//                 // =========================
//                 // Count
//                 // =========================
//
//                 if (count.isNotEmpty) ...[
//                   Gap(12.h),
//
//                   _buildCountSection(
//                     count: count,
//                     accentColor: accentColor,
//                     textColor: textColor,
//                   ),
//                 ],
//               ],
//             ),
//           ),
//
//           // =========================
//           // Close Button
//           // =========================
//
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext);
//               },
//
//               style: TextButton.styleFrom(
//                 backgroundColor:
//                 accentColor.withValues(alpha: 0.12),
//
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 24.w,
//                   vertical: 12.h,
//                 ),
//
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.r),
//                 ),
//               ),
//
//               child: CustomText(
//                 'إغلاق',
//                 color: accentColor,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14.sp,
//               ),
//             ),
//           ],
//
//           actionsPadding: EdgeInsets.only(
//             bottom: 16.h,
//             left: 16.w,
//             right: 16.w,
//           ),
//         );
//       },
//     );
//   }
//
//   // ============================================================
//   // Source Section
//   // ============================================================
//
//   static Widget _buildSourceSection({
//     required String source,
//     required Color accentColor,
//     required Color textColor,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(16.w),
//
//       decoration: BoxDecoration(
//         color: accentColor.withValues(alpha: 0.08),
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(
//           color: accentColor.withValues(alpha: 0.2),
//           width: 1.w,
//         ),
//       ),
//
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.menu_book_rounded,
//                 color: accentColor,
//                 size: 18.sp,
//               ),
//
//               Gap(8.w),
//
//               CustomText(
//                 'المصدر',
//                 color: accentColor,
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.bold,
//               ),
//             ],
//           ),
//
//           Gap(8.h),
//
//           Text(
//             source,
//             style: TextStyle(
//               fontSize: 15.sp,
//               height: 1.8.h,
//               fontWeight: FontWeight.w600,
//               fontFamily: 'Amiri Quran',
//               color: textColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // Empty Information Section
//   // ============================================================
//
//   static Widget _buildEmptyInfoSection() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(16.w),
//
//       decoration: BoxDecoration(
//         color: Colors.grey.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//
//       child: Row(
//         children: [
//           Icon(
//             Icons.info_outline,
//             color: Colors.grey,
//             size: 20.sp,
//           ),
//
//           Gap(12.w),
//
//           Expanded(
//             child: CustomText(
//               'لا توجد معلومات إضافية',
//               color: Colors.grey,
//               fontSize: 14.sp,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // Count Section
//   // ============================================================
//
//   static Widget _buildCountSection({
//     required String count,
//     required Color accentColor,
//     required Color textColor,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(12.w),
//
//       decoration: BoxDecoration(
//         color: accentColor.withValues(alpha: 0.08),
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.repeat_rounded,
//             color: accentColor,
//             size: 18.sp,
//           ),
//
//           Gap(8.w),
//
//           CustomText(
//             'عدد التكرار: ',
//             color: textColor,
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w600,
//           ),
//
//           CustomText(
//             '$count مرة',
//             color: accentColor,
//             fontSize: 15.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'custom_text.dart';

class ZekrInfoDialog {
  const ZekrInfoDialog._();

  /// Show information dialog for any Zekr.
  ///
  /// This dialog is independent from the data model.
  /// It only receives the values it needs to display.
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
            (isDark
                ? Colors.tealAccent.shade200
                : Colors.teal.shade700);

    final finalTextColor =
        textColor ??
            (isDark ? Colors.white : Colors.black87);

    final dialogBgColor = isDark
        ? const Color(0xFF1E1E1E)
        : Colors.white;

    // Safely handle nullable values.
    final safeSource = source?.trim() ?? '';
    final safeCount = count?.trim() ?? '';

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: dialogBgColor,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),

          // =========================
          // TITLE
          // =========================

          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: finalAccentColor.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.book_outlined,
                  color: finalAccentColor,
                  size: 22.sp,
                ),
              ),

              Gap(12.w),

              Expanded(
                child: CustomText(
                  title,
                  color: finalTextColor,
                  fontSize: 18.sp,
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
                    source: safeSource,
                    accentColor: finalAccentColor,
                    textColor: finalTextColor,
                  )
                else
                  _buildEmptyInfoSection(),

                // =========================
                // COUNT
                // =========================

                if (safeCount.isNotEmpty) ...[
                  Gap(12.h),

                  _buildCountSection(
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
                backgroundColor:
                finalAccentColor.withValues(
                  alpha: 0.12,
                ),

                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              child: CustomText(
                'إغلاق',
                color: finalAccentColor,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ],

          actionsPadding: EdgeInsets.only(
            bottom: 16.h,
            left: 16.w,
            right: 16.w,
          ),
        );
      },
    );
  }

  // ============================================================
  // SOURCE SECTION
  // ============================================================

  static Widget _buildSourceSection({
    required String source,
    required Color accentColor,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),

      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 1.w,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: accentColor,
                size: 18.sp,
              ),

              Gap(8.w),

              CustomText(
                'المصدر',
                color: accentColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),

          Gap(8.h),

          Text(
            source,
            style: TextStyle(
              fontSize: 15.sp,
              height: 1.8.h,
              fontWeight: FontWeight.w600,
              fontFamily: 'Amiri Quran',
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

  static Widget _buildEmptyInfoSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),

      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),

      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.grey,
            size: 20.sp,
          ),

          Gap(12.w),

          Expanded(
            child: CustomText(
              'لا توجد معلومات إضافية',
              color: Colors.grey,
              fontSize: 14.sp,
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
    required String count,
    required Color accentColor,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),

      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.repeat_rounded,
            color: accentColor,
            size: 18.sp,
          ),

          Gap(8.w),

          CustomText(
            'عدد التكرار: ',
            color: textColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),

          CustomText(
            '$count مرة',
            color: accentColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}