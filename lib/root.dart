import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/features/adhan/screen/adhan_screen.dart';
import 'package:hisn_almuslim/features/quran_audio/ui/screens/quran.dart';
import 'package:hisn_almuslim/features/settings/screen/settings_screen.dart';
import 'core/di/dependency_injection.dart';
import 'features/adhan/data/cubit/adhan_cubit.dart';
import 'features/home/screen/home_screen.dart';
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
          BlocProvider.value(value: sl<AdhanCubit>()),
          BlocProvider.value(value: sl<LecturesCubit>()),
        ],
        child: const HomeScreen(),
      ),

      MultiBlocProvider(
        providers: [BlocProvider(create: (_) => sl<QuranAudioCubit>())],
        child: const Quran(),
      ),

      MultiBlocProvider(
        providers: [BlocProvider(create: (_) => sl<AdhanCubit>())],
        child: const AdhanScreen(),
      ),

      MultiBlocProvider(
        providers: [BlocProvider(create: (_) => sl<AdhanCubit>())],
        child: const SettingsScreen(),
      ),
    ];
  }

  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.kSurfaceDark : Colors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // PAGES
            ValueListenableBuilder<int>(
              valueListenable: _currentIndexNotifier,
              builder: (context, currentIndex, child) {
                return IndexedStack(index: currentIndex, children: _pages);
              },
            ),
            // BOTTOM NAVIGATION
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

  // ───────────────────────── BOTTOM NAVIGATION ─────────────────────────

  Widget _buildBottomNavigation(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;
    final activeColor =
    isDark ? const Color(0xFF79D6C3) : AppColors.kPrimary;
    final inactiveColor = isDark
        ? Colors.white.withValues(alpha: .46)
        : const Color(0xFF87948F);

    final isMobile = AppResponsive.isMobile(context);
    final isTablet = AppResponsive.isTablet(context);

    // MINIMUM bar height — bar can grow if content needs it.
    final minBarHeight = isMobile ? 58.0 : (isTablet ? 64.0 : 68.0);
    final horizontalMargin = isMobile ? 14.0 : (isTablet ? 28.0 : 40.0);
    final maxWidth = isMobile ? double.infinity : (isTablet ? 640.0 : 760.0);

    return SafeArea(
      top: false,
      minimum: EdgeInsets.only(
        left: horizontalMargin,
        right: horizontalMargin,
        bottom: isMobile ? 7.0 : 10.0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Container(
            // ✅ minHeight instead of a tight height
            constraints: BoxConstraints(
              minHeight: AppResponsive.heightValue(context, minBarHeight),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.widthValue(context, 4),
              vertical: AppResponsive.heightValue(context, 6),
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(
                AppResponsive.radius(context, isMobile ? 20 : 22),
              ),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? .22 : .06),
                  blurRadius:
                  AppResponsive.radius(context, isMobile ? 18 : 22),
                  spreadRadius: -4,
                  offset:
                  Offset(0, AppResponsive.heightValue(context, 6)),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavigationItem(
                  index: 0,
                  icon: Icons.home_rounded,
                  label: 'الرئيسية',
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
                _buildNavigationItem(
                  index: 1,
                  icon: FlutterIslamicIcons.quran2,
                  label: 'القرآن',
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
                _buildNavigationItem(
                  index: 2,
                  icon: FlutterIslamicIcons.mosque,
                  label: 'الصلاة',
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
                _buildNavigationItem(
                  index: 3,
                  icon: Icons.settings_rounded,
                  label: 'الإعدادات',
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────────────── NAV ITEM (single animated item) ─────────────────────────

  Widget _buildNavigationItem({
    required int index,
    required IconData icon,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final isMobile = AppResponsive.isMobile(context);

    return Expanded(
      child: ValueListenableBuilder<int>(
        valueListenable: _currentIndexNotifier,
        builder: (context, currentIndex, child) {
          final isActive = currentIndex == index;

          return Semantics(
            button: true,
            selected: isActive,
            label: label,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (!isActive) _currentIndexNotifier.value = index;
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppResponsive.heightValue(context, 2),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.widthValue(context, 6),
                    vertical: AppResponsive.heightValue(context, 4),
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? activeColor.withValues(alpha: .10)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      AppResponsive.radius(context, 14),
                    ),
                    border: isActive
                        ? Border.all(
                      color: activeColor.withValues(alpha: .08),
                    )
                        : null,
                  ),
                  child: Column(
                    // ✅ critical: never force the column to fill the bar height
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutBack,
                        scale: isActive ? 1.08 : 1.0,
                        child: Icon(
                          icon,
                          size: AppResponsive.fontSize(
                              context, isMobile ? 18 : 20),
                          color: isActive ? activeColor : inactiveColor,
                        ),
                      ),
                      SizedBox(
                        height: AppResponsive.heightValue(context, 3),
                      ),
                      // ✅ FittedBox guarantees no overflow no matter what
                      SizedBox(
                        height: AppResponsive.heightValue(context, 12),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            label,
                            maxLines: 1,
                            softWrap: false,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Noon',
                              fontSize: AppResponsive.fontSize(
                                  context, isMobile ? 8 : 9),
                              fontWeight: isActive
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color:
                              isActive ? activeColor : inactiveColor,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ───────────────────────── DARK MODE HELPER ─────────────────────────

  bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
