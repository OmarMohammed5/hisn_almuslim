// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:hisn_almuslim/features/quran/data/cubit/cubit/quran_khatma_cubit.dart';

// class CurrentPageWidget extends StatefulWidget {
//   final int currentPage;
//   final QuranKhatmaCubit cubit;

//   const CurrentPageWidget({    super.key,
//     required this.currentPage,
//     required this.cubit,
//   });

//   @override
//   State<CurrentPageWidget> createState() => _CurrentPageWidgetState();
// }

// class _CurrentPageWidgetState extends State<CurrentPageWidget> {
//   late TextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController(
//       text: widget.currentPage > 0 ? '${widget.currentPage}' : '',
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   int _getJuz(int page) {
//     const juzStartPages = [
//       1,
//       22,
//       42,
//       62,
//       82,
//       102,
//       121,
//       142,
//       162,
//       182,
//       202,
//       222,
//       242,
//       262,
//       282,
//       302,
//       322,
//       342,
//       362,
//       382,
//       402,
//       422,
//       442,
//       462,
//       482,
//       502,
//       522,
//       542,
//       562,
//       582,
//     ];
//     int juz = 1;
//     for (int i = 0; i < juzStartPages.length; i++) {
//       if (page >= juzStartPages[i])
//         juz = i + 1;
//       else
//         break;
//     }
//     return juz;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final juz = widget.currentPage > 0 ? _getJuz(widget.currentPage) : 0;
//     final percent = widget.currentPage > 0
//         ? (widget.currentPage / 604 * 100).toStringAsFixed(1)
//         : '0';

//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: isDark ? Colors.grey.shade900 : Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.07),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Title
//           Row(
//             children: [
//               Icon(
//                 Icons.menu_book_rounded,
//                 color: Colors.teal.shade700,
//                 size: 20.sp,
//               ),
//               Gap(8.w),
//               Text(
//                 'وصلت لفين؟',
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Cairo',
//                   color: Colors.teal.shade700,
//                 ),
//               ),
//             ],
//           ),
//           Gap(12.h),

//           // Button to enter the nuber of page
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _controller,
//                   keyboardType: TextInputType.number,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontFamily: 'Cairo', fontSize: 14.sp),
//                   decoration: InputDecoration(
//                     hintText: 'أدخل رقم الصفحة',
//                     hintStyle: TextStyle(fontFamily: 'Cairo', fontSize: 13.sp),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                       borderSide: BorderSide(color: Colors.teal.shade700),
//                     ),
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 10.h,
//                       horizontal: 12.w,
//                     ),
//                   ),
//                 ),
//               ),
//               Gap(8.w),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal.shade700,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   padding: EdgeInsets.symmetric(
//                     vertical: 12.h,
//                     horizontal: 16.w,
//                   ),
//                 ),
//                 onPressed: () {
//                   final page = int.tryParse(_controller.text);
//                   if (page != null && page >= 1 && page <= 604) {
//                     widget.cubit.updateCurrentPage(page);
//                     FocusScope.of(context).unfocus();
//                   }
//                 },
//                 child: Text(
//                   'حفظ',
//                   style: TextStyle(
//                     fontFamily: 'Cairo',
//                     fontSize: 14.sp,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           // Result
//           if (widget.currentPage > 0) ...[
//             Gap(16.h),
//             Container(
//               padding: EdgeInsets.all(12.w),
//               decoration: BoxDecoration(
//                 color: Colors.teal.shade50,
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: Column(
//                 children: [
//                   _infoRow('📄 الصفحة الحالية', '${widget.currentPage} / 604'),
//                   Divider(height: 16.h, color: Colors.teal.shade100),
//                   _infoRow('🗂️ الجزء', '$juz / 30'),
//                   Divider(height: 16.h, color: Colors.teal.shade100),
//                   _infoRow('✅ نسبة إتمامك', '$percent%'),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _infoRow(String label, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(fontFamily: 'Cairo', fontSize: 13.sp),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontFamily: 'Cairo',
//             fontSize: 13.sp,
//             fontWeight: FontWeight.bold,
//             color: Colors.teal.shade800,
//           ),
//         ),
//       ],
//     );
//   }
// }
