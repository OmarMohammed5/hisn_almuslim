import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/utils/control_font_size.dart';
import 'package:hisn_almuslim/features/al%20azkar/evening%20azkar/data/evening_azkar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/shared/app_bar_widget.dart';
import '../../../../core/shared/zekr_actions_widget.dart';
import '../../../../core/shared/zekr_content_widget.dart';
import '../../../../core/shared/zekr_header_widget.dart';
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
  final ValueNotifier<double> _fontSizeNotifire = ValueNotifier(20.sp);

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
      // appBar: CustomAppBar(title: "${eveningAzkar['title']}", isDark: isDark),
      appBar: AppBarWidget(title: "${eveningAzkar['title']}"),
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
                      return ValueListenableBuilder(
                        valueListenable: _fontSizeNotifire,
                        builder: (context, fontSize, child) {
                          return ListView(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 60.h,
                            ),
                            children: [
                              ZekrContentWidget(zekr: zekr, fontSize: fontSize),
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
          // Header
          Positioned(
            left: 0.w,
            right: 0.w,
            top: 0.h,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              offset: _isUiVisible ? Offset.zero : const Offset(0, -1),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _isUiVisible ? 1 : 0,
                child: ZekrHeaderWidget(
                  onFontTap: () => FontSizeController.showFontSizeSlider(
                    context: context,
                    fontSizeNotifire: _fontSizeNotifire,
                  ),
                  zekr: eveningAzkar['content'][_currentIndex],
                  isDark: isDark,
                ),
              ),
            ),
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
                child: ZekrActionsWidget(
                  zekr: eveningAzkar['content'][_currentIndex],
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
}
