// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../domain/entities/ayah_entity.dart';
// import '../domain/entities/surah_entity.dart';
//
// class AyahItem extends StatefulWidget {
//   final AyahEntity ayah;
//   final SurahEntity surah;
//   final bool isSelected;
//   final bool isBookmarked;
//   final VoidCallback onTap;
//   final VoidCallback? onBookmarkTap;
//   final ValueChanged<AyahEntity>? onPlayTap;
//
//   const AyahItem({
//     super.key,
//     required this.ayah,
//     required this.surah,
//     this.isSelected = false,
//     this.isBookmarked = false,
//     required this.onTap,
//     this.onBookmarkTap,
//     this.onPlayTap,
//   });
//
//   @override
//   State<AyahItem> createState() => _AyahItemState();
// }
//
// class _AyahItemState extends State<AyahItem> with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final isSajdah = widget.ayah.isSajdah;
//
//     return RepaintBoundary(
//       child: GestureDetector(
//         onTap: widget.onTap,
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
//           decoration: BoxDecoration(
//             color: widget.isSelected
//                 ? (isDark ? Colors.green[900]?.withOpacity(0.3) : Colors.green[50])
//                 : Colors.transparent,
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // الرقم
//               _buildAyahNumber(isDark, isSajdah),
//
//               SizedBox(width: 12.w),
//
//               // النص
//               Expanded(
//                 child: Text(
//                   widget.ayah.text,
//                   style: TextStyle(
//                     fontFamily: 'Uthmanic',
//                     fontSize: 22.sp,
//                     height: 1.8,
//                     color: isDark ? Colors.white.withOpacity(0.92) : const Color(0xFF2B2115),
//                   ),
//                   textAlign: TextAlign.justify,
//                   textDirection: TextDirection.rtl,
//                 ),
//               ),
//
//               // Bookmark indicator
//               if (widget.isBookmarked)
//                 Padding(
//                   padding: EdgeInsets.only(right: 4.w),
//                   child: Icon(
//                     Icons.bookmark,
//                     size: 16.sp,
//                     color: Colors.amber[700],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAyahNumber(bool isDark, bool isSajdah) {
//     return GestureDetector(
//       onTap: () {
//         // يمكن فتح الـ Bottom Sheet من هنا
//         widget.onTap();
//       },
//       child: Container(
//         width: 32.w,
//         height: 32.w,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: widget.isSelected
//                 ? (isDark ? _MushafColors.goldDark : _MushafColors.gold)
//                 : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
//             width: 1.2,
//           ),
//           color: widget.isSelected
//               ? (isDark ? _MushafColors.goldDark : _MushafColors.gold).withOpacity(0.18)
//               : Colors.transparent,
//         ),
//         child: Center(
//           child: Text(
//             _toArabicDigits(widget.ayah.numberInSurah),
//             style: TextStyle(
//               fontSize: 11.sp,
//               fontWeight: FontWeight.bold,
//               color: widget.isSelected
//                   ? (isDark ? _MushafColors.goldDark : _MushafColors.gold)
//                   : (isDark ? Colors.grey[400] : Colors.grey[600]),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ====== Helper Functions ======
//
// class _MushafColors {
//   static const paperLight = Color(0xFFFBF3E3);
//   static const paperLightDeep = Color(0xFFF3E6C8);
//   static const paperDark = Color(0xFF241F16);
//   static const paperDarkDeep = Color(0xFF2E271A);
//   static const gold = Color(0xFFB08D3F);
//   static const goldDark = Color(0xFFD9B96C);
// }
//
// String _toArabicDigits(int number) {
//   const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
//   const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
//   var text = number.toString();
//   for (var i = 0; i < western.length; i++) {
//     text = text.replaceAll(western[i], eastern[i]);
//   }
//   return text;
// }