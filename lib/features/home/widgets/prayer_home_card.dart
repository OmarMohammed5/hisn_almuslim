import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/responsive/app_responsive.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/features/adhan/data/cubit/adhan_cubit.dart';
import 'package:hisn_almuslim/features/adhan/data/models/prayer_time_model.dart';
import 'package:hisn_almuslim/features/home/widgets/time_line_item.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';

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
      padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 18)),
      child: Column(
        children: [
          // Main Prayer Card
          _buildMainCard(context),
          Gap(AppResponsive.heightValue(context, 14)),
          // Other Prayers Timeline
          _buildTimeline(context),
        ],
      ),
    );
  }

  Widget _buildMainCard(BuildContext context) {

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    final accentColor = isDark
        ? const Color(0xFF4DD0B5)
        : const Color(0xFF0E8A78);
    final textColor = isDark ? Colors.white : const Color(0xFF0D2A26);
    final subTextColor = isDark ? Colors.white60 : Colors.grey.shade600;
    final cardBorderColor = isDark
        ? const Color(0xFF1A4A42)
        : const Color(0xFFB2DFDB);

    return Container(
      padding: EdgeInsets.all(AppResponsive.widthValue(context, 20)),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 24)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.02),
            blurRadius: 2,
            offset: Offset(0, AppResponsive.heightValue(context, 2)),
          ),
        ],
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
                    fontSize: AppResponsive.fontSize(context, 10),
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                  Gap(AppResponsive.heightValue(context, 4)),
                  CustomText(
                    _getArabicPrayerName(nextPrayer.name),
                    fontSize: AppResponsive.fontSize(context, 24),
                    color: textColor,
                    fontWeight: FontWeight.w800,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 14), vertical: AppResponsive.heightValue(context, 8)),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
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
                      size: AppResponsive.fontSize(context, 16),
                    ),
                    Gap(AppResponsive.widthValue(context, 4)),
                    CustomText(
                      DateFormat('hh:mm a')
                          .format(nextPrayer.time)
                          .replaceAll('AM', 'ص')
                          .replaceAll('PM', 'م'),
                      fontSize: AppResponsive.fontSize(context, 14),
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(AppResponsive.heightValue(context, 20)),
          // Progress bar
          Container(
            height: AppResponsive.heightValue(context, 4),
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A4A42) : const Color(0xFFE0F0EC),
              borderRadius: BorderRadius.circular(AppResponsive.radius(context, 2)),
            ),
            child: _buildProgressBar(context),
          ),
          Gap(AppResponsive.heightValue(context, 16)),
          // Countdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                'الوقت المتبقي',
                fontSize: AppResponsive.fontSize(context, 11),
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
                  Gap(AppResponsive.widthValue(context, 6)),
                  _CountdownChip(
                    value: remaining.inMinutes % 60,
                    label: 'د',
                    accentColor: accentColor,
                  ),
                  Gap(AppResponsive.widthValue(context, 6)),
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

  Widget _buildProgressBar(BuildContext context) {
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
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 2)),
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
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

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;


    return Container(
      padding: EdgeInsets.symmetric(vertical: AppResponsive.heightValue(context, 12), horizontal: AppResponsive.widthValue(context, 16)),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
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
      width: AppResponsive.widthValue(context, 48),
      padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 8), vertical: AppResponsive.heightValue(context, 4)),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 8)),
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
            fontSize: AppResponsive.fontSize(context, 16),
            color: accentColor,
            fontWeight: FontWeight.w800,
          ),
          CustomText(
            label,
            fontSize: AppResponsive.fontSize(context, 12),
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
      height: AppResponsive.heightValue(context, 200),
      margin: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 18)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D2A26) : const Color(0xFFF8FBF9),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 24)),
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
              width: AppResponsive.widthValue(context, 50),
              height: AppResponsive.widthValue(context, 50),
              child: CupertinoActivityIndicator(color: const Color(0xFF0E8A78)),
            ),
            Gap(AppResponsive.heightValue(context, 12)),
            CustomText(
              'جاري تحميل أوقات الصلاة...',
              fontSize: AppResponsive.fontSize(context, 13),
              color: isDark ? Colors.white60 : const Color(0xFF0E8A78),
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
