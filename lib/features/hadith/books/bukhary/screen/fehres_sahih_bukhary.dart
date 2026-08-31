import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/hadith/books/bukhary/data/cubit/chapters_cubit.dart';
import 'package:hisn_almuslim/features/hadith/widgets/chapter_card.dart';
import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/shared/custom_text.dart';
import '../../../../../core/shared/re_build_scroll_To_Top.dart';
import '../../../../../core/shared/search_field.dart';
import '../../../../../core/utils/arabic_search_utils.dart';

class FehresSahihBukhary extends StatefulWidget {
  const FehresSahihBukhary({super.key});

  @override
  State<FehresSahihBukhary> createState() => _FehresSahihBukharyState();
}

class _FehresSahihBukharyState extends State<FehresSahihBukhary> {
  String searchQuery = "";


  /// Scroll
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier(false);

  @override
  void initState() {
    _scrollController.addListener(() {
      _showScrollToTop.value = _scrollController.offset > 300;
    });
    super.initState();
  }


  @override
  void dispose() {
    _scrollController.dispose();
    _showScrollToTop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            final filteredChapters = state.chapters.where((chapter) {
              return ArabicSearchUtils.matches(
                title: chapter.chapterTitle,
                query: searchQuery,
              );
            }).toList();

            if (filteredChapters.isEmpty) {
              return Center(
                child: CustomText(
                  'لا توجد نتائج',
                  fontSize: 16.sp,
                ),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(6.w),
              itemCount: filteredChapters.length,
              itemBuilder: (context, index) {
                final chapter = filteredChapters[index];
                return Column(
                  children: [
                    ChapterCard(
                      chapterId: chapter.chapterId,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.sahihBukharyDetails , arguments: chapter);
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
      floatingActionButton: ReBuildScrollToTop(
        showScrollToTop: _showScrollToTop,
        scrollController: _scrollController,
      ),
    );
  }
}
