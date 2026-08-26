import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/features/hadith/books/reyad%20al%20salehin/data/cubit/reyad_al_saliheen_cubit.dart';
import 'package:hisn_almuslim/features/hadith/books/reyad%20al%20salehin/screen/reyad_al_saliheen_details.dart';
import 'package:hisn_almuslim/features/hadith/widgets/chapter_card.dart';
import 'package:hisn_almuslim/features/quran/widgets/search_field.dart';

import '../../../../../core/shared/re_build_scroll_To_Top.dart';
import '../../../../../core/utils/arabic_search_utils.dart';

class FehresReyadAlSaliheen extends StatefulWidget {
  const FehresReyadAlSaliheen({super.key});

  @override
  State<FehresReyadAlSaliheen> createState() => _FehresReyadAlSaliheenState();
}

class _FehresReyadAlSaliheenState extends State<FehresReyadAlSaliheen> {
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
      body: BlocBuilder<ReyadAlSaliheenCubit, ReyadAlSaliheenState>(
        builder: (context, state) {
          if (state is ReyadAlSaliheenLoading) {
            return Center(
              child: CupertinoActivityIndicator(color: Colors.teal.shade700),
            );
          }

          if (state is ReyadAlSaliheenLoaded) {
            final filteredChapters = state.hadiths.where((chapter) {
              return ArabicSearchUtils.matches(
                title: chapter.chapterTitle,
                query: searchQuery,
              );
            }).toList();

            if (filteredChapters.isEmpty) {
              return Center(
                child: CustomText('لا توجد نتائج', fontSize: 16.sp),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(6.w),
              itemCount: filteredChapters.length,
              itemBuilder: (context, index) {
                final chapter = filteredChapters[index];

                String getChapterTitle() {
                  final title = chapter.chapterTitle;

                  if (title.trim().isEmpty) {
                    return ' الباب رقم  ${chapter.chapterId}';
                  }

                  if (RegExp(r'^\d+$').hasMatch(title.trim())) {
                    return 'الباب رقم $title';
                  }

                  return title;
                }

                return Column(
                  children: [
                    ChapterCard(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.reyadAlSaliheenDetails,
                          arguments: chapter,
                        );
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
      floatingActionButton: ReBuildScrollToTop(
        showScrollToTop: _showScrollToTop,
        scrollController: _scrollController,
      ),
    );
  }
}
