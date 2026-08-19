// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:hisn_almuslim/core/shared/custom_text.dart';
//
// class CustomCardWidget extends StatelessWidget {
//   const CustomCardWidget({
//     super.key,
//     required this.title,
//     required this.icon,
//     required this.onTap,
//   });
//
//   final String title;
//   final IconData icon;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final radius = BorderRadius.circular(20.r);
//
//     return Material(
//       color: Colors.transparent,
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           // height: 137.h,
//           decoration: BoxDecoration(
//             borderRadius: radius,
//             gradient: LinearGradient(
//               begin: Alignment.topRight,
//               end: Alignment.bottomLeft,
//               colors: isDark
//                   ? [
//                       Colors.teal.shade800.withOpacity(0.9),
//                       Colors.teal.shade900.withOpacity(0.2),
//                     ]
//                   : [Colors.teal.shade100, Colors.teal.shade50],
//             ),
//             // borderRadius: BorderRadius.circular(20.r),
//             border: Border.all(
//               color: isDark
//                   ? Colors.teal.shade700.withOpacity(0.4)
//                   : Colors.teal.shade200.withValues(alpha: 0.7),
//               width: 1.5,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.teal.shade700.withOpacity(0.15),
//                 blurRadius: 12.r,
//                 offset: Offset(0, 4.h),
//               ),
//             ],
//           ),
//           child: Center(
//             child: // Main Content
//             Padding(
//               padding: EdgeInsets.all(12.w),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(8.w),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: isDark
//                             ? [
//                                 Colors.teal.shade600.withValues(alpha: 0.8),
//                                 Colors.teal.shade700.withValues(alpha: 0.9),
//                               ]
//                             : [Colors.teal.shade500, Colors.teal.shade600],
//                       ),
//                     ),
//                     child: Icon(
//                       icon,
//                       size: 20.sp,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//
//                   Gap(17.h),
//                   CustomText(
//                     title,
//                     fontSize: 11.5.sp,
//                     fontWeight: FontWeight.bold,
//                     maxLines: 2,
//                     textAlign: TextAlign.center,
//                     color: isDark ? Colors.white : Colors.black87,
//                   ),
//
//                   Gap(10.h),
//
//                   // Discover >
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 6.w,
//                       vertical: 5.h,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(18.r),
//                       color: Colors.teal.withValues(alpha: 0.2),
//                       border: Border.all(
//                         color: Colors.teal.withValues(alpha: 0.3),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         CustomText(
//                           'استكشف',
//                           fontSize: 7.sp,
//                           fontWeight: FontWeight.w600,
//                           color: isDark
//                               ? Colors.teal.shade300
//                               : Colors.teal.shade700,
//                         ),
//                         Gap(3.w),
//                         Icon(
//                           Icons.arrow_forward_ios,
//                           size: 7.sp,
//                           color: isDark
//                               ? Colors.teal.shade300
//                               : Colors.teal.shade700,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
    this.badgeText,
    this.image,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final String? subtitle;
  final String? badgeText;
  final String? image;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(20.r);

    final bgColor = isDark ? const Color(0xFF0F171A) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.grey.shade100;
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.5)
        : Colors.grey.shade300.withValues(alpha: 0.4);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark
        ? Colors.white.withValues(alpha: 0.4)
        : Colors.grey.shade500;

    final bool hasBadge = badgeText != null && badgeText!.isNotEmpty;

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        splashColor: Colors.teal.withValues(alpha: 0.06),
        highlightColor: Colors.teal.withValues(alpha: 0.03),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: radius,
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 12.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon Row
                    Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.teal.shade400.withValues(alpha: 0.12),
                                Colors.teal.shade600.withValues(alpha: 0.04),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: Colors.teal.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Icon(
                            icon,
                            size: 20.sp,
                            color: isDark
                                ? Colors.teal.shade300
                                : Colors.teal.shade600,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Title
                        Expanded(
                          child: CustomText(
                            title,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                            maxLines: 2,
                          ),
                        ),
                        // Badge
                        if (hasBadge)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.amber.shade400,
                                  Colors.amber.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: CustomText(
                              badgeText!,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                    Gap(10.h),
                    // Subtitle
                    if (subtitle != null)
                      CustomText(
                        subtitle!,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: subTextColor,
                        maxLines: 1,
                      ),
                    Gap(12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Progress Dots
                        Row(
                          children: List.generate(
                            4,
                                (index) => Container(
                              width: 6.w,
                              height: 6.w,
                              margin: EdgeInsets.only(right: 4.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == 0
                                    ? Colors.teal.shade400
                                    : isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                        // Arrow Button
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: Colors.teal.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 14.sp,
                            color: isDark
                                ? Colors.teal.shade300
                                : Colors.teal.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}