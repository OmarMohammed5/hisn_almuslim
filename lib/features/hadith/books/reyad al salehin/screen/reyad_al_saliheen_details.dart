import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/utils/control_font_size.dart';
import 'package:hisn_almuslim/features/hadith/books/reyad%20al%20salehin/data/model/chapter_reyad_al_saliheen.dart';
import 'package:hisn_almuslim/features/hadith/books/reyad%20al%20salehin/data/model/reyad_al_saliheen.dart';
import 'package:hisn_almuslim/features/hadith/widgets/hadith_details_card.dart';
import 'package:hisn_almuslim/features/hadith/widgets/reader_app_bar.dart';
import 'package:hisn_almuslim/core/helpers/share_helper.dart';

import '../../../../../core/shared/custom_snack_bar.dart';

class ReyadAlSaliheenDetails extends StatefulWidget {
  const ReyadAlSaliheenDetails({
    super.key,
    required this.chapterReyadAlSaliheen,
  });

  final ChapterReyadAlSaliheen chapterReyadAlSaliheen;

  @override
  State<ReyadAlSaliheenDetails> createState() => _ReyadAlSaliheenDetailsState();
}

class _ReyadAlSaliheenDetailsState extends State<ReyadAlSaliheenDetails> {
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();

  final ValueNotifier<double> _fontSizeNotifire = ValueNotifier(18.sp);
  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  final ValueNotifier<bool> _isUiVisible = ValueNotifier(true);

  bool _isSearching = false;
  List<ReyadAlSaliheen> _filteredHadiths = [];

  @override
  void initState() {
    super.initState();
    _filteredHadiths = widget.chapterReyadAlSaliheen.hadiths;
  }

  @override
  void dispose() {
    _fontSizeNotifire.dispose();
    _pageController.dispose();
    _searchController.dispose();
    _currentPage.dispose();
    _isUiVisible.dispose();
    super.dispose();
  }

  void _toggleUi() {
    _isUiVisible.value = !_isUiVisible.value;
  }

  void _searchHadiths(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredHadiths = widget.chapterReyadAlSaliheen.hadiths;
      } else {
        _filteredHadiths = widget.chapterReyadAlSaliheen.hadiths
            .where(
              (hadith) => hadith.hadithContent.toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();
      }
    });

    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  void _copyText(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(customSnackBar("تم النسخ", Icons.check_circle, context));
  }

  void _shareText(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ShareHelper.shareAsImage(context, text, isDark: isDark ,category: "رياض الصالحين" );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isUiVisible,
      builder: (context, isUiVisible, _) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Stack(
              children: [
                // ================= FULL SCREEN CONTENT =================
                Positioned.fill(
                  top: 70.h,
                  left: 0,
                  right: 0,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _filteredHadiths.length,
                    onPageChanged: (index) {
                      _currentPage.value = index;
                    },
                    itemBuilder: (context, index) {
                      final hadith = _filteredHadiths[index];

                      final originalIndex =
                          widget.chapterReyadAlSaliheen.hadiths.indexOf(
                            hadith,
                          ) +
                          1;

                      return ValueListenableBuilder<double>(
                        valueListenable: _fontSizeNotifire,
                        builder: (context, fontSize, _) {
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _toggleUi,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(16.w),
                              child: HadithCard(
                                content: hadith.hadithContent,
                                index: originalIndex,
                                fontSize: fontSize,
                                searchQuery: _searchController.text,
                                onCopy: () =>
                                    _copyText(context, hadith.hadithContent),
                                onShare: () => _shareText(hadith.hadithContent),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // ================= OVERLAY APP BAR =================
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  top: isUiVisible ? 0 : -600,
                  left: 0,
                  right: 0,
                  child: ValueListenableBuilder(
                    valueListenable: _currentPage,
                    builder: (context, value, child) {
                      return ReaderAppBar(
                        currentPage: value,
                        isUiVisible: isUiVisible,
                        title:
                        "باب رقم : ${widget.chapterReyadAlSaliheen.chapterId}",
                        onFontTap: () => FontSizeController.showFontSizeSlider(
                          context: context,
                          fontSizeNotifire: _fontSizeNotifire,
                        ), totalCount:  widget.chapterReyadAlSaliheen.hadithsCount,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
