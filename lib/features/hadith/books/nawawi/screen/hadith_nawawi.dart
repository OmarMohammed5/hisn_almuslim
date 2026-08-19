import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/utils/control_font_size.dart';
import 'package:hisn_almuslim/features/hadith/books/nawawi/data/cubit/hadith_cubit.dart';
import 'package:hisn_almuslim/features/hadith/widgets/content.dart';
import 'package:hisn_almuslim/features/hadith/widgets/header.dart';
import 'package:hisn_almuslim/core/helpers/share_helper.dart';
import '../../../../../core/shared/custom_snack_bar.dart';

class HadithNawawi extends StatefulWidget {
  const HadithNawawi({super.key, required this.id});
  final int id;
  @override
  State<HadithNawawi> createState() => _HadithNawawiState();
}

class _HadithNawawiState extends State<HadithNawawi> {
  int currentIndex = 0;
  late PageController? pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.id - 1);
    context.read<HadithCubit>().loadHadiths();
  }

  @override
  void dispose() {
    pageController!.dispose();
    _fontSizeNotifire.dispose();
    super.dispose();
  }

  final ValueNotifier<double> _fontSizeNotifire = ValueNotifier(18.sp);

  // To hide the app bar and bottom actions when the user click on the screen
  bool _isUiVisible = true;

  void _toggleUi() {
    setState(() {
      _isUiVisible = !_isUiVisible;
    });
  }

  String _currentZekrText = '';

  // Copy Method of Zekr Content
  void copyZekr(String text) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(
        "تم النسخ",
        Icons.check_circle,
        context,
        lightColor: Colors.teal,
        darkColor: Colors.teal.shade400,
      ),
    );
  }

  // Share Method of Zekr Content
  void shareZekr() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ShareHelper.shareAsImage(context, _currentZekrText, isDark: isDark ,category: "الأربعون النووية" );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Content
          Column(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _toggleUi,
                  child: BlocBuilder<HadithCubit, HadithState>(
                    builder: (context, state) {
                      if (state is HadithLoading) {
                        return Center(
                          child: CupertinoActivityIndicator(
                            color: Colors.teal.shade700,
                          ),
                        );
                      }

                      if (state is HadithLoaded) {
                        final hadithList = state.hadithList;

                        return PageView.builder(
                          controller: pageController,
                          itemCount: hadithList.length,
                          onPageChanged: (index) {
                            setState(() {
                              currentIndex = index;
                              _currentZekrText =
                                  hadithList[index].hadithContent.last.contenu;
                            });
                          },
                          itemBuilder: (context, index) {
                            final hadith = hadithList[index];
                            final content =
                                hadith.hadithContent.last; // Arabic Hadith
                            return Padding(
                              padding: EdgeInsets.all(16.w),
                              child: ValueListenableBuilder(
                                valueListenable: _fontSizeNotifire,
                                builder: (context, fontSize, child) {
                                  return ListView(
                                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Content(
                                        fontSize: fontSize,
                                        title: content.title,
                                        content: content.contenu,
                                        numberOfHadith:
                                            hadith.id, // Number of Hadith
                                      ),

                                      Gap(80.sp),
                                    ],
                                  );
                                },
                              ),
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
                ),
              ),
            ],
          ),

          /// HEADER
          Positioned(
            left: 0.w,
            right: 0.w,
            top: 30.h,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              offset: _isUiVisible ? Offset.zero : const Offset(0, -1),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _isUiVisible ? 1 : 0,
                child: Header(
                  onFontTap: () => FontSizeController.showFontSizeSlider(
                    context: context,
                    fontSizeNotifire: _fontSizeNotifire,
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
