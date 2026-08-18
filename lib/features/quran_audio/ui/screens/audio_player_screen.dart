import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/quran_audio/data/models/surah_audio_model.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/reciter_model.dart';
import '../../logic/audio_player_cubit.dart';
import '../../logic/audio_player_state.dart';
import '../widgets/player_artwork_square.dart';
import '../widgets/player_control_card.dart';
import '../widgets/player_controls_row.dart';
import '../widgets/player_gradient_background.dart';


class AudioPlayerScreen extends StatefulWidget {
  final SurahAudioModel surah;
  final ReciterModel reciter;
  final String audioUrl;
  final List<SurahAudioModel> surahs;

  const AudioPlayerScreen({
    super.key,
    required this.surah,
    required this.reciter,
    required this.audioUrl,
    this.surahs = const [],
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized && mounted) {
        _initializePlayer();
      }
    });
  }

  void _initializePlayer() {
    if (_initialized) return;
    _initialized = true;
    final cubit = context.read<AudioPlayerCubit>();
    cubit.initializePlayer(
      audioUrl: widget.audioUrl,
      surah: widget.surah,
      reciter: widget.reciter,
      surahs: widget.surahs,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PlayerGradientBackground(
        surahNumber: widget.surah.number,
        child: SafeArea(
          child: BlocConsumer<AudioPlayerCubit, AudioPlayerState>(
            listener: (context, state) {
              if (state is AudioPlayerError && state.shouldShow) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red.shade700,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            buildWhen: (previous, current) {
              if (previous.runtimeType != current.runtimeType) return true;
              if (previous is AudioPlayerReady && current is AudioPlayerReady) {
                return previous.isPlaying != current.isPlaying ||
                    previous.isBuffering != current.isBuffering ||
                    previous.speed != current.speed ||
                    previous.isCompleted != current.isCompleted ||
                    previous.currentPosition != current.currentPosition ||
                    previous.totalDuration != current.totalDuration;
              }
              return true;
            },
            builder: (context, state) {
              return Column(
                children: [
                  _buildTopBar(context),
                  Expanded(child: _buildBody(context, state)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // 1. TOP HEADER ------------------------------------------------------
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      child: Row(
        children: [
          Material(
            color: Colors.white.withValues(alpha: 0.08),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: EdgeInsets.all(9.w),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18.sp,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'يُتلى الآن',
              textAlign: TextAlign.center,
              style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
                fontFamily: "QuranFont",
              ),
            ),
          ),
          SizedBox(width: 38.w),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, AudioPlayerState state) {
    if (state is AudioPlayerReady) {
      return _buildReady(context, state);
    }
    if (state is AudioPlayerError) {
      return _buildError(context, state);
    }
    if (state is AudioPlayerLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16.h),
            CustomText(
              state.message ?? 'جاري التحميل...',
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14.sp,
            ),
          ],
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16.h),
          CustomText(
            'جاري تجهيز الصوت...',
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14.sp,
          ),
        ],
      ),
    );
  }


  Widget _buildReady(BuildContext context, AudioPlayerReady state) {
    final cubit = context.read<AudioPlayerCubit>();

    final reciterName = widget.reciter.reciter.ar;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxHeight < 640;

        return Column(
          children: [
            SizedBox(height: isCompact ? 10.h : 22.h),
            PlayerArtworkSquare(
              size: isCompact ? 130 : 155,
              child: _artworkFace(state),
            ),
            SizedBox(height: isCompact ? 16.h : 26.h),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: PlayerControlCard(
                  arabicTitle: state.surah.nameArabic,
                  reciterName: reciterName,
                  riwayaText: null,
                  progressSlider: _buildSlider(state, cubit),
                  timeRow: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          AudioPlayerCubit.formatDuration(
                              state.currentPosition),
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 11.sp,
                        ),
                        CustomText(
                          AudioPlayerCubit.formatDuration(
                              state.totalDuration),
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 11.sp,
                        ),
                      ],
                    ),
                  ),
                  controlsRow: PlayerControlsRow(
                    isPlaying: state.isPlaying,
                    isBuffering: state.isBuffering,
                    onPlayPause: cubit.togglePlayPause,
                    onSeekBack: () => cubit.seek(
                      state.currentPosition - const Duration(seconds: 10),
                    ),
                    onSeekForward: () => cubit.seek(
                      state.currentPosition + const Duration(seconds: 10),
                    ),
                    onPrevious: cubit.playPrevious,
                    onNext: cubit.playNext,
                    hasPrevious: state.currentSurahIndex > 0,
                    hasNext:
                    state.currentSurahIndex < state.surahs.length - 1,
                  ),
                  speedChip: _speedChip(context, cubit, state.speed),
                  completionMode:
                  _buildCompletionModeSelector(context, cubit, state),
                ),
              ),
            ),
            SizedBox(height: isCompact ? 8.h : 14.h),
          ],
        );
      },
    );
  }


  Widget _buildSlider(AudioPlayerReady state, AudioPlayerCubit cubit) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 2.5.h,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
        activeTrackColor: AppColors.kPrimary,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.16),
        thumbColor: AppColors.kPrimary,
        overlayColor: AppColors.kPrimary.withValues(alpha: 0.15),
      ),
      child: Slider(
        value: state.currentPosition.inMilliseconds
            .clamp(0, state.totalDuration.inMilliseconds)
            .toDouble(),
        max: state.totalDuration.inMilliseconds
            .toDouble()
            .clamp(1, double.infinity),
        onChanged: (value) {
          cubit.seek(Duration(milliseconds: value.round()));
        },
      ),
    );
  }


  Widget _buildCompletionModeSelector(
      BuildContext context,
      AudioPlayerCubit cubit,
      AudioPlayerReady state,
      ) {
    final modes = CompletionMode.values;
    final labels = {
      CompletionMode.continueToNext: 'التالي',
      CompletionMode.repeatCurrent: 'تكرار',
      CompletionMode.stopAfterCurrent: 'إيقاف',
      CompletionMode.manual: 'يدوي',
    };

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: modes.map((mode) {
          final isSelected = state.completionMode == mode;
          return Expanded(
            child: GestureDetector(
              onTap: () => cubit.setCompletionMode(mode),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.kPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[mode]!,
                  style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.55),
                  fontSize: 13.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontFamily: "QuranFont",
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _artworkFace(AudioPlayerReady state) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFFBF6EC),
      ),
      child: Container(
        margin: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFC9A24B).withValues(alpha: 0.55),
            width: 1.4.w,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(18.w),
            child: Image.asset(
              'assets/icons/loogo.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Text(
                '${state.surah.number}',
                style: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Al mushaf',
                  color: AppColors.kPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _speedChip(
      BuildContext context,
      AudioPlayerCubit cubit,
      double? speed,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: () => _showSpeedSheet(context, cubit, speed),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              '${speed ?? 1.0}x',
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
            SizedBox(width: 6.w),
            Icon(
              Icons.replay_rounded,
              size: 15.sp,
              color: Colors.white.withValues(alpha: 0.75),
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
            children: [
              CustomText(
                'سرعة التشغيل',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              SizedBox(height: 6.h),
              ...speeds.map((speed) {
                final isSelected = speed == currentSpeed;
                return ListTile(
                  onTap: () {
                    cubit.setSpeed(speed);
                    Navigator.pop(context);
                  },
                  title: Text('${speed}x',
                      style: const TextStyle(color: Colors.white)),
                  trailing: isSelected
                      ? const Icon(Icons.check_rounded,
                      color: Color(0xFF2ED9B8))
                      : null,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, AudioPlayerError state) {
    if (!state.shouldShow) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.sp,
              color: Colors.white70,
            ),
            SizedBox(height: 16.h),
            CustomText(
              'تعذر تشغيل الصوت',
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 8.h),
            CustomText(
              state.message,
              color: Colors.white70,
              fontSize: 14.sp,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            if (state.isRetryable)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.kPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  padding:
                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                ),
                onPressed: () => context.read<AudioPlayerCubit>().retry(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('إعادة المحاولة'),
              )
            else
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.kPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  padding:
                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('رجوع'),
              ),
          ],
        ),
      ),
    );
  }
}