import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/quran_audio/data/models/surah_audio_model.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/reciter_model.dart';
import '../../logic/audio_player_cubit.dart';
import '../../logic/audio_player_state.dart';
import '../widgets/audio_player_controls.dart';
import '../widgets/audio_progress_slider.dart';
import '../widgets/now_playing_header.dart';
import '../widgets/player_background.dart';
import '../widgets/player_bottom_card.dart';
import '../widgets/rotating_artwork.dart';
import '../widgets/surah_title.dart';

class AudioPlayerScreen extends StatefulWidget {
  final SurahAudioModel surah;
  final ReciterModel reciter;
  final String audioUrl;

  const AudioPlayerScreen({
    super.key,
    required this.surah,
    required this.reciter,
    required this.audioUrl,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AudioPlayerCubit()
        ..initializePlayer(
          audioUrl: widget.audioUrl,
          surah: widget.surah,
          reciter: widget.reciter,
        ),
      child: Builder(
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              // await context.read<AudioPlayerCubit>().disposePlayer();
              return true;
            },
            child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              body: PlayerBackground(
                child: SafeArea(
                  child: BlocConsumer<AudioPlayerCubit, AudioPlayerState>(
                    listener: (context, state) {
                      if (state is AudioPlayerError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${state.message}'),
                            backgroundColor: Colors.red.shade700,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          NowPlayingHeader(
                            onBack: () async {
                              // final cubit = context.read<AudioPlayerCubit>();
                              // await cubit.disposePlayer();
                              // if (context.mounted)
                              Navigator.pop(context);
                            },
                            reciterName: widget.reciter.reciter.ar,
                            rewaya: null,
                          ),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _buildBody(context, state),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, AudioPlayerState state) {
    if (state is AudioPlayerInitial || state is AudioPlayerLoading) {
      return _buildLoadingState(key: const ValueKey('loading'));
    } else if (state is AudioPlayerError) {
      return _buildErrorState(context, state, key: const ValueKey('error'));
    } else if (state is AudioPlayerReady) {
      return _buildPlayerUI(context, state, key: const ValueKey('ready'));
    }
    return const SizedBox.shrink(key: ValueKey('empty'));
  }

  Widget _buildLoadingState({Key? key}) {
    return Center(
      key: key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(color: Colors.white),
          SizedBox(height: 16.h),
          Text(
            'جاري تحميل الصوت...',
            style: TextStyle(color: Colors.white70, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    AudioPlayerError state, {
    Key? key,
  }) {
    return Center(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.white70,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load audio',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.kPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerUI(
    BuildContext context,
    AudioPlayerReady state, {
    Key? key,
  }) {
    return LayoutBuilder(
      key: key,
      builder: (context, constraints) {
        // Keeps the layout comfortable on small phones, large phones,
        // and tablets alike.
        final bool isCompact = constraints.maxHeight < 640;
        final double artworkSize = constraints.maxWidth > 500
            ? 260
            : (isCompact ? 190 : 220);

        final Widget topSection = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: isCompact ? 12.h : 28.h),
            RotatingArtwork(
              isPlaying: state.isPlaying,
              size: artworkSize,
              child: _buildArtworkFace(state),
            ),
            SizedBox(height: isCompact ? 20.h : 32.h),
            SurahTitle(
              arabicName: state.surah.nameArabic,
              englishName: state.surah.nameEnglish,
            ),
          ],
        );

        final Widget bottomSection = Padding(
          padding: EdgeInsets.only(bottom: isCompact ? 12.h : 50.h),
          child: PlayerBottomCard(
            slider: AudioProgressSlider(
              currentPosition: state.currentPosition,
              totalDuration: state.totalDuration,
              onSeek: (position) =>
                  context.read<AudioPlayerCubit>().seek(position),
            ),
            timeRow: _buildTimeDisplay(
              context,
              state.currentPosition,
              state.totalDuration,
            ),
            controls: AnimatedScale(
              scale: state.isPlaying ? 1.0 : 0.96,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: AudioPlayerControls(
                isPlaying: state.isPlaying,
                isBuffering: state.isBuffering,
                onPlayPause: () =>
                    context.read<AudioPlayerCubit>().togglePlayPause(),
              ),
            ),
            speedControl: _buildSpeedControl(context, state),
            // bottomInfo: StreamingIndicator(
            //   sourceLabel: 'Streaming from MP3 Quran',
            // ),
          ),
        );

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [topSection, bottomSection],
          ),
        );
      },
    );
  }

  /////////////
  Widget _buildArtworkFace(AudioPlayerReady state) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset(
          'assets/icons/loogo.png',
          // "assets/icons/mm.png",
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Text(
            '${state.surah.number}',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
              fontFamily: 'Al mushaf',
              color: AppColors.kPrimary,
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildArtworkFace(AudioPlayerReady state) {
  //   return Icon(Icons.headphones_outlined , color: Colors.white,size: 170.sp,);
  // }

  Widget _buildTimeDisplay(
    BuildContext context,
    Duration currentPosition,
    Duration totalDuration,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            AudioPlayerCubit.formatDuration(currentPosition),
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12.sp,
          ),
          CustomText(
            AudioPlayerCubit.formatDuration(totalDuration),
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 12.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedControl(BuildContext context, AudioPlayerReady state) {
    final cubit = context.read<AudioPlayerCubit>();
    final speed = state.speed;

    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: () => _showSpeedSheet(context, cubit, speed),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6.w,
          children: [
            const Icon(Icons.speed_rounded, size: 16, color: Colors.white),
            CustomText(
              '${speed}x',
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showSpeedSheet(
    BuildContext context,
    AudioPlayerCubit cubit,
    double? currentSpeed,
  ) {
    const speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF10333A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 6.h,
            children: [
              CustomText(
                'سرعة التشغيل',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              ...speeds.map((speed) {
                final isSelected = speed == currentSpeed;
                return ListTile(
                  onTap: () {
                    cubit.setSpeed(speed);
                    Navigator.pop(context);
                  },
                  title: Text(
                    '${speed}x',
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          color: Color(0xFF2ED9B8),
                        )
                      : null,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
