import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/utils/control_font_size.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/quran%20&%20sunnah%20dua/cubit/dua_cubit.dart';
import 'package:hisn_almuslim/features/jami%20dua/widgets/custom_dua_app_bar.dart';
import 'package:hisn_almuslim/features/jami%20dua/widgets/dua_card.dart';
import 'package:hisn_almuslim/helpers/share_helper.dart';
import 'package:hisn_almuslim/shared/custom_snack_bar.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';
import 'package:hisn_almuslim/shared/re_build_scroll_To_Top.dart';

class QuranDuaScreen extends StatefulWidget {
  const QuranDuaScreen({super.key});

  @override
  State<QuranDuaScreen> createState() => _QuranDuaScreenState();
}

class _QuranDuaScreenState extends State<QuranDuaScreen> {
  // Control of fontSize

  final ValueNotifier<double> _fontSizeNotifire = ValueNotifier(18);

  // Copy and Share
  void copyText(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(customSnackBar("تم النسخ", Icons.check_circle, context));
  }

  void shareText(String text) {
    ShareHelper.shareAsImage(context, text);
  }

  // Scroll To Top
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier(false);

  //

  @override
  void initState() {
    _scrollController.addListener(() {
      final shouldShow = _scrollController.offset > 300;
      if (_showScrollToTop.value != shouldShow) {
        _showScrollToTop.value = shouldShow;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _fontSizeNotifire.dispose();
    _scrollController.dispose();
    _showScrollToTop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: CustomDuaAppBar(
        isDark: isDark,
        onFontTap: () => FontSizeController.showFontSizeSlider(
          context: context,
          fontSizeNotifire: _fontSizeNotifire,
        ),
        title: 'أدعية من القرآن',
      ),
      body: BlocBuilder<DuaCubit, DuaState>(
        builder: (context, state) {
          if (state is DuaLoading) {
            return Center(
              child: CupertinoActivityIndicator(color: Colors.teal.shade700),
            );
          }

          if (state is DuaLoaded) {
            // To Filter the chapters of json and arrive to sunnah dua
            final chapters = state.duas;
            final sunnahChapter = chapters.firstWhere((c) => c.chapterId == 1);
            final sunnahDua = sunnahChapter.dua;
            return ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              itemCount: sunnahDua.length,
              itemBuilder: (context, index) {
                return ValueListenableBuilder(
                  valueListenable: _fontSizeNotifire,
                  builder: (context, fontSize, child) {
                    return DuaCard(
                      fontSize: fontSize,
                      content: sunnahDua[index].contentDua,
                      onCopy: () {
                        copyText(context, sunnahDua[index].contentDua);
                      },
                      onShare: () {
                        shareText(sunnahDua[index].contentDua);
                      },
                      reference: sunnahDua[index].reference,
                    );
                  },
                );
              },
            );
          } else if (state is DuaError) {
            return CustomText(state.message);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: ReBuildScrollToTop(
        showScrollToTop: _showScrollToTop,
        scrollController: _scrollController,
      ),
    );
  }
}
