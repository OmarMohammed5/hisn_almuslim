import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/utils/control_font_size.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/quran%20&%20sunnah%20dua/cubit/dua_cubit.dart';
import 'package:hisn_almuslim/features/jami%20dua/widgets/custom_dua_app_bar.dart';
import 'package:hisn_almuslim/features/jami%20dua/widgets/dua_card.dart';
import 'package:hisn_almuslim/core/helpers/share_helper.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../../../core/shared/custom_snack_bar.dart';
import '../../../core/shared/re_build_scroll_To_Top.dart';

class SunnahDuaScreen extends StatefulWidget {
  const SunnahDuaScreen({super.key});

  @override
  State<SunnahDuaScreen> createState() => _SunnahDuaScreenState();
}

class _SunnahDuaScreenState extends State<SunnahDuaScreen> {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ShareHelper.shareAsImage(context, text, isDark: isDark ,category: "أدعية من السنة");
  }

  // Scroll To Top
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier(false);

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
        title: "أدعية من السنة",
      ),
      body: BlocBuilder<DuaCubit, DuaState>(
        builder: (context, state) {
          if (state is DuaLoading) {
            return Center(
              child: CupertinoActivityIndicator(color: Colors.teal.shade700),
            );
          }

          if (state is DuaLoaded) {
            // To Filter the chapters of json and arrive to quran dua

            final chapters = state.duas;
            final quranChapter = chapters.lastWhere((c) => c.chapterId == 2);
            final quraDuas = quranChapter.dua;
            return ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              itemCount: quraDuas.length,
              itemBuilder: (context, index) {
                return ValueListenableBuilder(
                  valueListenable: _fontSizeNotifire,
                  builder: (context, fontSize, child) {
                    return DuaCard(
                      fontSize: fontSize.sp,
                      content: quraDuas[index].contentDua,
                      onCopy: () {
                        copyText(context, quraDuas[index].contentDua);
                      },
                      onShare: () {
                        shareText(quraDuas[index].contentDua);
                      },
                      reference: quraDuas[index].reference,
                    );
                  },
                );
              },
            );
          } else if (state is DuaError) {
            return CustomText(state.message);
          } else {
            return SizedBox.fromSize();
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
