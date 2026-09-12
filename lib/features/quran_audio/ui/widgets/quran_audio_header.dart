import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
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

    final background = isDark
        ? AppColors.kSurfaceDark
        : const Color(0xFF087F73);

    final primary = AppColors.kPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppResponsive.widthValue(context, 16),
        statusBarHeight + AppResponsive.heightValue(context, 8),
        AppResponsive.widthValue(context, 16),
        AppResponsive.heightValue(context, 16),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppResponsive.radius(context, 45)),
          bottomRight: Radius.circular(AppResponsive.radius(context, 45)),
        ),
        color: background,
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: isDark ? .12 : .16),
            blurRadius: 2.r,
            offset: Offset(0, 2.h),
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
              context: context,
              icon: Icons.arrow_back_ios_rounded,
              isDark: isDark,
              onTap: () => Navigator.pop(context),
            ),
          ),
          Gap(AppResponsive.heightValue(context, 12)),
          _buildReciterSection(context, state),
          Gap(AppResponsive.heightValue(context, 18)),
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
      context: context,
      child: Row(
        spacing: AppResponsive.widthValue(context, 12),
        children: [
          SizedBox(
            height: AppResponsive.heightValue(context, 18),
            width: AppResponsive.widthValue(context, 18),
            child: const CupertinoActivityIndicator(color: Colors.white),
          ),
          CustomText(
            'جاري تحميل القراء...',
            color: Colors.white,
            fontSize: AppResponsive.fontSize(context, 11),
          ),
        ],
      ),
    );
  } else if (state is QuranAudioError) {
    return _glassContainer(
      context: context,
      child: Row(
        spacing: AppResponsive.widthValue(context, 12),
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.white),
          Expanded(child: CustomText(state.message, color: Colors.white)),
        ],
      ),
    );
  }
  return const SizedBox.shrink();
}

Widget _glassContainer({required BuildContext context, required Widget child}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(
      vertical: AppResponsive.heightValue(context, 14),
      horizontal: AppResponsive.widthValue(context, 16),
    ),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(AppResponsive.radius(context, 18)),
      border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 2,
          offset: const Offset(0, 2),
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
        context: context,
        icon: Icons.arrow_back_ios_rounded,
        isDark: isDark,
        onTap: () => Navigator.pop(context),
      ),
      Gap(AppResponsive.widthValue(context, 12)),
      Icon(FlutterIslamicIcons.solidQuran2, color: Colors.white, size: 20.sp),
      Gap(AppResponsive.widthValue(context, 8)),
      Expanded(
        child: CustomText(
          'المصحف (صوتيات)',
          color: Colors.white,
          fontSize: AppResponsive.fontSize(context, 14),
          fontWeight: FontWeight.bold,
          maxLines: 1,
        ),
      ),
    ],
  );
}

Widget _headerIconButton({
  required BuildContext context,
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
        width: AppResponsive.widthValue(context, 30),
        height: AppResponsive.heightValue(context, 30),
        child: Icon(icon, color: Colors.white, size: AppResponsive.iconSize(context, 17),),
      ),
    ),
  );
}
