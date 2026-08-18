// // lib/features/quran/presentation/pages/quran_bookmarks_page.dart
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../core/routing/app_routes.dart';
// import '../data/cubit/quran_cubit.dart';
// import '../data/cubit/quran_state.dart';
// import '../domain/entities/ayah_entity.dart';
//
// class QuranBookmarksPage extends StatefulWidget {
//   const QuranBookmarksPage({super.key});
//
//   @override
//   State<QuranBookmarksPage> createState() => _QuranBookmarksPageState();
// }
//
// class _QuranBookmarksPageState extends State<QuranBookmarksPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<QuranCubit>().loadBookmarks();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'العلامات',
//           style: TextStyle(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               // Refresh bookmarks
//               context.read<QuranCubit>().loadBookmarks();
//             },
//             icon: Icon(Icons.refresh, size: 22.sp),
//           ),
//         ],
//       ),
//       body: BlocBuilder<QuranCubit, QuranState>(
//         builder: (context, state) {
//           if (state is QuranLoading) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           if (state is BookmarksLoaded) {
//             if (state.bookmarks.isEmpty) {
//               return _buildEmptyState();
//             }
//
//             return ListView.builder(
//               padding: EdgeInsets.all(16.w),
//               itemCount: state.bookmarks.length,
//               itemBuilder: (context, index) {
//                 final ayah = state.bookmarks[index];
//                 return _buildBookmarkCard(ayah, index);
//               },
//             );
//           }
//
//           if (state is QuranError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.error_outline,
//                     size: 60.sp,
//                     color: Colors.red[300],
//                   ),
//                   SizedBox(height: 16.h),
//                   Text(
//                     state.message,
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   ElevatedButton(
//                     onPressed: () => context.read<QuranCubit>().loadBookmarks(),
//                     child: const Text('إعادة المحاولة'),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildBookmarkCard(AyahEntity ayah, int index) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final colors = [
//       Colors.red[300],
//       Colors.blue[300],
//       Colors.green[300],
//       Colors.orange[300],
//       Colors.purple[300],
//       Colors.pink[300],
//       Colors.teal[300],
//       Colors.amber[300],
//     ];
//
//     final color = colors[index % colors.length];
//
//     return Container(
//       margin: EdgeInsets.only(bottom: 12.h),
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: isDark ? Colors.grey[850] : Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(
//           color: color ?? Colors.grey[300]!,
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           // Bookmark number and remove button
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 onPressed: () {
//                   _showRemoveBookmarkDialog(ayah);
//                 },
//                 icon: Icon(
//                   Icons.delete_outline,
//                   size: 20.sp,
//                   color: Colors.red[300],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
//                 decoration: BoxDecoration(
//                   color: color?.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: Text(
//                   '#${index + 1}',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.bold,
//                     color: color,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 4.h),
//
//           // Ayah text
//           Text(
//             ayah.text,
//             style: TextStyle(
//               fontFamily: 'Uthmanic',
//               fontSize: 20.sp,
//               height: 1.8,
//               color: isDark ? Colors.white : Colors.black87,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 12.h),
//
//           // Actions
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildActionButton(
//                 icon: Icons.visibility,
//                 label: 'عرض',
//                 onTap: () {
//                   // TODO: Navigate to Surah with this Ayah
//                 },
//               ),
//               _buildActionButton(
//                 icon: Icons.copy,
//                 label: 'نسخ',
//                 onTap: () {
//                   // TODO: Copy ayah text
//                 },
//               ),
//               _buildActionButton(
//                 icon: Icons.share,
//                 label: 'مشاركة',
//                 onTap: () {
//                   // TODO: Share ayah
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8.r),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 18.sp, color: Colors.grey[600]),
//             SizedBox(width: 4.w),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.bookmark_border,
//             size: 80.sp,
//             color: Colors.grey[400],
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             'لا توجد علامات',
//             style: TextStyle(
//               fontSize: 20.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             'أضف علامات للآيات التي تريد تذكرها',
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(height: 24.h),
//           ElevatedButton.icon(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, AppRoutes.quranHome);
//             },
//             icon: const Icon(Icons.menu_book),
//             label: const Text('تصفح القرآن'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showRemoveBookmarkDialog(AyahEntity ayah) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('حذف العلامة'),
//         content: Text(
//           'هل أنت متأكد من حذف علامة الآية ${ayah.number}؟',
//           style: TextStyle(fontSize: 16.sp),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'إلغاء',
//               style: TextStyle(
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               // TODO: Remove bookmark
//               Navigator.pop(context);
//             },
//             child: Text(
//               'حذف',
//               style: TextStyle(
//                 color: Colors.red[300],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }