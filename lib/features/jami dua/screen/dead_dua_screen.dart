import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/utils/control_font_size.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/dead%20dua/dead_dua_cubit.dart';
import 'package:hisn_almuslim/features/jami%20dua/widgets/dua_card.dart';
import 'package:hisn_almuslim/core/helpers/share_helper.dart';
import '../../../core/shared/app_bar_widget.dart';
import '../../../core/shared/custom_snack_bar.dart';
import '../../../core/shared/re_build_scroll_To_Top.dart';

class DeadDuaScreen extends StatefulWidget {
  const DeadDuaScreen({super.key});

  @override
  State<DeadDuaScreen> createState() => _DeadDuaScreenState();
}

class _DeadDuaScreenState extends State<DeadDuaScreen> {
  /// 🔠 Font Size Controller
  final ValueNotifier<double> _fontSizeNotifier = ValueNotifier(18);

  /// Scroll
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier(false);

  @override
  void initState() {
    _scrollController.addListener(() {
      _showScrollToTop.value = _scrollController.offset > 300;
    });
    super.initState();
  }

  @override
  void dispose() {
    _fontSizeNotifier.dispose();
    _scrollController.dispose();
    _showScrollToTop.dispose();
    super.dispose();
  }

  // Copy & Share
  void copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar("تم النسخ", Icons.check_circle_outline, context),
    );
  }

  void shareText(String content) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ShareHelper.shareAsImage(context, content, isDark: isDark ,category: "دعاء للمتوفي" );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(
        title: 'أدعية للمتوفي',
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
              fontSizeNotifire: _fontSizeNotifier,
            ),
            splashRadius: 20.r,
          ),
        ),
        ],
      ) ,

      body: BlocBuilder<DeadDuaCubit, DeadDuaState>(
        builder: (context, state) {
          if (state is DeadDuaLoading) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (state is DeadDuaLoaded) {
            return ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              itemCount: state.duas.length,
              itemBuilder: (context, index) {
                return ValueListenableBuilder<double>(
                  valueListenable: _fontSizeNotifier,
                  builder: (context, fontSize, _) {
                    return DuaCard(
                      content: state.duas[index].content,
                      fontSize: fontSize,
                      onCopy: () => copyText(state.duas[index].content),
                      onShare: () => shareText(state.duas[index].content),
                    );
                  },
                );
              },
            );
          }

          return const SizedBox();
        },
      ),

      floatingActionButton: ReBuildScrollToTop(
        showScrollToTop: _showScrollToTop,
        scrollController: _scrollController,
      ),
    );
  }
}
