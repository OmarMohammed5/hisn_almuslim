import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/utils/control_font_size.dart';
import 'package:hisn_almuslim/features/al%20azkar/evening%20azkar/data/evening_azkar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/shared/app_bar_widget.dart';
import '../../../../core/shared/interactive_zekr_card.dart';
import '../../../../core/shared/zekr_actions_widget.dart';
import '../../../../core/shared/zekr_info_dialog.dart';
import '../../../../core/theme/app_colors.dart';

class EveningAzkarScreen extends StatefulWidget {
  const EveningAzkarScreen({super.key, this.initialIndex});
  final int? initialIndex;

  @override
  State<EveningAzkarScreen> createState() => _EveningAzkarScreenState();
}

class _EveningAzkarScreenState extends State<EveningAzkarScreen> {
  late int _currentIndex;
  PageController? _pageController;
  bool isLoading = true;
  final ValueNotifier<double> _fontSizeNotifire = ValueNotifier(16.sp);

  /// Method to load the last page
  Future<int> loadPage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("last_evening_page") ?? 0;
  }

  /// Save the current page
  Future<void> savePage(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("last_evening_page", index);
  }

  /// init the page when toggleing
  Future<void> initPage() async {
    int savedPage = await loadPage();

    final safeStart =
        (widget.initialIndex != null &&
            widget.initialIndex! >= 0 &&
            widget.initialIndex! < eveningAzkar['content'].length)
        ? widget.initialIndex
        : savedPage;
    _currentIndex = safeStart!;
    _pageController = PageController(initialPage: safeStart);

    setState(() {
      _currentIndex = safeStart;
      _pageController = PageController(initialPage: safeStart);
      isLoading = false; // End loading
    });
  }

  // Immersive Reading Mode
  bool _isUiVisible = true;

  void _toggleUi() {
    setState(() {
      _isUiVisible = !_isUiVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    initPage();
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
        title: "${eveningAzkar['title']}",
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
              eveningAzkar['content'][_currentIndex]
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
                    itemCount: eveningAzkar['content'].length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                      savePage(index);
                    },
                    itemBuilder: (context, index) {
                      final zekr = eveningAzkar['content'][index];
                      final isLast = index == eveningAzkar['content'].length - 1;
                      final count = int.tryParse('${zekr['count']}') ?? 1;

                      return ValueListenableBuilder(
                        valueListenable: _fontSizeNotifire,
                        builder: (context, fontSize, child) {
                          return ListView(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 20.h,
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
                                  } else {
                                    _showCompletionFeedback(context);
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
              Gap(60.h),
            ],
          ),
          // Actions
          Positioned(
            left: 0.w,
            right: 0.w,
            bottom: 8.h,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              offset: _isUiVisible ? Offset.zero : const Offset(0, 1),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _isUiVisible ? 1 : 0,
                child:ZekrActionsWidget(
                  zekrText: eveningAzkar['content'][_currentIndex]['text']
                      ?.toString() ??
                      '',
                  currentIndex: _currentIndex,
                  total: eveningAzkar['content'].length,
                  pageController: _pageController!,
                ),
              ),
            ),
          ),
        ],
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
