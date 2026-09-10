import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/responsive/app_responsive.dart';
import '../../../core/theme/radio_colors.dart';
import '../../radio/presentation/cubit/radio_cubit.dart';

class RadioPlayButton extends StatelessWidget {
  final bool isPlaying;
  final bool isPaused;
  final bool isLoading;

  const RadioPlayButton({super.key, required this.isPlaying, required this.isPaused, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final radioPrimary = isDark
        ? RadioColors.darkPrimary
        : RadioColors.lightPrimary;



    final radioSoft = isDark
        ? RadioColors.darkTealSoft
        : RadioColors.lightTealSoft;


    return Material(
      color: radioSoft,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      elevation: isPlaying ? 4 : 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: isLoading
            ? null
            : () {
          final cubit = context.read<RadioCubit>();

          if (isPlaying) {
            cubit.pauseRadio();
          } else if (isPaused) {
            cubit.resumeRadio();
          } else {
            cubit.playRadio();
          }
        },
        child: SizedBox(
          width: AppResponsive.widthValue(context, 50),
          height: AppResponsive.widthValue(context, 50),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isLoading
                  ? SizedBox(
                key: const ValueKey('loading'),
                width: AppResponsive.widthValue(context, 21),
                height: AppResponsive.widthValue(context, 21),
                child: CupertinoActivityIndicator(
                  color: colorScheme.onPrimary,
                ),
              )
                  : Icon(
                isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                key: ValueKey(isPlaying),
                color: radioPrimary,
                size: AppResponsive.fontSize(context, 28),
              ),
            ),
          ),
        ),
      ),
    );

  }
}
