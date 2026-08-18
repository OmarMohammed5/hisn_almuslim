// // lib/features/quran/presentation/pages/quran_search_page.dart
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../core/routing/app_routes.dart';
// import '../data/cubit/quran_cubit.dart';
// import '../data/cubit/quran_state.dart';
// import '../widgets/ayah_card.dart';
//
// class QuranSearchPage extends StatefulWidget {
//   final String? initialQuery;
//
//   const QuranSearchPage({super.key, this.initialQuery});
//
//   @override
//   State<QuranSearchPage> createState() => _QuranSearchPageState();
// }
//
// class _QuranSearchPageState extends State<QuranSearchPage> {
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   bool _isSearching = false;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
//       _searchController.text = widget.initialQuery!;
//       _performSearch(widget.initialQuery!);
//     }
//     _focusNode.requestFocus();
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           controller: _searchController,
//           focusNode: _focusNode,
//           autofocus: true,
//           decoration: InputDecoration(
//             hintText: 'ابحث في القرآن الكريم...',
//             hintStyle: TextStyle(
//               fontSize: 16.sp,
//               color: Colors.grey[500],
//             ),
//             border: InputBorder.none,
//             suffixIcon: _searchController.text.isNotEmpty
//                 ? IconButton(
//               icon: Icon(Icons.clear, size: 20.sp),
//               onPressed: () {
//                 _searchController.clear();
//                 setState(() {
//                   _isSearching = false;
//                 });
//                 context.read<QuranCubit>().clearSearch();
//               },
//             )
//                 : null,
//           ),
//           style: TextStyle(
//             fontSize: 16.sp,
//             color: isDark ? Colors.white : Colors.black87,
//           ),
//           onChanged: (value) {
//             setState(() {
//               _isSearching = value.isNotEmpty;
//             });
//             if (value.isEmpty) {
//               context.read<QuranCubit>().clearSearch();
//             }
//           },
//           onSubmitted: (value) {
//             if (value.isNotEmpty) {
//               _performSearch(value);
//             }
//           },
//         ),
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: Icon(Icons.arrow_back_ios_rounded, size: 18.sp),
//         ),
//         actions: [
//           if (_isSearching)
//             TextButton(
//               onPressed: () {
//                 _searchController.clear();
//                 setState(() {
//                   _isSearching = false;
//                 });
//                 context.read<QuranCubit>().clearSearch();
//               },
//               child: Text(
//                 'إلغاء',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: Colors.green[700],
//                 ),
//               ),
//             ),
//         ],
//       ),
//       body: BlocBuilder<QuranCubit, QuranState>(
//         builder: (context, state) {
//           // Search Results for Ayahs
//           if (state is SearchResultsLoaded) {
//             if (state.results.isEmpty) {
//               return _buildEmptyState(
//                 'لا توجد نتائج',
//                 'جرب كلمات أخرى',
//                 Icons.search_off,
//               );
//             }
//
//             return Column(
//               children: [
//                 // Results count
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//                   alignment: Alignment.centerRight,
//                   child: Text(
//                     'نتائج البحث: ${state.results.length}',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//                     itemCount: state.results.length,
//                     itemBuilder: (context, index) {
//                       final ayah = state.results[index];
//                       return Container(
//                         margin: EdgeInsets.only(bottom: 12.h),
//                         padding: EdgeInsets.all(12.w),
//                         decoration: BoxDecoration(
//                           color: isDark ? Colors.grey[850] : Colors.white,
//                           borderRadius: BorderRadius.circular(12.r),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 4,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             // Highlighted text with search match
//                             _buildHighlightedText(ayah.text, state.query),
//                             SizedBox(height: 8.h),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.pushNamed(
//                                       context,
//                                       AppRoutes.quranSurah,
//                                       arguments: {
//                                         'surahNumber': 1,
//                                         'ayahNumber': ayah.number,
//                                       },
//                                     );
//                                   },
//                                   child: Text(
//                                     'عرض في السورة',
//                                     style: TextStyle(
//                                       fontSize: 12.sp,
//                                       color: Colors.green[700],
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 8.w,
//                                     vertical: 4.h,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.green[100],
//                                     borderRadius: BorderRadius.circular(8.r),
//                                   ),
//                                   child: Text(
//                                     'الآية ${ayah.number}',
//                                     style: TextStyle(
//                                       fontSize: 12.sp,
//                                       color: Colors.green[800],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }
//
//           // Loading state
//           if (state is QuranLoading) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           // Error state
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
//                     onPressed: () {
//                       if (_searchController.text.isNotEmpty) {
//                         _performSearch(_searchController.text);
//                       }
//                     },
//                     child: const Text('إعادة المحاولة'),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           // Initial state - show search tips
//           return _buildEmptyState(
//             'ابحث في القرآن الكريم',
//             'اكتب كلمة أو آية للبحث',
//             Icons.search,
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildHighlightedText(String text, String query) {
//     final List<TextSpan> spans = [];
//     final String lowerText = text.toLowerCase();
//     final String lowerQuery = query.toLowerCase();
//     int startIndex = 0;
//
//     while (startIndex < text.length) {
//       final int index = lowerText.indexOf(lowerQuery, startIndex);
//       if (index == -1) {
//         spans.add(TextSpan(text: text.substring(startIndex)));
//         break;
//       }
//
//       if (index > startIndex) {
//         spans.add(TextSpan(
//           text: text.substring(startIndex, index),
//         ));
//       }
//
//       spans.add(TextSpan(
//         text: text.substring(index, index + query.length),
//         style: const TextStyle(
//           backgroundColor: Colors.yellow,
//           fontWeight: FontWeight.bold,
//         ),
//       ));
//
//       startIndex = index + query.length;
//     }
//
//     return RichText(
//       text: TextSpan(
//         children: spans,
//         style: TextStyle(
//           fontFamily: 'Uthmanic',
//           fontSize: 20.sp,
//           height: 1.8,
//           color: Theme.of(context).brightness == Brightness.dark
//               ? Colors.white
//               : Colors.black87,
//         ),
//       ),
//       textAlign: TextAlign.right,
//     );
//   }
//
//   Widget _buildEmptyState(String title, String subtitle, IconData icon) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: 80.sp,
//             color: Colors.grey[400],
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 20.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             subtitle,
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(height: 32.h),
//           // Search suggestions
//           _buildSearchSuggestions(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSearchSuggestions() {
//     return BlocBuilder<QuranCubit, QuranState>(
//       builder: (context, state) {
//         if (state is! QuranLoaded) return const SizedBox.shrink();
//
//         final suggestions = [
//           'الفاتحة',
//           'البقرة',
//           'Al-Fatiha',
//           'Al-Baqarah',
//           'آية الكرسي',
//         ];
//
//         return Wrap(
//           spacing: 8.w,
//           runSpacing: 8.h,
//           alignment: WrapAlignment.center,
//           children: suggestions.map((suggestion) {
//             return ActionChip(
//               label: Text(
//                 suggestion,
//                 style: TextStyle(fontSize: 13.sp),
//               ),
//               onPressed: () {
//                 _searchController.text = suggestion;
//                 _performSearch(suggestion);
//               },
//               backgroundColor: Colors.green[50],
//               side: BorderSide.none,
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
//
//   void _performSearch(String query) {
//     if (query.trim().isEmpty) return;
//
//     // Search in Ayahs
//     context.read<QuranCubit>().searchInAyahs(query);
//
//     // Also search in Surahs (optional)
//     context.read<QuranCubit>().searchSurahs(query);
//   }
// }