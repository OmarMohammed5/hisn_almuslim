import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/shared/re_build_scroll_To_Top.dart';
import 'package:hisn_almuslim/core/shared/search_field.dart';
import 'package:hisn_almuslim/core/utils/arabic_search_utils.dart';
import 'package:hisn_almuslim/features/hadith/domain/entities/hadith_book.dart';
import 'package:hisn_almuslim/features/hadith/domain/entities/hadith_entity.dart';
import 'package:hisn_almuslim/features/hadith/domain/entities/hadith_route_args.dart';
import 'package:hisn_almuslim/features/hadith/presentation/cubit/hadith_cubit.dart';
import 'package:hisn_almuslim/features/hadith/presentation/cubit/hadith_state.dart';
import 'package:hisn_almuslim/features/hadith/widgets/chapter_card.dart';

class HadithIndexScreen extends StatefulWidget {
  final HadithBookType book;

  const HadithIndexScreen({
    super.key,
    required this.book,
  });

  @override
  State<HadithIndexScreen> createState() => _HadithIndexScreenState();
}

class _HadithIndexScreenState extends State<HadithIndexScreen> {
  String searchQuery = '';

  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier(false);

  HadithBook get _book => HadithBook.fromType(widget.book);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _showScrollToTop.value = _scrollController.offset > 300;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _showScrollToTop.dispose();
    super.dispose();
  }

  void _openChapter(HadithChapter chapter, List<HadithChapter> chapters) {
    final hadiths = widget.book == HadithBookType.nawawi
        ? chapters.expand((item) => item.hadiths).toList()
        : chapter.hadiths;

    final initialIndex = widget.book == HadithBookType.nawawi
        ? chapter.id - 1
        : 0;

    final headerTitle = widget.book == HadithBookType.nawawi
        ? ''
        : 'باب رقم : ${chapter.id}';

    final totalCount = widget.book == HadithBookType.riyadAlSaliheen
        ? chapter.hadiths.length
        : chapter.hadithsCount;

    Navigator.pushNamed(
      context,
      AppRoutes.hadithDetails,
      arguments: HadithDetailsArgs(
        book: widget.book,
        hadiths: hadiths,
        initialIndex: initialIndex,
        headerTitle: headerTitle,
        totalCount: totalCount,
      ),
    );
  }

  String _chapterTitle(HadithChapter chapter) {
    if (widget.book != HadithBookType.riyadAlSaliheen) {
      return chapter.title;
    }

    final title = chapter.title;

    if (title.trim().isEmpty) {
      return ' الباب رقم  ${chapter.id}';
    }

    if (RegExp(r'^\d+$').hasMatch(title.trim())) {
      return 'الباب رقم $title';
    }

    return title;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: AppResponsive.heightValue(context, 80),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(
            top: AppResponsive.heightValue(context, 12),
            bottom: AppResponsive.heightValue(context, 12),
          ),
          child: BuildBackButton(
            context: context,
            iconColor: isDark ? Colors.white : Colors.black87,
          ),
        ),
        title: SearchField(
          hint: _book.indexHint,
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
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
            final chapters = state.data.chapters;
            final filteredChapters = chapters.where((chapter) {
              return ArabicSearchUtils.matches(
                title: chapter.title,
                query: searchQuery,
              );
            }).toList();

            if (filteredChapters.isEmpty) {
              return Center(
                child: CustomText(
                  'لا توجد نتائج',
                  fontSize: AppResponsive.fontSize(context, 15),
                ),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(AppResponsive.widthValue(context, 6)),
              itemCount: filteredChapters.length,
              itemBuilder: (context, index) {
                final chapter = filteredChapters[index];

                return ChapterCard(
                  chapterId: chapter.id,
                  onTap: () => _openChapter(chapter, chapters),
                  chapterTitle: _chapterTitle(chapter),
                  count: widget.book == HadithBookType.nawawi
                      ? null
                      : chapter.hadithsCount,
                );
              },
            );
          }

          if (state is HadithError) {
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
