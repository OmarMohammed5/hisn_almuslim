import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/utils/control_font_size.dart';
import 'package:hisn_almuslim/features/hadith/books/muslim/data/model/chapter_sahih_muslim.dart';
import 'package:hisn_almuslim/features/hadith/books/muslim/data/model/hadith_muslim.dart';
import 'package:hisn_almuslim/features/hadith/widgets/hadith_details_card.dart';
import 'package:hisn_almuslim/features/hadith/widgets/reader_app_bar.dart';
import 'package:hisn_almuslim/core/helpers/share_helper.dart';
import '../../../../../core/shared/custom_snack_bar.dart';

class SahihMuslimDetails extends StatefulWidget {
  const SahihMuslimDetails({super.key, required this.chapterSahihMuslim});

  final ChapterSahihMuslim chapterSahihMuslim;

  @override
  State<SahihMuslimDetails> createState() => _SahihMuslimDetailsState();
}

class _SahihMuslimDetailsState extends State<SahihMuslimDetails> {
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();

  final ValueNotifier<double> _fontSizeNotifire = ValueNotifier(18.sp);
  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  final ValueNotifier<bool> _isUiVisible = ValueNotifier(true);

  bool _isSearching = false;
  List<HadithMuslim> _filteredHadiths = [];

  @override
  void initState() {
    super.initState();
    _filteredHadiths = widget.chapterSahihMuslim.hadiths;
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
        _filteredHadiths = widget.chapterSahihMuslim.hadiths;
      } else {
        _filteredHadiths = widget.chapterSahihMuslim.hadiths
            .where(
              (hadith) =>
                  hadith.content.toLowerCase().contains(query.toLowerCase()),
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
    ShareHelper.shareAsImage(context, text, isDark: isDark ,category: "صحيح مسلم" );
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
                          widget.chapterSahihMuslim.hadiths.indexOf(hadith) + 1;

                      return ValueListenableBuilder<double>(
                        valueListenable: _fontSizeNotifire,
                        builder: (context, fontSize, _) {
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _toggleUi,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(16.w),
                              child: HadithCard(
                                content: hadith.content,
                                index: originalIndex,
                                fontSize: fontSize,
                                searchQuery: _searchController.text,
                                onCopy: () =>
                                    _copyText(context, hadith.content),
                                onShare: () => _shareText(hadith.content),
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
                        "باب رقم : ${widget.chapterSahihMuslim.chapterId}",
                        onFontTap: () => FontSizeController.showFontSizeSlider(
                          context: context,
                          fontSizeNotifire: _fontSizeNotifire,
                        ), totalCount:  widget.chapterSahihMuslim.chapterCount,
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
