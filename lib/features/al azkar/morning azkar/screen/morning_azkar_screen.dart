import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/utils/control_font_size.dart';
import 'package:hisn_almuslim/features/al%20azkar/morning%20azkar/data/morning_azkar.dart';
import '../../../../core/shared/app_bar_widget.dart';
import '../../../../core/shared/custom_text.dart';
import '../../../../core/shared/interactive_zekr_card.dart';
import '../../../../core/shared/zekr_actions_widget.dart';
import '../../../../core/shared/zekr_info_dialog.dart';
import '../../../../core/theme/app_colors.dart';

class MorningAzkarScreen extends StatefulWidget {
  const MorningAzkarScreen({super.key, this.initialIndex});
  final int? initialIndex;

  @override
  State<MorningAzkarScreen> createState() => _MorningAzkarScreenState();
}

class _MorningAzkarScreenState extends State<MorningAzkarScreen> {
  late int _currentIndex;
  PageController? _pageController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  /// init the page when toggleing
  Future<void> _initPage() async {
    // int savedPage = await loadPage();

    final safeStart =
        (widget.initialIndex != null &&
            widget.initialIndex! >= 0 &&
            widget.initialIndex! < morningAzkar['content'].length)
        ? widget.initialIndex!
        : 0;

    setState(() {
      _currentIndex = safeStart;
      _pageController = PageController(initialPage: safeStart);
      isLoading = false; // End loading
    });
  }

  // Control of font size

  final ValueNotifier<double> _fontSizeNotifire = ValueNotifier(16.sp);
  // Immersive Reading Mode
  bool _isUiVisible = true;

  void _toggleUi() {
    setState(() {
      _isUiVisible = !_isUiVisible;
    });
  }

  @override
  void dispose() {
    _fontSizeNotifire.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accentColor = isDark
        ? Colors.tealAccent.shade200
        : Colors.teal.shade700;
    final textColor = isDark ? Colors.white : Colors.black87;

    // if it still loading display the CircularProgressIndicator
    if (isLoading || _pageController == null) {
      return Scaffold(
        body: Center(
          child: CupertinoActivityIndicator(
            color: AppColors.kIconColor,
            radius: 16.r,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBarWidget(
        title: "${morningAzkar['title']}",
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
               final currentZekr =
               morningAzkar['content'][_currentIndex]
               as Map<String, dynamic>;

               ZekrInfoDialog.show(
                 context,
                 source: currentZekr['source']?.toString(),
                 count: currentZekr['count']?.toString(),
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
      body: Stack(
        children: [
          // Content (Scrollable)
          Column(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _toggleUi,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: morningAzkar['content'].length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                      // savePage(index);
                    },
                    itemBuilder: (context, index) {
                      final zekr = morningAzkar['content'][index];
                      final isLast = index == morningAzkar['content'].length - 1;
                      final count = int.tryParse('${zekr['count']}') ?? 1;

                      return ValueListenableBuilder(
                        valueListenable: _fontSizeNotifire,
                        builder: (context, fontSize, child) {
                          return ListView(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(
                              2.w,
                              20.h,
                              2.w,
                              110.h,
                            ),
                            children: [
                              InteractiveZekrCard(
                                key: ValueKey(index),
                                text: zekr['text'],
                                count: count,
                                fadl: zekr['fadl'],
                                onCompleted: () {
                                  if (!isLast) {
                                    _pageController!.nextPage(
                                      duration: const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                size: fontSize,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          // Actions
          Positioned(
            left: 0.w,
            right: 0.w,
            bottom: 12.h,
            child: SafeArea(
              top: false,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                offset: _isUiVisible ? Offset.zero : const Offset(0, 1),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: _isUiVisible ? 1 : 0,
                  child:ZekrActionsWidget(
                    zekrText: morningAzkar['content'][_currentIndex]['text']
                        ?.toString() ??
                        '',
                    currentIndex: _currentIndex,
                    total: morningAzkar['content'].length,
                    pageController: _pageController!,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}


