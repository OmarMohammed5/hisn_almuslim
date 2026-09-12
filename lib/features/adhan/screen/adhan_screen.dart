import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hisn_almuslim/features/adhan/data/cubit/adhan_cubit.dart';
import 'package:hisn_almuslim/features/adhan/widgets/dashboard_timing.dart';
import 'package:hisn_almuslim/features/adhan/widgets/prayer_timings.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../core/responsive/app_responsive.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AdhanCubit>().loadPrayerTimes();
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


            final maxWidth = AppResponsive.isDesktop(context)
                ? 1100.0
                : AppResponsive.isTablet(context)
                ? 820.0
                : double.infinity;

            return AppResponsive.constrain(
              context,
              maxWidth: maxWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DashboardTiming(
                    isDark: isDark,
                    nextPrayer: state.nextPrayer.name,
                    remainingTime: state.remainingTime,
                  ),
                  Gap( AppResponsive.heightValue(context, 6)),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom:  AppResponsive.heightValue(context, 80)),
                      child: Column(
                        spacing:  AppResponsive.heightValue(context, 8),
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
              ),
            );
          }

          else if (state is AdhanError) {
            return _LocationErrorView(state: state);
          }

          else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}



class _LocationErrorView extends StatelessWidget {
  final AdhanError state;
  const _LocationErrorView({required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context,24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off, size: AppResponsive.iconSize(context, 55), color: Colors.grey),
            Gap( AppResponsive.heightValue(context, 30)),
            ElevatedButton(
              onPressed: () => _handleAction(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.widthValue(context, 24),
                  vertical: AppResponsive.heightValue(context, 12),
                ),
              ),
              child: CustomText(
                _buttonLabel ,
                fontSize: AppResponsive.fontSize(context, 12),
                color: Colors.white,),
            ),
          ],
        ),
      ),
    );
  }

  String get _buttonLabel {
    switch (state.type) {
      case AdhanErrorType.serviceDisabled:
        return 'تفعيل خدمة الموقع';
      case AdhanErrorType.permissionDeniedForever:
        return 'فتح إعدادات التطبيق';
      case AdhanErrorType.permissionDenied:
      case AdhanErrorType.unknown:
        return 'إعادة المحاولة';
    }
  }

  Future<void> _handleAction(BuildContext context) async {
    switch (state.type) {
      case AdhanErrorType.serviceDisabled:
        await Geolocator.openLocationSettings();
        break;
      case AdhanErrorType.permissionDeniedForever:
        await Geolocator.openAppSettings();
        break;
      case AdhanErrorType.permissionDenied:
      case AdhanErrorType.unknown:
        break;
    }
    if (context.mounted) {
      context.read<AdhanCubit>().loadPrayerTimes();
    }
  }
}

