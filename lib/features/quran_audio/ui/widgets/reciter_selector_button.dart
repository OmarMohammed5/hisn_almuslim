import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/responsive/app_responsive.dart';
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

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

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
        final isPlaying =
            state is AudioPlayerReady && state.isPlaying && !state.isCompleted;
        final currentSurah = state is AudioPlayerReady ? state.surah : null;

        return LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 360;

            return GestureDetector(
              onTap: _showReciterSelectionDialog,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.widthValue(
                    context,
                    compact ? 10 : 16,
                  ),
                  vertical: AppResponsive.heightValue(
                    context,
                    compact ? 9 : 12,
                  ),
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  border: Border.all(
                    color: borderColor,
                    width: AppResponsive.widthValue(context, 1),
                  ),
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 25),
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
                    Gap(AppResponsive.widthValue(context, 14)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppResponsive.widthValue(
                                    context,
                                    8,
                                  ),
                                  vertical: AppResponsive.heightValue(
                                    context,
                                    3,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.kPrimary.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: CustomText(
                                  'القارئ الشيخ',
                                  color: AppColors.kPrimary,
                                  fontSize: AppResponsive.fontSize(context, 9),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (isPlaying && currentSurah != null) ...[
                                Gap(AppResponsive.widthValue(context, 6)),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppResponsive.widthValue(
                                      context,
                                      8,
                                    ),
                                    vertical: AppResponsive.heightValue(
                                      context,
                                      2,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(
                                      AppResponsive.radius(context, 6),
                                    ),
                                    border: Border.all(
                                      color: Colors.green.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: AppResponsive.widthValue(
                                          context,
                                          6,
                                        ),
                                        height: AppResponsive.heightValue(
                                          context,
                                          6,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Gap(AppResponsive.widthValue(context, 4)),
                                      CustomText(
                                        'يتلى الآن',
                                        color: Colors.green,
                                        fontSize: AppResponsive.fontSize(
                                          context,
                                          8,
                                        ),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Gap(AppResponsive.heightValue(context, 6)),
                          CustomText(
                            widget.currentReciter?.reciter.ar ?? 'اختر القارئ',
                            fontSize: AppResponsive.fontSize(context, 12.4),
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1A2332),
                            maxLines: 1,
                          ),
                          if (widget.currentReciter != null)
                            Gap(AppResponsive.heightValue(context, 6)),
                          Row(
                            children: [
                              Icon(
                                Icons.menu_book_outlined,
                                size: AppResponsive.iconSize(context, 12),
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.4)
                                    : Colors.grey.shade600,
                              ),
                              Gap(AppResponsive.widthValue(context, 4)),
                              CustomText(
                                "رواية ${widget.currentReciter!.rewaya.ar}",
                                maxLines: 1,
                                fontSize: AppResponsive.fontSize(context, 10),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.widthValue(
                          context,
                          compact ? 7 : 12,
                        ),
                        vertical: AppResponsive.heightValue(
                          context,
                          compact ? 6 : 8,
                        ),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.kPrimary.withValues(alpha: 0.15),
                            AppColors.kPrimary.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          AppResponsive.radius(context, 12),
                        ),
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
                            size: AppResponsive.iconSize(context, 16),
                          ),
                          Gap(AppResponsive.widthValue(context, 4)),
                          CustomText(
                            'تبديل',
                            color: AppColors.kPrimary,
                            fontSize: AppResponsive.fontSize(context, 9.6),
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
      },
    );
  }

  Widget _buildReciterAvatar(bool isPlaying, bool isDark) {
    final hasReciter = widget.currentReciter != null;
    final reciterIndex = hasReciter
        ? widget.reciters.indexWhere((r) => r.id == widget.currentReciter!.id) +
              1
        : 0;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: AppResponsive.widthValue(context, 46),
          height: AppResponsive.widthValue(context, 46),
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
                  : [Colors.grey.shade200, Colors.grey.shade100],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: hasReciter
                  ? AppColors.kPrimary.withValues(alpha: 0.4)
                  : isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.grey.shade300,
              width: AppResponsive.widthValue(context, 1.5),
            ),
          ),
          child: Center(
            child: hasReciter
                ? CustomText(
                    '$reciterIndex',
                    fontSize: AppResponsive.fontSize(context, 14),
                    fontWeight: FontWeight.w700,
                    color: AppColors.kPrimary,
                  )
                : Icon(
                    Icons.person_search_rounded,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.3)
                        : Colors.grey.shade500,
                    size: AppResponsive.iconSize(context, 20),
                  ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: AppResponsive.widthValue(context, 12),
            height: AppResponsive.heightValue(context, 12),

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPlaying ? Colors.green : Colors.grey.shade400,
              border: Border.all(
                color: isDark ? const Color(0xFF1A2332) : Colors.white,
                width: AppResponsive.widthValue(context, 2),
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
