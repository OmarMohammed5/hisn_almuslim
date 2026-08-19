import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/models/content_item.dart';
import 'package:hisn_almuslim/core/shared/zekr_actions_widget.dart';
import 'package:hisn_almuslim/core/utils/control_font_size.dart';
import '../../../core/shared/app_bar_widget.dart';
import '../../../core/shared/interactive_zekr_card.dart';
import '../../../core/shared/zekr_info_dialog.dart';
import '../../../core/theme/app_colors.dart';

class ZekrDetailsScreen extends StatefulWidget {
  final Zekr zekr;
  final int initialIndex;
  const ZekrDetailsScreen({
    super.key,
    required this.zekr,
    required this.initialIndex,
  });

  @override
  State<ZekrDetailsScreen> createState() => _ZekrDetailsScreenState();
}

class _ZekrDetailsScreenState extends State<ZekrDetailsScreen> {
  late PageController _pageController;
  late int _currentIndex;

  bool isLoading = true;
  final ValueNotifier<bool> _isUiVisible = ValueNotifier(true);
  final ValueNotifier<double> _fontSizeNotifire = ValueNotifier(16.sp);

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  Future<void> _initPage() async {
    int safeStart =
        (widget.initialIndex >= 0 &&
            widget.initialIndex < widget.zekr.content.length)
        ? widget.initialIndex
        : 0;

    _pageController = PageController(initialPage: safeStart);

    setState(() {
      _currentIndex = safeStart;
      isLoading = false;
    });
  }

  void _toggleUi() {
    _isUiVisible.value = !_isUiVisible.value;
  }

  @override
  void dispose() {
    _isUiVisible.dispose();
    _pageController.dispose();
    _fontSizeNotifire.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final contents = widget.zekr.content;
    final total = contents.length;

    final accentColor = isDark
        ? Colors.tealAccent.shade200
        : Colors.teal.shade700;
    final textColor = isDark ? Colors.white : Colors.black87;

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CupertinoActivityIndicator(
            color: AppColors.kIconColor,
            radius: 16.r,
          ),
        ),
      );
    }

    final currentContent = contents[_currentIndex];

    return Scaffold(
      appBar: AppBarWidget(
        title: widget.zekr.title,
        actions: [
          GestureDetector(
            onTap: () => FontSizeController.showFontSizeSlider(
              context: context,
              fontSizeNotifire: _fontSizeNotifire,
            ),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isDark ? Color(0xff273835) : Color(0xffe0efed),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Icon(
                Icons.text_fields,
                color: isDark ? Color(0xff61f9d5) : Color(0xff2f8a7e),
                size: 20.sp,
              ),
            ),
          ),
          Gap(10.w),
          GestureDetector(
            onTap: () {
              ZekrInfoDialog.show(
                context,
                source: currentContent.source,
                count: currentContent.count,
                accentColor: accentColor,
                textColor: textColor,
              );
            },
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.info_outline_rounded,
                color: accentColor,
                size: 22.sp,
              ),
            ),
          ),
          Gap(16.w),

        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _isUiVisible,
        builder: (context, isUiVisible, child) {
          return Stack(
            children: [
              /// ================= CONTENT =================
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggleUi,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: total,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, pageIndex) {
                    final content = contents[pageIndex];
                    final isLast = pageIndex == total - 1;
                    final count = int.tryParse(content.count) ?? 1;

                    return ValueListenableBuilder(
                      valueListenable: _fontSizeNotifire,
                      builder: (context, fontSize, child) {
                        return ListView(
                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 60.h),
                          physics: BouncingScrollPhysics(),
                          children: [
                            InteractiveZekrCard(
                              key: ValueKey(pageIndex),
                              text: content.text,
                              count: count,
                              fadl: content.fadl,
                              onCompleted: () {
                                if (!isLast) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  _showCompletionFeedback(context);
                                }
                              },
                              size: fontSize,
                            ),
                          ],
                        );
                      }
                    );
                  },
                ),
              ),


              /// ================= ACTIONS =================
              Positioned(
                left: 0,
                right: 0,
                bottom: 12.h,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 250),
                  offset: isUiVisible ? Offset.zero : const Offset(0, 1),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: isUiVisible ? 1 : 0,
                    child: ZekrActionsWidget(
                      zekrText: currentContent.text,
                      currentIndex: _currentIndex,
                      total: total,
                      pageController: _pageController,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  void _showCompletionFeedback(BuildContext context) {

    // Heavy Impact
    HapticFeedback.heavyImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("أتممت جميع الأذكار 🌿"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: Colors.teal.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
