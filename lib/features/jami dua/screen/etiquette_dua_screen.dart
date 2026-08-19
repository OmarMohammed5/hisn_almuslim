import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/utils/control_font_size.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/etiquette%20dua/etiquette_dua_cubit.dart';
import 'package:hisn_almuslim/features/jami%20dua/widgets/etiquette_card.dart';
import 'package:hisn_almuslim/core/helpers/share_helper.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../core/shared/app_bar_widget.dart';
import '../../../core/shared/custom_snack_bar.dart';

class EtiquetteDuaScreen extends StatefulWidget {
  const EtiquetteDuaScreen({super.key});

  @override
  State<EtiquetteDuaScreen> createState() => _EtiquetteDuaScreenState();
}

class _EtiquetteDuaScreenState extends State<EtiquetteDuaScreen> {
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
    ShareHelper.shareAsImage(context, text, isDark: isDark ,category:'آداب الدعاء' );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidget(
        title: 'آداب الدعاء',
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

      body: BlocBuilder<EtiquetteDuaCubit, EtiquetteDuaState>(
        builder: (context, state) {
          if (state is EtiquetteDuaLoading) {
            return Center(
              child: CupertinoActivityIndicator(color: Colors.teal.shade700),
            );
          }

          if (state is EtiquetteDuaLoaded) {
            final items = state.items;
            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ValueListenableBuilder(
                  valueListenable: _fontSizeNotifire,
                  builder: (context, fontSize, child) {
                    return EtiquetteCard(
                      fontSize: fontSize.sp,
                      item: items[index],
                      onCopy: () {
                        copyText(context, items[index].arabic);
                      },
                      onShare: () {
                        shareText(items[index].arabic);
                      },
                    );
                  },
                );
              },
            );
          } else if (state is EtiquetteDuaError) {
            return CustomText(state.message);
          } else {
            return SizedBox.fromSize();
          }
        },
      ),
    );
  }
}
