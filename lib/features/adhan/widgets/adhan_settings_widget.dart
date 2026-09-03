import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../settings/widgets/custom_switch_widget.dart';
import '../data/cubit/adhan_settings_cubit.dart';
import '../data/models/adhan_reciter.dart';
import '../data/models/adhan_settings.dart';

class AdhanSettingsWidget extends StatefulWidget {
  const AdhanSettingsWidget({super.key});

  @override
  State<AdhanSettingsWidget> createState() => _AdhanSettingsWidgetState();
}

class _AdhanSettingsWidgetState extends State<AdhanSettingsWidget> {
  final AudioPlayer _player = AudioPlayer();
  String? _playingId;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playingId = null);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _preview(AdhanReciter reciter) async {
    try {
      if (_playingId == reciter.id) {
        await _player.stop();
        if (mounted) setState(() => _playingId = null);
        return;
      }

      await _player.stop();
      await _player.play(AssetSource(reciter.assetPath));
      if (mounted) setState(() => _playingId = reciter.id);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: CustomText('تعذر تشغيل صوت الأذان')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AdhanSettingsCubit, AdhanSettingsState>(
      builder: (context, state) {
        final settings = state.settings;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildEnabledCard(settings, isDark),
            Gap(16.h),
            _buildReciterCard(settings, isDark),
            Gap(16.h),
            _buildPrayersCard(settings, isDark),

            if (state.message != null) ...[
              Gap(12.h),
              Container(
                width: 160.w,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.teal.shade900.withOpacity(0.2)
                      : Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isDark
                        ? Colors.teal.shade800.withOpacity(0.3)
                        : Colors.teal.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  spacing: 3.w,
                  children: [
                    CustomText(
                      state.message!,
                      textAlign: TextAlign.center,
                        fontSize: 12.sp,
                        color: isDark ? Colors.teal.shade200 : Colors.teal.shade700,
                        fontWeight: FontWeight.w600,
                    ),
                    Icon(
                      Icons.check_circle_outline ,
                      color: isDark ? Colors.teal.shade200 : Colors.teal.shade700,
                    ),
                  ],
                ),
              ),
            ],
            Gap(20.h),
          ],
        );
      },
    );
  }

  Widget _buildEnabledCard(AdhanSettings settings, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey.shade900.withOpacity(0.3)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? Colors.grey.shade800.withOpacity(0.3)
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Icon + Title + Subtitle
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.teal.shade900.withOpacity(0.3)
                        : Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    FlutterIslamicIcons.mosque,
                    color: isDark ? Colors.teal.shade200 : Colors.teal.shade700,
                    size: 20.sp,
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'الأذان',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                      ),
                      Gap(2.h),
                      CustomText(
                        'تشغيل الأذان في أوقات الصلوات المحددة',
                          fontSize: 11.sp,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Right side: Custom Switch
          _buildCustomSwitch(
            isActive: settings.enabled,
            activeColor: Colors.teal.shade700,
            isDark: isDark,
            onChanged: () =>
                _update(context, settings.copyWith(enabled: !settings.enabled)),
          ),
        ],
      ),
    );
  }

  Widget _buildReciterCard(AdhanSettings settings, bool isDark) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey.shade900.withOpacity(0.3)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? Colors.grey.shade800.withOpacity(0.3)
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.teal.shade900.withOpacity(0.3)
                      : Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.mic_rounded,
                  color: isDark ? Colors.teal.shade200 : Colors.teal.shade700,
                  size: 20.sp,
                ),
              ),
              Gap(12.w),
              CustomText(
                'اختيار المؤذن',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
              ),
            ],
          ),
          Gap(12.h),
          ...AdhanReciter.all.map(
            (reciter) => _ReciterTile(
              reciter: reciter,
              selected: settings.reciter == reciter.id,
              playing: _playingId == reciter.id,
              isDark: isDark,
              onSelect: () =>
                  _update(context, settings.copyWith(reciter: reciter.id)),
              onPreview: () => _preview(reciter),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayersCard(AdhanSettings settings, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey.shade900.withOpacity(0.3)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? Colors.grey.shade800.withOpacity(0.3)
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.teal.shade900.withOpacity(0.3)
                        : Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.access_time_rounded,
                    color: isDark ? Colors.teal.shade200 : Colors.teal.shade700,
                    size: 20.sp,
                  ),
                ),
                Gap(12.w),
                CustomText(
                  'تفعيل الصلوات',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                ),
              ],
            ),
          ),
          _PrayerSwitchItem(
            title: 'الفجر',
            value: settings.fajr,
            onChanged: () =>
                _update(context, settings.copyWith(fajr: !settings.fajr)),
            isDark: isDark,
          ),
          _PrayerSwitchItem(
            title: 'الظهر',
            value: settings.dhuhr,
            onChanged: () =>
                _update(context, settings.copyWith(dhuhr: !settings.dhuhr)),
            isDark: isDark,
          ),
          _PrayerSwitchItem(
            title: 'العصر',
            value: settings.asr,
            onChanged: () =>
                _update(context, settings.copyWith(asr: !settings.asr)),
            isDark: isDark,
          ),
          _PrayerSwitchItem(
            title: 'المغرب',
            value: settings.maghrib,
            onChanged: () =>
                _update(context, settings.copyWith(maghrib: !settings.maghrib)),
            isDark: isDark,
          ),
          _PrayerSwitchItem(
            title: 'العشاء',
            value: settings.isha,
            onChanged: () =>
                _update(context, settings.copyWith(isha: !settings.isha)),
            isDark: isDark,
          ),
          Container(
            height: 1,
            color: isDark
                ? Colors.grey.shade800.withOpacity(0.3)
                : Colors.grey.shade200,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
          ),
          _PrayerSwitchItem(
            title: 'تنبيه الشروق',
            value: settings.sunrise,
            onChanged: () =>
                _update(context, settings.copyWith(sunrise: !settings.sunrise)),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSwitch({
    required bool isActive,
    required Color activeColor,
    required bool isDark,
    required VoidCallback onChanged,
  }) {
    return GestureDetector(
      onTap: onChanged,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 48.w,
        height: 28.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          color: isActive
              ? activeColor
              : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: activeColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Track
            Container(
              width: 48.w,
              height: 28.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                gradient: isActive
                    ? LinearGradient(
                        colors: [activeColor, activeColor.withOpacity(0.7)],
                      )
                    : null,
              ),
            ),
            // Thumb
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: isActive
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isActive ? Icons.check_rounded : Icons.close_rounded,
                    size: 14.sp,
                    color: isActive ? activeColor : Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _update(BuildContext context, AdhanSettings settings) {
    return context.read<AdhanSettingsCubit>().update(settings);
  }
}

class _ReciterTile extends StatelessWidget {
  final AdhanReciter reciter;
  final bool selected;
  final bool playing;
  final bool isDark;
  final VoidCallback onSelect;
  final VoidCallback onPreview;

  const _ReciterTile({
    required this.reciter,
    required this.selected,
    required this.playing,
    required this.isDark,
    required this.onSelect,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20.sp,
              color: selected ? Colors.teal.shade700 : Colors.grey.shade400,
            ),
            Gap(10.w),
            Expanded(
              child: CustomText(
                reciter.name,
                  fontSize: 13.sp,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                  color: selected
                      ? (isDark ? Colors.teal.shade200 : Colors.teal.shade700)
                      : (isDark ? Colors.grey.shade300 : Colors.black87),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: playing
                    ? (isDark
                          ? Colors.teal.shade900.withOpacity(0.3)
                          : Colors.teal.shade50)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: playing
                      ? (isDark
                            ? Colors.teal.shade700.withOpacity(0.3)
                            : Colors.teal.shade200)
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 24.w, minHeight: 24.h),
                tooltip: playing ? 'إيقاف' : 'استماع',
                onPressed: onPreview,
                icon: Icon(
                  playing ? Icons.stop_rounded : Icons.play_arrow_rounded,
                  size: 24.sp,
                  color: playing
                      ? (isDark ? Colors.teal.shade200 : Colors.teal.shade700)
                      : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrayerSwitchItem extends StatelessWidget {
  final String title;
  final bool value;
  final VoidCallback onChanged;
  final bool isDark;

  const _PrayerSwitchItem({
    required this.title,
    required this.value,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            title,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade200 : Colors.black87,
          ),
          CustomSwitchWidget(
            isActive: value,
            activeColor: Colors.teal.shade700,
            isDark: isDark,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
