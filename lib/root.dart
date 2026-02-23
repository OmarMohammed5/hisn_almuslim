import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/adhan/screen/adhan_screen.dart';
import 'package:hisn_almuslim/features/home/screen/home_screen.dart';
import 'package:hisn_almuslim/features/quran/screen/quran_screen.dart';
import 'package:hisn_almuslim/features/settings/screen/settings_screen.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier(0);

  final List<Widget> _pages = [
    HomeScreen(),
    QuranScreen(),
    AdhanScreen(),
    SettingsScreen(),
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
            ValueListenableBuilder(
              valueListenable: _currentIndexNotifier,
              builder: (context, currentIndex, child) {
                return IndexedStack(index: currentIndex, children: _pages);
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 6.h,
              child: _buildModernNav(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernNav(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      height: 50.h,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1e2530).withOpacity(0.98)
            : Colors.white.withOpacity(0.98),
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(
          color: const Color(0xFF4a9b8e).withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Stack(
        children: [
          // Background indicator for active item
          ValueListenableBuilder<int>(
            valueListenable: _currentIndexNotifier,
            builder: (context, currentIndex, _) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                right: _getIndicatorPosition(currentIndex),
                top: 3.h,
                bottom: 3.h,
                child: Container(
                  width: 62.w,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade600,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              );
            },
          ),
          // Navigation items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _modernNavItem(
                icon: Icons.home_rounded,
                label: 'الرئيسية',
                index: 0,
                isDark: isDark,
              ),
              _modernNavItem(
                icon: FlutterIslamicIcons.quran2,
                label: 'القرآن',
                index: 1,
                isDark: isDark,
              ),
              _modernNavItem(
                icon: FlutterIslamicIcons.mosque,
                label: 'الأذان',
                index: 2,
                isDark: isDark,
              ),
              _modernNavItem(
                icon: Icons.settings_rounded,
                label: 'الإعدادات',
                index: 3,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _getIndicatorPosition(int index) {
    // Calculate position for each tab (RTL)
    switch (index) {
      case 0:
        return 8.w; // Home - far right
      case 1:
        return 88.w; // Quran
      case 2:
        return 168.w; // Adhan
      case 3:
        return 248.w; // Settings - far left
      default:
        return 8.w;
    }
  }

  Widget _modernNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isDark,
  }) {
    return Expanded(
      child: ValueListenableBuilder<int>(
        valueListenable: _currentIndexNotifier,
        builder: (context, currentIndex, _) {
          final isActive = currentIndex == index;

          return GestureDetector(
            onTap: () => _currentIndexNotifier.value = index,
            child: Container(
              height: 55.h,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Icon(
                      icon,
                      size: isActive ? 20.sp : 18.sp,
                      color: isActive
                          ? Colors.white
                          : (isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600),
                    ),
                  ),
                  Gap(6.h),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: isActive ? 9.sp : 8.5.sp,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                      color: isActive
                          ? Colors.white
                          : (isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600),
                      fontFamily: 'Cairo',
                      height: 1,
                    ),
                    child: Text(label),
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
