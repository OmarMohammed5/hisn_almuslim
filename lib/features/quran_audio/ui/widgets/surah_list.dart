import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/responsive/app_responsive.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/quran_audio/data/models/surah_audio_model.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/features/quran_audio/ui/widgets/surah_tile.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/reciter_model.dart';
import '../../logic/audio_player_cubit.dart';
import '../../logic/audio_player_state.dart';
import 'audio_wave_animation.dart';

class SurahList extends StatelessWidget {
  final List<SurahAudioModel> surahs;
  final ReciterModel selectedReciter;
  final Function(int) onSurahPressed;
  final ScrollController? controller;

  const SurahList({
    super.key,
    required this.surahs,
    required this.selectedReciter,
    required this.onSurahPressed,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
      buildWhen: (previous, current) {
        if (previous is AudioPlayerReady && current is AudioPlayerReady) {
          return previous.surah != current.surah ||
              previous.isPlaying != current.isPlaying ||
              previous.isCompleted != current.isCompleted;
        }
        return current is AudioPlayerReady;
      },
      builder: (context, state) {
        final currentSurahNumber = state is AudioPlayerReady ? state.surah.number : -1;


        /// Cases
        final isPlaying = state is AudioPlayerReady && state.isPlaying && !state.isCompleted;
        final isPaused = state is AudioPlayerReady && !state.isPlaying && !state.isCompleted;
        final isCompleted = state is AudioPlayerReady && state.isCompleted;

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isTablet = width >= 700;
            final isDesktop = width >= 1100;
            final columns = isDesktop ? 3 : (isTablet ? 2 : 1);

            final horizontalPadding =
                AppResponsive.widthValue(context, isTablet ? 8 : 4);
            final bottomPadding =
                AppResponsive.heightValue(context, isTablet ? 28 : 90);

            Widget itemBuilder(BuildContext context, int index) {
              final surah = surahs[index];
              final isCurrentSurah = surah.number == currentSurahNumber;

              return SurahTile(
                surah: surah,
                index: index,
                isCurrentSurah: isCurrentSurah,
                isPlaying: isPlaying,
                isPaused: isPaused,
                isCompleted: isCompleted,
                onPressed: () => onSurahPressed(surah.number),
              );
            }

            if (columns == 1) {
              return ListView.builder(
                controller: controller,
                padding: EdgeInsets.only(
                  top: AppResponsive.heightValue(context, 4),
                  bottom: bottomPadding,
                  left: horizontalPadding,
                  right: horizontalPadding,
                ),
                itemCount: surahs.length,
                itemBuilder: itemBuilder,
              );
            }

            return GridView.builder(
              controller: controller,
              padding: EdgeInsets.only(
                top: AppResponsive.heightValue(context, 4),
                bottom: bottomPadding,
                left: horizontalPadding,
                right: horizontalPadding,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: AppResponsive.widthValue(context, 12),
                mainAxisSpacing: AppResponsive.heightValue(context, 8),
                childAspectRatio: isDesktop ? 2.45 : 2.2,
              ),
              itemCount: surahs.length,
              itemBuilder: itemBuilder,
            );
          },
        );
      },
    );
  }
}