import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/live_broadcast_indicator.dart';
import '../cubit/radio_cubit.dart';
import '../cubit/radio_state.dart';

class RadioScreen extends StatelessWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إذاعة القرآن الكريم'),
        centerTitle: true,
      ),
      body: BlocConsumer<RadioCubit, RadioState>(
        listener: (context, state) {
          if (state is RadioError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is RadioLoading;
          final bool isPlaying = state is RadioPlaying;
          final bool isPaused = state is RadioPaused;
          final theme = Theme.of(context);

          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RadarPulse(
                    active: isPlaying,
                    color: theme.colorScheme.primary,
                    ringCount: 3,
                    maxScale: 1.9,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: 180.w,
                      height: 180.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary.withValues(
                          alpha: isPlaying ? 0.16 : 0.1,
                        ),
                      ),
                      child: Icon(
                        Icons.radio_rounded,
                        size: 90.sp,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  Text(
                    'إذاعة القرآن الكريم',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    'من القاهرة',
                    style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                  ),

                  SizedBox(height: 12.h),

                  // Reserve a fixed-height slot for the live badge so the
                  // layout below doesn't jump when it appears/disappears.
                  SizedBox(
                    height: 28.h,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: isPlaying ? 1 : 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'مباشر الآن',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          SoundWaveBars(
                            active: isPlaying,
                            color: Colors.red.withValues(alpha: 0.85),
                            height: 16,
                            barWidth: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  if (isLoading)
                    SizedBox(
                      width: 60.w,
                      height: 60.w,
                      child: const CircularProgressIndicator(),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: (isPlaying || isPaused) ? 1 : 0,
                          child: IgnorePointer(
                            ignoring: !(isPlaying || isPaused),
                            child: IconButton(
                              onPressed: () {
                                context.read<RadioCubit>().stopRadio();
                              },
                              icon: const Icon(Icons.stop_rounded),
                              iconSize: 32.sp,
                            ),
                          ),
                        ),

                        SizedBox(width: 12.w),

                        Container(
                          width: 72.w,
                          height: 72.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary,
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: isPlaying ? 0.35 : 0.0,
                                ),
                                blurRadius: 20.r,
                                spreadRadius: 2.r,
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {
                              final cubit = context.read<RadioCubit>();

                              if (isPlaying) {
                                cubit.pauseRadio();
                              } else if (isPaused) {
                                cubit.resumeRadio();
                              } else {
                                cubit.playRadio();
                              }
                            },
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                key: ValueKey(isPlaying),
                                color: Colors.white,
                              ),
                            ),
                            iconSize: 38.sp,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}