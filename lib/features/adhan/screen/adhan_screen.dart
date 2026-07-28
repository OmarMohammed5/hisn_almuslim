import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/adhan/data/cubit/adhan_cubit.dart';
import 'package:hisn_almuslim/features/adhan/widgets/dashboard_timing.dart';
import 'package:hisn_almuslim/features/adhan/widgets/prayer_timings.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../core/shared/app_bar_widget.dart';

class AdhanScreen extends StatefulWidget {
  const AdhanScreen({super.key});

  @override
  State<AdhanScreen> createState() => _AdhanScreenState();
}

class _AdhanScreenState extends State<AdhanScreen> {
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWidget(title: "الأذان"),
      body: BlocBuilder<AdhanCubit, AdhanState>(
        builder: (context, state) {
          if (state is AdhanLoading) {
            return Center(
              child: CupertinoActivityIndicator(color: Colors.teal.shade700),
            );
          }

          if (state is AdhanLoaded) {
            final now = DateTime.now();

            int currentIndex = -1;
            int nextIndex = -1;
            const int nowWindowMinutes = 8;

            final times = state.prayerTimes.map((e) => e.time).toList();

            for (int i = 0; i < times.length; i++) {
              final prayerTime = times[i];

              // The prayer is enterned
              final diff = now.difference(prayerTime);

              final isNowWindow =
                  diff.inSeconds >= 0 && diff.inMinutes < nowWindowMinutes;

              if (isNowWindow) {
                currentIndex = i;

                // The next Prayer is After
                nextIndex = i < times.length - 1 ? i + 1 : 0;
                break;
              }

              // if the prayer is not enterned
              if (now.isBefore(prayerTime) && nextIndex == -1) {
                nextIndex = i;
              }
            }

            if (currentIndex == -1 && nextIndex == -1) {
              nextIndex = 0;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DashboardTiming(
                  isDark: isDark,
                  nextPrayer: state.nextPrayer.name,
                  remainingTime: state.remainingTime,
                ),
                Gap(6.h),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 80.h),
                    child: Column(
                      spacing: 8.h,
                      children: List.generate(
                        state.prayerTimes.length,
                        (index) => PrayerTimings(
                          isDark: isDark,
                          prayer: state.prayerTimes[index].name,
                          time: state.prayerTimes[index].time,
                          isCurrentPrayer: index == currentIndex,
                          isNextPrayer:
                              currentIndex == -1 && index == nextIndex,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is AdhanError) {
            return Center(child: CustomText(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
