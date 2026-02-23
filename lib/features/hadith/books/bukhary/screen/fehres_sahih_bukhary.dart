import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/hadith/books/bukhary/data/cubit/chapters_cubit.dart';
import 'package:hisn_almuslim/features/hadith/books/bukhary/screen/sahih_bukhary_details.dart';
import 'package:hisn_almuslim/features/hadith/widgets/chapter_card.dart';
import 'package:hisn_almuslim/features/quran/widgets/search_field.dart';

class FehresSahihBukhary extends StatefulWidget {
  const FehresSahihBukhary({super.key});

  @override
  State<FehresSahihBukhary> createState() => _FehresSahihBukharyState();
}

class _FehresSahihBukharyState extends State<FehresSahihBukhary> {
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
        body: BlocBuilder<ChaptersCubit, ChaptersState>(
          builder: (context, state) {
            if (state is ChaptersLoading) {
              return Center(
                child: CupertinoActivityIndicator(color: Colors.teal.shade700),
              );
            }

            if (state is ChaptersLoaded) {
              /// 🔍 Filter chapters
              final filteredChapters = state.chapters.where((chapter) {
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
                        chapterId: chapter.chapterId,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SahihBukharyDetails(
                                chapterSahihBukhary: chapter,
                              ),
                            ),
                          );
                        },
                        chapterTitle: chapter.chapterTitle,
                        count: chapter.hadithsCount,
                      ),
                    ],
                  );
                },
              );
            }

            if (state is ChaptersError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
