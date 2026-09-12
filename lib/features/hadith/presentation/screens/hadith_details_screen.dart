import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:hisn_almuslim/core/helpers/share_helper.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/custom_snack_bar.dart';
import 'package:hisn_almuslim/core/utils/control_font_size.dart';
import 'package:hisn_almuslim/features/hadith/domain/entities/hadith_book.dart';
import 'package:hisn_almuslim/features/hadith/domain/entities/hadith_route_args.dart';
import 'package:hisn_almuslim/features/hadith/widgets/content.dart';
import 'package:hisn_almuslim/features/hadith/widgets/hadith_details_card.dart';
import 'package:hisn_almuslim/features/hadith/widgets/header.dart';
import 'package:hisn_almuslim/features/hadith/widgets/reader_app_bar.dart';

class HadithDetailsScreen extends StatefulWidget {
  final HadithDetailsArgs args;

  const HadithDetailsScreen({
    super.key,
    required this.args,
  });

  @override
  State<HadithDetailsScreen> createState() => _HadithDetailsScreenState();
}

class _HadithDetailsScreenState extends State<HadithDetailsScreen> {
  late final PageController _pageController;
  late final ValueNotifier<double> _fontSizeNotifier;
  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  final ValueNotifier<bool> _isUiVisible = ValueNotifier(true);

  bool get _isNawawi => widget.args.book == HadithBookType.nawawi;
  bool get _isBukhary => widget.args.book == HadithBookType.bukhary;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.args.initialIndex);

    // Preserve the existing per-book typography behavior.
    _fontSizeNotifier = ValueNotifier(
      widget.args.book == HadithBookType.muslim ? 18.sp : 18,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fontSizeNotifier.dispose();
    _currentPage.dispose();
    _isUiVisible.dispose();
    super.dispose();
  }

  void _toggleUi() {
    _isUiVisible.value = !_isUiVisible.value;
  }

  void _copyText(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar('تم النسخ', Icons.check_circle, context),
    );
  }

  void _shareText(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ShareHelper.shareAsImage(
      context,
      text,
      isDark: isDark,
      category: HadithBook.fromType(widget.args.book).shareCategory,
    );
  }

  double _readerTop(BuildContext context) {
    if (_isBukhary) {
      return AppResponsive.heightValue(context, 90);
    }
    return AppResponsive.heightValue(context, 70);
  }

  @override
  Widget build(BuildContext context) {
    if (_isNawawi) {
      return _buildNawawiDetails(context);
    }

    return _buildReaderDetails(context);
  }

  Widget _buildReaderDetails(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isUiVisible,
      builder: (context, isUiVisible, _) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  top: _readerTop(context),
                  left: 0,
                  right: 0,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.args.hadiths.length,
                    onPageChanged: (index) {
                      _currentPage.value = index;
                    },
                    itemBuilder: (context, index) {
                      final hadith = widget.args.hadiths[index];

                      return ValueListenableBuilder<double>(
                        valueListenable: _fontSizeNotifier,
                        builder: (context, fontSize, _) {
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _toggleUi,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(
                                AppResponsive.widthValue(context, _isBukhary ? 12 : 16),
                              ),
                              child: HadithCard(
                                content: hadith.content,
                                index: index,
                                fontSize: fontSize,
                                onCopy: () => _copyText(context, hadith.content),
                                onShare: () => _shareText(hadith.content),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  top: isUiVisible ? 0 : -600,
                  left: 0,
                  right: 0,
                  child: ValueListenableBuilder<int>(
                    valueListenable: _currentPage,
                    builder: (context, value, child) {
                      return ReaderAppBar(
                        currentPage: value,
                        isUiVisible: isUiVisible,
                        title: widget.args.headerTitle,
                        onFontTap: () => FontSizeController.showFontSizeSlider(
                          context: context,
                          fontSizeNotifire: _fontSizeNotifier,
                        ),
                        totalCount: widget.args.totalCount,
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

  Widget _buildNawawiDetails(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isUiVisible,
      builder: (context, isUiVisible, _) {
        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _toggleUi,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.args.hadiths.length,
                        onPageChanged: (index) {
                          _currentPage.value = index;
                        },
                        itemBuilder: (context, index) {
                          final hadith = widget.args.hadiths[index];

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppResponsive.widthValue(context, 16),
                              vertical: AppResponsive.heightValue(context, 10),
                            ),
                            child: ValueListenableBuilder<double>(
                              valueListenable: _fontSizeNotifier,
                              builder: (context, fontSize, child) {
                                return ListView(
                                  children: [
                                    Content(
                                      fontSize: fontSize,
                                      title: hadith.title,
                                      content: hadith.content,
                                      numberOfHadith: hadith.id,
                                    ),
                                    Gap(AppResponsive.heightValue(context, 16)),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                top: AppResponsive.heightValue(context, 30),
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 250),
                  offset: isUiVisible ? Offset.zero : const Offset(0, -1),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: isUiVisible ? 1 : 0,
                    child: Header(
                      onFontTap: () => FontSizeController.showFontSizeSlider(
                        context: context,
                        fontSizeNotifire: _fontSizeNotifier,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
