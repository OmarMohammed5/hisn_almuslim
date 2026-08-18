// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
//
// class ZekrContentWidget extends StatelessWidget {
//   final Map<String, dynamic> zekr;
//   final double fontSize;
//   const ZekrContentWidget({
//     super.key,
//     required this.zekr,
//     required this.fontSize,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return SingleChildScrollView(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
//         decoration: BoxDecoration(
//           color: isDark ? const Color(0xff1E1E1E) : Colors.white,
//           borderRadius: BorderRadius.circular(20.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.06),
//               blurRadius: 12,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             /// Decorative line
//             Container(
//               width: 60.w,
//               height: 4.h,
//               decoration: BoxDecoration(
//                 color: Colors.teal,
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//             ),
//
//             Gap(20.h),
//
//             /// Zekr Text
//             Text(
//               "${zekr['text']}",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: "Noon",
//                 fontSize: fontSize.sp,
//                 fontWeight: FontWeight.w700,
//                 height: 2.h,
//               ),
//             ),
//
//             Gap(32.h),
//
//             /// Fadl Section
//             if (zekr['fadl'].isNotEmpty) ...[
//               Divider(
//                 thickness: 0.8,
//                 color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
//               ),
//
//               Gap(16.h),
//
//               Container(
//                 padding: EdgeInsets.all(14.w),
//                 decoration: BoxDecoration(
//                   color: isDark
//                       ? Colors.teal.withOpacity(0.08)
//                       : Colors.teal.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(14.r),
//                 ),
//                 child: Text(
//                   "الفضل: ${zekr['fadl']}",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 13.5.sp,
//                     height: 1.6.h,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.teal.shade700,
//                     fontFamily: "Cairo",
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
