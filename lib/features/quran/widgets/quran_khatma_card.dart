// import 'package:flutter/material.dart';
// import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:hisn_almuslim/features/quran/screen/quran_khatma_screen.dart';
// import 'package:hisn_almuslim/shared/custom_text.dart';

// class QuranKhatmaCard extends StatelessWidget {
//   const QuranKhatmaCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => QuranKhatmaScreen()),
//         );
//       },
//       child: Container(
//         margin: EdgeInsets.all(16.w),
//         padding: EdgeInsets.all(16.w),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topRight,
//             end: Alignment.bottomLeft,
//             colors: isDark
//                 ? [
//                     Colors.teal.shade900.withOpacity(0.4),
//                     Colors.teal.shade800.withOpacity(0.3),
//                   ]
//                 : [Colors.teal.shade100, Colors.teal.shade50],
//           ),
//           borderRadius: BorderRadius.circular(20.r),
//           border: Border.all(
//             color: isDark
//                 ? Colors.teal.shade700.withOpacity(0.4)
//                 : Colors.teal.shade300,
//             width: 1.5,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.teal.shade700.withOpacity(0.15),
//               blurRadius: 12.r,
//               offset: Offset(0, 4.h),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Icon Section
//             Container(
//               padding: EdgeInsets.all(12.w),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Colors.teal.shade700, Colors.teal.shade600],
//                 ),
//                 borderRadius: BorderRadius.circular(16.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.teal.shade700.withOpacity(0.3),
//                     blurRadius: 8.r,
//                     offset: Offset(0, 2.h),
//                   ),
//                 ],
//               ),
//               child: Icon(
//                 FlutterIslamicIcons.solidQuran2,
//                 size: 25.sp,
//                 color: Colors.white,
//               ),
//             ),

//             Gap(16.w),

//             // Text Content
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomText(
//                     'ختمة القرآن الكريم',
//                     fontSize: 13.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   Gap(10.h),
//                   CustomText(
//                     'تابع تقدمك في ختم القرآن الكريم',
//                     fontSize: 11.sp,
//                     color: Colors.grey.shade600,
//                   ),
//                 ],
//               ),
//             ),

//             // Arrow Icon
//             Icon(
//               Icons.arrow_forward_ios,
//               size: 18.sp,
//               color: Colors.teal.shade700,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
