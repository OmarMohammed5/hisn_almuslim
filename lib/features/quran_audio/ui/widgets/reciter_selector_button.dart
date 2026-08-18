import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/reciter_model.dart';
import '../../logic/audio_player_cubit.dart';
import '../../logic/audio_player_state.dart';
import 'reciter_selection_dialog.dart';

class ReciterSelectorButton extends StatefulWidget {
  final ReciterModel? currentReciter;
  final List<ReciterModel> reciters;
  final Function(ReciterModel) onReciterSelected;

  const ReciterSelectorButton({
    super.key,
    required this.currentReciter,
    required this.reciters,
    required this.onReciterSelected,
  });

  @override
  State<ReciterSelectorButton> createState() => _ReciterSelectorButtonState();
}

class _ReciterSelectorButtonState extends State<ReciterSelectorButton> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
      buildWhen: (previous, current) {
        if (previous is AudioPlayerReady && current is AudioPlayerReady) {
          return previous.isPlaying != current.isPlaying ||
              previous.surah != current.surah ||
              previous.isCompleted != current.isCompleted;
        }
        return current is AudioPlayerReady;
      },
      builder: (context, state) {
        final isPlaying = state is AudioPlayerReady && state.isPlaying && !state.isCompleted;
        final currentSurah = state is AudioPlayerReady ? state.surah : null;

        return GestureDetector(
          onTap: _showReciterSelectionDialog,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                  const Color(0xFF1A2332),
                  const Color(0xFF0F1621),
                ]
                    : [
                  Colors.white,
                  const Color(0xFFF8FAFC),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.grey.shade200,
                width: 1.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.grey.shade200.withValues(alpha: 0.5),
                  blurRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildReciterAvatar(isPlaying, isDark),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.kPrimary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: CustomText(
                              'القارئ الشيخ',
                              color: AppColors.kPrimary,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isPlaying && currentSurah != null) ...[
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 5.w,
                                    height: 5.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  CustomText(
                                    'يتلى الآن',
                                    color: Colors.green,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      Gap(6.h),
                      CustomText(
                        widget.currentReciter?.reciter.ar ?? 'اختر القارئ',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF1A2332),
                        maxLines: 1,
                      ),
                      if (widget.currentReciter != null)
                        Gap(6.h),
                      Row(
                          children: [
                            Icon(
                              Icons.menu_book_outlined,
                              size: 12.sp,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.4)
                                  : Colors.grey.shade600,
                            ),
                            SizedBox(width: 4.w),
                            CustomText(
                              "رواية ${widget.currentReciter!.rewaya.ar}",
                              maxLines: 1,
                              fontSize: 11.sp,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.4)
                                  : Colors.grey.shade600,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.kPrimary.withValues(alpha: 0.15),
                        AppColors.kPrimary.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.kPrimary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.swap_horiz_rounded,
                        color: AppColors.kPrimary,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      CustomText(
                        'تبديل',
                        color: AppColors.kPrimary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReciterAvatar(bool isPlaying, bool isDark) {
    final hasReciter = widget.currentReciter != null;
    final reciterIndex = hasReciter
        ? widget.reciters.indexWhere((r) => r.id == widget.currentReciter!.id) + 1
        : 0;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: hasReciter
                  ? [
                AppColors.kPrimary.withValues(alpha: 0.2),
                AppColors.kPrimary.withValues(alpha: 0.05),
              ]
                  : isDark
                  ? [
                Colors.white.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.02),
              ]
                  : [
                Colors.grey.shade200,
                Colors.grey.shade100,
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: hasReciter
                  ? AppColors.kPrimary.withValues(alpha: 0.4)
                  : isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.grey.shade300,
              width: 1.5.w,
            ),
          ),
          child: Center(
            child: hasReciter
                ? CustomText(
              '$reciterIndex',
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.kPrimary,
            )
                : Icon(
              Icons.person_search_rounded,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.3)
                  : Colors.grey.shade500,
              size: 22.sp,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPlaying ? Colors.green : Colors.grey.shade400,
              border: Border.all(
                color: isDark ? const Color(0xFF1A2332) : Colors.white,
                width: 2.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showReciterSelectionDialog() {
    showReciterSelectionDialog(
      context,
      currentReciter: widget.currentReciter,
      reciters: widget.reciters,
      onReciterSelected: widget.onReciterSelected,
    );
  }
}