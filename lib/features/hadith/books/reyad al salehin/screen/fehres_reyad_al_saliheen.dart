import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/features/hadith/books/reyad%20al%20salehin/data/cubit/reyad_al_saliheen_cubit.dart';
import 'package:hisn_almuslim/features/hadith/books/reyad%20al%20salehin/screen/reyad_al_saliheen_details.dart';
import 'package:hisn_almuslim/features/hadith/widgets/chapter_card.dart';
import 'package:hisn_almuslim/features/quran/widgets/search_field.dart';

class FehresReyadAlSaliheen extends StatefulWidget {
  const FehresReyadAlSaliheen({super.key});

  @override
  State<FehresReyadAlSaliheen> createState() => _FehresReyadAlSaliheenState();
}

class _FehresReyadAlSaliheenState extends State<FehresReyadAlSaliheen> {
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
      body: BlocBuilder<ReyadAlSaliheenCubit, ReyadAlSaliheenState>(
        builder: (context, state) {
          if (state is ReyadAlSaliheenLoading) {
            return Center(
              child: CupertinoActivityIndicator(color: Colors.teal.shade700),
            );
          }

          if (state is ReyadAlSaliheenLoaded) {
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

                String getChapterTitle() {
                  final title = chapter.chapterTitle;

                  // لو العنوان null أو فاضي
                  if (title.trim().isEmpty) {
                    return ' الباب رقم  ${chapter.chapterId}';
                  }

                  // لو العنوان رقم بس
                  if (RegExp(r'^\d+$').hasMatch(title.trim())) {
                    return 'الباب رقم $title';
                  }

                  return title;
                }

                return Column(
                  children: [
                    ChapterCard(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.reyadAlSaliheenDetails , arguments: chapter);
                      },
                      chapterId: chapter.chapterId,
                      chapterTitle: getChapterTitle(),
                      count: chapter.hadiths.length,
                    ),
                  ],
                );
              },
            );
          }

          if (state is ReyadAlSaliheenError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
