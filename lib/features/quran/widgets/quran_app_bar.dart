import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/cubit/quran_cubit.dart';
import '../data/cubit/quran_state.dart';

class QuranAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int surahNumber;
  final VoidCallback onSettingsPressed;
  final dynamic colors;

  const QuranAppBar({
    super.key,
    required this.surahNumber,
    required this.onSettingsPressed,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: AppResponsive.heightValue(context, 58),
      leadingWidth: AppResponsive.widthValue(context, 52),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, size: AppResponsive.fontSize(context, 20)),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          final surah = state is SurahPagesLoaded ? state.surah : null;
          return Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppResponsive.heightValue(context, 3),
            children: [
              Text(
                surah?.displayName ?? 'سورة',
                style: TextStyle(
                  fontFamily: 'Noon',
                  fontSize: AppResponsive.fontSize(context, 15),
                  fontWeight: FontWeight.w700,
                  color: colors.text,
                ),
              ),
              if (surah != null)
                Text(
                  '${surah.totalAyahs} آيات',
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 8.5),
                    color: colors.text.withValues(alpha: .48),
                  ),
                ),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          tooltip: 'إعدادات القراءة',
          icon: Icon(Icons.tune_rounded, size: AppResponsive.fontSize(context, 21)),
          onPressed: onSettingsPressed,
        ),
        SizedBox(width: AppResponsive.widthValue(context, 5)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(58);
}