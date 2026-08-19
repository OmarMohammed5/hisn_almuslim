import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/utils/control_font_size.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/last%20ten%20duas/last_ten_duas_cubit.dart';
import 'package:hisn_almuslim/features/jami%20dua/widgets/dua_card.dart';
import 'package:hisn_almuslim/core/helpers/share_helper.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../core/shared/app_bar_widget.dart';
import '../../../core/shared/custom_snack_bar.dart';
import '../../../core/shared/re_build_scroll_To_Top.dart';

class LastTenDuasScreen extends StatefulWidget {
  const LastTenDuasScreen({super.key});

  @override
  State<LastTenDuasScreen> createState() => _LastTenDuasScreenState();
}

class _LastTenDuasScreenState extends State<LastTenDuasScreen> {
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
    ShareHelper.shareAsImage(context, text, isDark: isDark ,category:  "أدعية العشر الأواخر");
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
      appBar: AppBarWidget(
        title: "أدعية العشر الأواخر",
        actions: [   Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: IconButton(
            icon: Icon(
              Icons.text_fields,
              color: Colors.teal.shade700,
              size: 20.sp,
            ),
            onPressed: ()=> FontSizeController.showFontSizeSlider(
              context: context,
              fontSizeNotifire: _fontSizeNotifire,
            ),
            splashRadius: 20.r,
          ),
        ),
        ],
      ) ,

      body: BlocBuilder<LastTenDuasCubit, LastTenDuasState>(
        builder: (context, state) {
          if (state is LastTenDuasLoading) {
            return Center(
              child: CupertinoActivityIndicator(color: Colors.teal.shade700),
            );
          }

          if (state is LastTenDuasLoaded) {
            final dua = state.duas;

            return ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              itemCount: dua.length,
              itemBuilder: (context, index) {
                return ValueListenableBuilder(
                  valueListenable: _fontSizeNotifire,
                  builder: (context, fontSize, child) {
                    return DuaCard(
                      fontSize: fontSize,
                      content: dua[index].content,
                      onCopy: () {
                        copyText(context, dua[index].content);
                      },
                      onShare: () {
                        shareText(dua[index].content);
                      },
                    );
                  },
                );
              },
            );
          } else if (state is LastTenDuasError) {
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
