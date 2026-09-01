import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/hajj%20and%20omra/hajj_dua_cubit.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/models/hajj_items.dart';
import 'package:hisn_almuslim/features/jami%20dua/widgets/dua_card.dart';
import 'package:hisn_almuslim/core/helpers/share_helper.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../core/shared/app_bar_widget.dart';
import '../../../core/shared/custom_snack_bar.dart';
import '../../../core/utils/control_font_size.dart';

class HajjAndOmraDetails extends StatefulWidget {
  const HajjAndOmraDetails({
    super.key,
    required this.hajjItems,
    required this.title,
  });
  final List<HajjItems> hajjItems;
  final String title;

  @override
  State<HajjAndOmraDetails> createState() => _HajjAndOmraDetailsState();
}

class _HajjAndOmraDetailsState extends State<HajjAndOmraDetails> {
  final ValueNotifier<double> _fontSizeNotifier = ValueNotifier<double>(18);

  void copyText(String content) {
    Clipboard.setData(ClipboardData(text: content));

    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar("تم النسخ", Icons.check_circle_outline, context),
    );
  }

  void shareText(String content) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ShareHelper.shareAsImage(context, content, isDark: isDark ,category: widget.title );
  }

  @override
  void dispose() {
    _fontSizeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidget(
        title: widget.title,
        actions: [   Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1A2723)
                  : const Color(0xFFEAF2F0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
                side: BorderSide(
                  color: const Color(0xFF087F73).withValues(alpha: .14),
                ),
              ),
            ),
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

      body: BlocBuilder<HajjDuaCubit, HajjDuaState>(
        builder: (context, state) {
          if (state is HajjDuaLoading) {
            return Center(
              child: CupertinoActivityIndicator(color: Colors.teal.shade700),
            );
          }

          if (state is HajjDuaLoaded) {
            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: widget.hajjItems.length,
              itemBuilder: (context, index) {
                return ValueListenableBuilder(
                  valueListenable: _fontSizeNotifier,
                  builder: (context, fontSize, child) {
                    return DuaCard(
                      title: widget.hajjItems[index].title,
                      content: widget.hajjItems[index].content,
                      onCopy: () => copyText(widget.hajjItems[index].content),
                      onShare: () => shareText(widget.hajjItems[index].content),
                      fontSize: fontSize,
                    );
                  },
                );
              },
            );
          } else if (state is HajjDuaError) {
            return Center(child: CustomText(state.message));
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
