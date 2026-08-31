import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/quran_audio/logic/quran_audio_state.dart';
import 'package:hisn_almuslim/features/quran_audio/ui/widgets/reciter_selector_button.dart';
import '../../../../core/shared/custom_text.dart';
import '../../../../core/shared/search_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../logic/audio_player_cubit.dart';
import '../../logic/quran_audio_cubit.dart';

class QuranAudioHeader extends StatelessWidget {
  final QuranAudioState state;
  final void Function(String) onSearch;
  final TextEditingController? searchController;

  const QuranAudioHeader({
    super.key,
    required this.state,
    required this.onSearch,
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final double statusBarHeight = MediaQuery.paddingOf(context).top;


    final backgroundColors = isDark
        ? const [Color(0xFF155A52), Color(0xFF0C3934)]
        : const [Color(0xFF0F9F8E), Color(0xFF08796D)];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, statusBarHeight + 8.h, 16.w, 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(45.r),
          bottomRight: Radius.circular(45.r),
        ),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: backgroundColors,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimary.withValues(alpha: 0.28),
            blurRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildTopBar(context, isDark),
          Align(
            alignment: Alignment.topRight,
            child: _headerIconButton(
              icon: Icons.arrow_back_ios_rounded,
              isDark: isDark,
              onTap: () => Navigator.pop(context),
            ),
          ),
          Gap(12.h),
          _buildReciterSection(context, state),
          Gap(18.h),
          SearchField(
            onChanged: onSearch,
            hint: 'ابحث في السور ...',
            controller: searchController,
          ),
        ],
      ),
    );
  }
}

Widget _buildReciterSection(BuildContext context, QuranAudioState state) {
  if (state is QuranAudioLoaded) {
    final audioCubit = context.read<AudioPlayerCubit>();

    return BlocProvider.value(
      value: audioCubit,
      child: ReciterSelectorButton(
        currentReciter: state.effectiveSelectedReciter,
        reciters: state.reciters,
        onReciterSelected: (reciter) {
          context.read<QuranAudioCubit>().selectReciter(reciter);
        },
      ),
    );
  } else if (state is QuranAudioLoading) {
    return _glassContainer(
      child: Row(
        spacing: 12.w,
        children: [
          SizedBox(
            height: 18.h,
            width: 18.w,
            child: const CupertinoActivityIndicator(color: Colors.white),
          ),
          CustomText(
            'جاري تحميل القراء...',
            color: Colors.white,
            fontSize: 11.sp,
          ),
        ],
      ),
    );
  } else if (state is QuranAudioError) {
    return _glassContainer(
      child: Row(
        spacing: 12.w,
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.white),
          Expanded(child: CustomText(state.message, color: Colors.white)),
        ],
      ),
    );
  }
  return const SizedBox.shrink();
}

Widget _glassContainer({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(18.r),
      border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}

Widget _buildTopBar(BuildContext context, bool isDark) {
  return Row(
    children: [
      _headerIconButton(
        icon: Icons.arrow_back_ios_rounded,
        isDark: isDark,
        onTap: () => Navigator.pop(context),
      ),
      Gap(12.w),
      Icon(FlutterIslamicIcons.solidQuran2, color: Colors.white, size: 20.sp),
      Gap(8.w),
      Expanded(
        child: CustomText(
          'المصحف (صوتيات)',
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          maxLines: 1,
        ),
      ),
    ],
  );
}

Widget _headerIconButton({
  required IconData icon,
  required bool isDark,
  required VoidCallback onTap,
}) {
  return Material(
    color: isDark
        ? Colors.teal.shade900.withValues(alpha: 0.3)
        : Colors.white.withValues(alpha: 0.15),
    shape: const CircleBorder(),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: SizedBox(
        width: 28.w,
        height: 28.h,
        child: Icon(icon, color: Colors.white, size: 16.sp),
      ),
    ),
  );
}
