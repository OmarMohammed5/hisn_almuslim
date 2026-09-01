import 'package:flutter/material.dart';
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
      toolbarHeight: 58.h,
      leadingWidth: 52.w,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          final surah = state is SurahPagesLoaded ? state.surah : null;
          return Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 3.h,
            children: [
              Text(
                surah?.displayName ?? 'سورة',
                style: TextStyle(
                  fontFamily: 'Noon',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.text,
                ),
              ),
              if (surah != null)
                Text(
                  '${surah.totalAyahs} آيات',
                  style: TextStyle(
                    fontSize: 8.5.sp,
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
          icon: Icon(Icons.tune_rounded, size: 21.sp),
          onPressed: onSettingsPressed,
        ),
        SizedBox(width: 5.w),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(58.h);
}