import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hisn_almuslim/features/adhan/screen/adhan_screen.dart';
import 'package:hisn_almuslim/features/home/screen/home_screen.dart';
import 'package:hisn_almuslim/features/quran_audio/ui/screens/quran.dart';
import 'package:hisn_almuslim/features/settings/screen/settings_screen.dart';

import 'core/di/dependency_injection.dart';
import 'features/adhan/data/cubit/adhan_cubit.dart';
import 'features/lectures/presentation/cubit/lectures_cubit.dart';
import 'features/quran/data/cubit/ayah_highlight_cubit.dart';
import 'features/quran/data/cubit/quran_cubit.dart';
import 'features/quran_audio/logic/quran_audio_cubit.dart';
import 'features/radio/presentation/cubit/radio_cubit.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

  final List<Widget> _pages = [
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<RadioCubit>()),
        BlocProvider.value(value: sl<QuranCubit>()),
        BlocProvider.value(value: sl<AyahHighlightCubit>()),
        BlocProvider.value(value: sl<LecturesCubit>()),
      ],
      child: const HomeScreen(),
    ),

    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<QuranAudioCubit>()),
      ],
      child: const Quran(),
    ),

    BlocProvider(create: (_) => sl<AdhanCubit>(), child: const AdhanScreen()),

    const SettingsScreen(),
  ];

  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: _currentIndexNotifier,
              builder: (context, currentIndex, child) {
                return IndexedStack(index: currentIndex, children: _pages);
              },
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomNavigation(context),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // Floating Navigation Dock
  // ===============================================================

  Widget _buildBottomNavigation(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF111918) : Colors.white;

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.06);

    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.45)
        : Colors.black.withValues(alpha: 0.12);

    return SafeArea(
      top: false,
      minimum: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
      child: Container(
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 25.r,
              spreadRadius: -5,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildNavigationItem(
              index: 0,
              icon: Icons.home_rounded,
              label: 'الرئيسية',
              isDark: isDark,
            ),
            _buildNavigationItem(
              index: 1,
              icon: FlutterIslamicIcons.quran2,
              label: 'القرآن',
              isDark: isDark,
            ),
            _buildNavigationItem(
              index: 2,
              icon: FlutterIslamicIcons.mosque,
              label: 'الصلاة',
              isDark: isDark,
            ),
            _buildNavigationItem(
              index: 3,
              icon: Icons.settings_rounded,
              label: 'الإعدادات',
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // Navigation Item
  // ===============================================================

  Widget _buildNavigationItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return Expanded(
      child: ValueListenableBuilder<int>(
        valueListenable: _currentIndexNotifier,
        builder: (context, currentIndex, child) {
          final isActive = currentIndex == index;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (!isActive) {
                _currentIndexNotifier.value = index;
              }
            },
            child: SizedBox(
              height: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // =================================================
                  // Inactive Icon
                  // =================================================
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: isActive ? 0 : 1,
                    child: _buildInactiveIcon(icon, isDark),
                  ),

                  // =================================================
                  // Active Floating Button
                  // =================================================
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutBack,
                    top: isActive ? -17.h : 20.h,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: isActive ? 1 : 0,
                      child: _buildActiveItem(
                        icon: icon,
                        label: label,
                        isDark: isDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ===============================================================
  // Active Item
  // ===============================================================

  Widget _buildActiveItem({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    final activeColor = isDark
        ? const Color(0xFF7BE4D1)
        : const Color(0xFF087F73);

    final activeBackground = isDark
        ? const Color(0xFF173B36)
        : const Color(0xFFE1F2EF);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: activeColor,
            border: Border.all(
              color: isDark ? const Color(0xFF0E2522) : Colors.white,
              width: 4.w,
            ),
            boxShadow: [
              BoxShadow(
                color: activeColor.withValues(alpha: 0.28),
                blurRadius: 14.r,
                offset: Offset(0, 5.h),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 21.sp,
            color: isDark ? const Color(0xFF0D2824) : Colors.white,
          ),
        ),

        SizedBox(height: 3.h),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: activeBackground,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w800,
              color: activeColor,
              fontFamily: 'QuranFont',
              height: 1,
            ),
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // Inactive Item
  // ===============================================================

  Widget _buildInactiveIcon(IconData icon, bool isDark) {
    return Container(
      width: 44.w,
      height: 44.w,
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 20.sp,
        color: isDark
            ? Colors.white.withValues(alpha: 0.42)
            : Colors.black.withValues(alpha: 0.42),
      ),
    );
  }
}
