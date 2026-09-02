import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/features/adhan/data/cubit/adhan_cubit.dart';
import 'package:hisn_almuslim/features/adhan/data/models/prayer_time_model.dart';
import 'package:hisn_almuslim/features/home/widgets/time_line_item.dart';
import 'package:intl/intl.dart';

class PrayerHomeCard extends StatelessWidget {
  const PrayerHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AdhanCubit, AdhanState>(
      builder: (context, state) {
        if (state is AdhanLoading || state is AdhanInitial) {
          return _LoadingCard(isDark: isDark);
        }

        if (state is! AdhanLoaded) return const SizedBox.shrink();

        final others = state.prayerTimes
            .where((p) => p.name != state.nextPrayer.name)
            .toList();

        return _PrayerHomeCardContent(
          isDark: isDark,
          nextPrayer: state.nextPrayer,
          others: others,
          remaining: state.remainingTime,
        );
      },
    );
  }
}

class _PrayerHomeCardContent extends StatelessWidget {
  const _PrayerHomeCardContent({
    required this.isDark,
    required this.nextPrayer,
    required this.others,
    required this.remaining,
  });

  final bool isDark;
  final PrayerTimeModel nextPrayer;
  final List<PrayerTimeModel> others;
  final Duration remaining;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        children: [
          // Main Prayer Card
          _buildMainCard(),
          Gap(14.h),
          // Other Prayers Timeline
          _buildTimeline(),
        ],
      ),
    );
  }

  Widget _buildMainCard() {
    final bgColor = isDark ? const Color(0xFF0D2A26) : const Color(0xFFF8FBF9);
    final accentColor = isDark
        ? const Color(0xFF4DD0B5)
        : const Color(0xFF0E8A78);
    final textColor = isDark ? Colors.white : const Color(0xFF0D2A26);
    final subTextColor = isDark ? Colors.white60 : Colors.grey.shade600;
    final cardBorderColor = isDark
        ? const Color(0xFF1A4A42)
        : const Color(0xFFB2DFDB);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.12),
            blurRadius: 40,
            offset: Offset(0, 10.h),
          ),
        ],
        border: Border.all(
          color: cardBorderColor.withValues(alpha: isDark ? 0.3 : 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'الصلاة القادمة',
                    fontSize: 10.sp,
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                  Gap(4.h),
                  CustomText(
                    _getArabicPrayerName(nextPrayer.name),
                    fontSize: 24.sp,
                    color: textColor,
                    fontWeight: FontWeight.w800,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      color: accentColor,
                      size: 16.sp,
                    ),
                    Gap(4.w),
                    CustomText(
                      DateFormat('hh:mm a')
                          .format(nextPrayer.time)
                          .replaceAll('AM', 'ص')
                          .replaceAll('PM', 'م'),
                      fontSize: 14.sp,
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(20.h),
          // Progress bar
          Container(
            height: 4.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A4A42) : const Color(0xFFE0F0EC),
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: _buildProgressBar(),
          ),
          Gap(16.h),
          // Countdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                'الوقت المتبقي',
                fontSize: 11.sp,
                color: subTextColor,
                fontWeight: FontWeight.w600,
              ),
              Row(
                children: [
                  _CountdownChip(
                    value: remaining.inHours % 24,
                    label: 'س',
                    accentColor: accentColor,
                  ),
                  Gap(6.w),
                  _CountdownChip(
                    value: remaining.inMinutes % 60,
                    label: 'د',
                    accentColor: accentColor,
                  ),
                  Gap(6.w),
                  _CountdownChip(
                    value: remaining.inSeconds % 60,
                    label: 'ث',
                    accentColor: accentColor,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final totalDuration = Duration(hours: 24);
    final progress =
        (totalDuration - remaining).inSeconds / totalDuration.inSeconds;

    return FractionallySizedBox(
      widthFactor: progress.clamp(0.0, 1.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF0E8A78), const Color(0xFF4DD0B5)],
          ),
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    final allPrayers = List.from(others);
    allPrayers.add(nextPrayer);
    allPrayers.sort((a, b) => a.time.compareTo(b.time));
    final now = DateTime.now();
    int currentIndex = 0;
    for (int i = 0; i < allPrayers.length; i++) {
      if (allPrayers[i].time.isAfter(now)) {
        currentIndex = i;
        break;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0D2A26).withValues(alpha: 0.7)
            : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark
              ? const Color(0xFF1A4A42).withValues(alpha: 0.3)
              : const Color(0xFFB2DFDB).withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(allPrayers.length, (index) {
            final prayer = allPrayers[index];
            final isPast = prayer.time.isBefore(DateTime.now());
            final isCurrent = index == currentIndex;

            return TimelineItem(
              prayer: prayer,
              isPast: isPast,
              isCurrent: isCurrent,
              isLast: index == allPrayers.length - 1,
              accentColor: const Color(0xFF0E8A78),
              isDark: isDark,
            );
          }),
        ),
      ),
    );
  }

  String _getArabicPrayerName(String name) {
    final names = {
      'Fajr': 'الفجر',
      'Sunrise': 'الشروق',
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
    };
    return names[name] ?? name;
  }
}

class _CountdownChip extends StatelessWidget {
  const _CountdownChip({
    required this.value,
    required this.label,
    required this.accentColor,
  });

  final int value;
  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            value.toString().padLeft(2, '0'),
            fontSize: 16.sp,
            color: accentColor,
            fontWeight: FontWeight.w800,
          ),
          CustomText(
            label,
            fontSize: 12.sp,
            color: accentColor.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D2A26) : const Color(0xFFF8FBF9),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark
              ? const Color(0xFF1A4A42).withValues(alpha: 0.3)
              : const Color(0xFFB2DFDB).withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50.w,
              height: 50.w,
              child: CupertinoActivityIndicator(color: const Color(0xFF0E8A78)),
            ),
            Gap(12.h),
            CustomText(
              'جاري تحميل أوقات الصلاة...',
              fontSize: 14.sp,
              color: isDark ? Colors.white60 : const Color(0xFF0E8A78),
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
