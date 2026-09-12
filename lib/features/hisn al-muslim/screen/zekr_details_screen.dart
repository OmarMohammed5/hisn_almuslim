import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/models/content_item.dart';
import 'package:hisn_almuslim/core/shared/zekr_actions_widget.dart';
import 'package:hisn_almuslim/core/utils/control_font_size.dart';
import '../../../core/responsive/app_responsive.dart';
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
  final ValueNotifier<double> _fontSizeNotifire = ValueNotifier(16);

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
        ? Colors.tealAccent.shade700
        : Colors.teal.shade700;
    final textColor = isDark ? Colors.white : Colors.black87;

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CupertinoActivityIndicator(color: AppColors.kIconColor),
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
              padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1A2723)
                    : const Color(0xFFEAF2F0),
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context, 12),
                ),
              ),
              child: Icon(
                Icons.text_fields,
                color: accentColor,
                size: AppResponsive.iconSize(context, 20),
              ),
            ),
          ),
          Gap(AppResponsive.widthValue(context, 10)),
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
              padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1A2723)
                    : const Color(0xFFEAF2F0),
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context, 12),
                ),
              ),
              child: Icon(
                Icons.info_outline_rounded,
                color: accentColor,
                size: AppResponsive.iconSize(context, 20),
              ),
            ),
          ),
          Gap(AppResponsive.widthValue(context, 16)),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _isUiVisible,
        builder: (context, isUiVisible, child) {
          return Stack(
            children: [
              /// CONTENT
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
                          padding: EdgeInsets.fromLTRB(
                            AppResponsive.widthValue(context, 2),
                            AppResponsive.heightValue(context, 20),
                            AppResponsive.widthValue(context, 2),
                            AppResponsive.heightValue(context, 110),
                          ),
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
                                }
                              },
                              size: fontSize,
                              currentIndex: _currentIndex,
                              total: total,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),

              Positioned(
                left: AppResponsive.widthValue(context, 16),
                bottom: AppResponsive.heightValue(context, 16),
                child: ZekrActionsWidget(zekrText: currentContent.text),
              ),
            ],
          );
        },
      ),
    );
  }
}
