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
  final ValueNotifier<int> _currentIndexNotifier =
  ValueNotifier<int>(0);

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
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
          BlocProvider(
            create: (_) => sl<QuranAudioCubit>(),
          ),
        ],
        child: const Quran(),
      ),

      BlocProvider(
        create: (_) => sl<AdhanCubit>(),
        child: const AdhanScreen(),
      ),

      const SettingsScreen(),
    ];
  }

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
            // =====================================================
            // PAGES
            // =====================================================

            ValueListenableBuilder<int>(
              valueListenable: _currentIndexNotifier,
              builder: (
                  context,
                  currentIndex,
                  child,
                  ) {
                return IndexedStack(
                  index: currentIndex,
                  children: _pages,
                );
              },
            ),

            // =====================================================
            // BOTTOM NAVIGATION
            // =====================================================

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

  // BOTTOM NAVIGATION

  Widget _buildBottomNavigation(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF101815)
        : const Color(0xFFF7F4EC);

    final navigationColor = isDark
        ? const Color(0xFF17211E)
        : Colors.white;

    final inactiveColor = isDark
        ? const Color(0xFF83908A)
        : const Color(0xFFA7ADB4);

    final activeColor = isDark
        ? const Color(0xFF78D7C4)
        : const Color(0xFF087F73);

    final activeLabelBackground = isDark
        ? const Color(0xFF203B35)
        : const Color(0xFFE6F3F0);

    return SafeArea(
      top: false,
      minimum: EdgeInsets.only(
        left: 14.w,
        right: 14.w,
        bottom: 9.h,
      ),
      child: SizedBox(
        height: 78.h,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // MAIN CAPSULE
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 55.h,
                decoration: BoxDecoration(
                  color: navigationColor,
                  borderRadius:
                  BorderRadius.circular(40.r),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(
                      alpha: .055,
                    )
                        : Colors.black.withValues(
                      alpha: .035,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? .32 : .10,
                      ),
                      blurRadius: 28.r,
                      spreadRadius: -5,
                      offset: Offset(0, 8.h),
                    ),
                  ],
                ),
              ),
            ),

            // NAVIGATION ITEMS
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                ),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: [
                    _buildNavigationItem(
                      index: 0,
                      icon: Icons.home_rounded,
                      label: 'الرئيسية',
                      activeColor: activeColor,
                      inactiveColor: inactiveColor,
                      activeLabelBackground:
                      activeLabelBackground,
                      navigationColor: navigationColor,
                      backgroundColor: backgroundColor,
                    ),

                    _buildNavigationItem(
                      index: 1,
                      icon: FlutterIslamicIcons.quran2,
                      label: 'القرآن',
                      activeColor: activeColor,
                      inactiveColor: inactiveColor,
                      activeLabelBackground:
                      activeLabelBackground,
                      navigationColor: navigationColor,
                      backgroundColor: backgroundColor,
                    ),

                    _buildNavigationItem(
                      index: 2,
                      icon: FlutterIslamicIcons.mosque,
                      label: 'الصلاة',
                      activeColor: activeColor,
                      inactiveColor: inactiveColor,
                      activeLabelBackground:
                      activeLabelBackground,
                      navigationColor: navigationColor,
                      backgroundColor: backgroundColor,
                    ),

                    _buildNavigationItem(
                      index: 3,
                      icon: Icons.settings_rounded,
                      label: 'الإعدادات',
                      activeColor: activeColor,
                      inactiveColor: inactiveColor,
                      activeLabelBackground:
                      activeLabelBackground,
                      navigationColor: navigationColor,
                      backgroundColor: backgroundColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NAVIGATION ITEM

  Widget _buildNavigationItem({
    required int index,
    required IconData icon,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
    required Color activeLabelBackground,
    required Color navigationColor,
    required Color backgroundColor,
  }) {
    return Expanded(
      child: ValueListenableBuilder<int>(
        valueListenable: _currentIndexNotifier,
        builder: (
            context,
            currentIndex,
            child,
            ) {
          final isActive = currentIndex == index;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (!isActive) {
                _currentIndexNotifier.value = index;
              }
            },
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                // =================================================
                // INACTIVE ITEM
                // =================================================

                AnimatedOpacity(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  curve: Curves.easeOut,
                  opacity: isActive ? 0 : 1,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 8.h,
                    ),
                    child: _buildInactiveItem(
                      icon: icon,
                      label: label,
                      color: inactiveColor,
                    ),
                  ),
                ),

                // =================================================
                // ACTIVE ITEM
                // =================================================

                AnimatedOpacity(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  curve: Curves.easeOut,
                  opacity: isActive ? 1 : 0,
                  child: AnimatedSlide(
                    duration: const Duration(
                      milliseconds: 320,
                    ),
                    curve: Curves.easeOutBack,
                    offset: isActive
                        ? Offset.zero
                        : const Offset(0, .18),
                    child: _buildActiveItem(
                      icon: icon,
                      label: label,
                      activeColor: activeColor,
                      activeLabelBackground:
                      activeLabelBackground,
                      navigationColor: navigationColor,
                      backgroundColor: backgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // INACTIVE ITEM

  Widget _buildInactiveItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return SizedBox(
      height: 49.h,
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 21.sp,
            color: color,
          ),

          SizedBox(height: 4.h),

          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'QuranFont',
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w500,
              color: color,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  // ACTIVE ITEM

  Widget _buildActiveItem({
    required IconData icon,
    required String label,
    required Color activeColor,
    required Color activeLabelBackground,
    required Color navigationColor,
    required Color backgroundColor,
  }) {
    return SizedBox(
      height: 82.h,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // NOTCH / CUTOUT
          Container(
            width: 68.w,
            height: 68.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
          ),

          // ACTIVE CIRCLE
          Positioned(
            top: -2.h,
            child: Container(
              width: 58.w,
              height: 58.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: navigationColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: .06,
                    ),
                    blurRadius: 12.r,
                    offset: Offset(0, 3.h),
                  ),
                ],
              ),
              child: Container(
                margin: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activeColor,
                  boxShadow: [
                    BoxShadow(
                      color: activeColor.withValues(
                        alpha: .28,
                      ),
                      blurRadius: 14.r,
                      offset: Offset(0, 5.h),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 23.sp,
                  color: isDarkTheme(context)
                      ? const Color(0xFF10201B)
                      : Colors.white,
                ),
              ),
            ),
          ),

          // ACTIVE LABEL
          Positioned(
            bottom: 7.h,
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 220,
              ),
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(
                horizontal: 9.w,
                vertical: 4.h,
              ),
              decoration: BoxDecoration(
                color: activeLabelBackground,
                borderRadius:
                BorderRadius.circular(10.r),
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'QuranFont',
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w700,
                  color: activeColor,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DARK MODE HELPER

  bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness ==
        Brightness.dark;
  }
}