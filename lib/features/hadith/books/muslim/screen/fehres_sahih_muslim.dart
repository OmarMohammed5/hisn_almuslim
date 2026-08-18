import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/hadith/books/muslim/data/cubit/sahih_muslim_cubit.dart';
import 'package:hisn_almuslim/features/hadith/books/muslim/screen/sahih_muslim_details.dart';
import 'package:hisn_almuslim/features/hadith/widgets/chapter_card.dart';
import 'package:hisn_almuslim/features/quran/widgets/search_field.dart';

import '../../../../../core/routing/app_routes.dart';

class FehresSahihMuslim extends StatefulWidget {
  const FehresSahihMuslim({super.key});

  @override
  State<FehresSahihMuslim> createState() => _FehresSahihMuslimState();
}

class _FehresSahihMuslimState extends State<FehresSahihMuslim> {
  /// 🔍 Search text
  String searchQuery = "";

  /// Normalize Arabic for better search
  String normalizeArabic(String text) {
    return text
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي');
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: SearchField(
          hint: 'ابحث في الأبواب ...',
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
      ),
      body: BlocBuilder<SahihMuslimCubit, SahihMuslimState>(
        builder: (context, state) {
          if (state is SahihMuslimLoading) {
            return Center(
              child: CupertinoActivityIndicator(color: Colors.teal.shade700),
            );
          }

          if (state is SahihMuslimLoaded) {
            /// 🔍 Filter chapters
            final filteredChapters = state.hadiths.where((chapter) {
              if (searchQuery.isEmpty) return true;

              final title = normalizeArabic(
                chapter.chapterTitle.toLowerCase(),
              );
              final query = normalizeArabic(searchQuery.toLowerCase());

              return title.contains(query);
            }).toList();

            if (filteredChapters.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد نتائج',
                  style: TextStyle(fontFamily: "Cairo", fontSize: 16.sp),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(6.w),
              itemCount: filteredChapters.length,
              itemBuilder: (context, index) {
                final chapter = filteredChapters[index];
                return Column(
                  children: [
                    ChapterCard(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.sahihMuslimDetails , arguments: chapter);
                      },
                      chapterId: chapter.chapterId,
                      chapterTitle: chapter.chapterTitle,
                      count: chapter.chapterCount,
                    ),
                  ],
                );
              },
            );
          }

          if (state is SahihMuslimError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
