import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/features/hadith/books/nawawi/data/cubit/hadith_cubit.dart';
import 'package:hisn_almuslim/features/hadith/widgets/chapter_card.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../../../core/shared/re_build_scroll_To_Top.dart';
import '../../../../../core/shared/search_field.dart';
import '../../../../../core/utils/arabic_search_utils.dart';

class FehresHadithNawawi extends StatefulWidget {
  const FehresHadithNawawi({super.key});

  @override
  State<FehresHadithNawawi> createState() => _FehresHadithNawawiState();
}

class _FehresHadithNawawiState extends State<FehresHadithNawawi> {
  String searchQuery = '';


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
            final filteredHadiths = state.hadithList.where((chapter) {
              return ArabicSearchUtils.matches(
                title:  chapter.hadithContent.last.title,
                query: searchQuery,
              );
            }).toList();


            if(filteredHadiths.isEmpty){
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
              itemCount: filteredHadiths.length,
              itemBuilder: (context, index) {
                final hadith = filteredHadiths[index];

                return ChapterCard(
                  chapterId: hadith.id,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.hadithNawawi , arguments: hadith.id);
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
      floatingActionButton: ReBuildScrollToTop(
        showScrollToTop: _showScrollToTop,
        scrollController: _scrollController,
      ),
    );
  }
}



/*

 */