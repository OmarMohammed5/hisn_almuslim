import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/hadith/books/nawawi/data/cubit/hadith_cubit.dart';
import 'package:hisn_almuslim/features/hadith/books/nawawi/screen/hadith_nawawi.dart';
import 'package:hisn_almuslim/features/hadith/widgets/chapter_card.dart';
import 'package:hisn_almuslim/features/quran/widgets/search_field.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';

class FehresHadithNawawi extends StatefulWidget {
  const FehresHadithNawawi({super.key});

  @override
  State<FehresHadithNawawi> createState() => _FehresHadithNawawiState();
}

class _FehresHadithNawawiState extends State<FehresHadithNawawi> {
  String searchQuery = '';

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
            onChanged: (v) {
              setState(() {
                searchQuery = v;
              });
            },
            hint: 'ابحث عن حديث ...',
          ),
        ),
        body: BlocBuilder<HadithCubit, HadithState>(
          builder: (context, state) {
            if (state is HadithLoading) {
              return Center(
                child: CupertinoActivityIndicator(color: Colors.teal.shade700),
              );
            }
            if (state is HadithLoaded) {
              final hadiths = state.hadithList;
              final filteredHadiths = hadiths.where((hadith) {
                if (hadith.hadithContent.isEmpty) return false;

                final title = normalizeArabic(
                  hadith.hadithContent.last.title.toLowerCase(),
                );

                final query = normalizeArabic(searchQuery.toLowerCase());

                return title.contains(query);
              }).toList();

              return ListView.builder(
                padding: EdgeInsets.all(6.w),
                itemCount: filteredHadiths.length,
                itemBuilder: (context, index) {
                  final hadith = filteredHadiths[index];

                  return ChapterCard(
                    chapterId: hadith.id,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HadithNawawi(id: hadith.id),
                        ),
                      );
                    },
                    chapterTitle: hadith.hadithContent.isNotEmpty
                        ? hadith.hadithContent.last.title
                        : '',
                  );
                },
              );
            } else if (state is HadithError) {
              return Center(child: CustomText(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}



/*

 */