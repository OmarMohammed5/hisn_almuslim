import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/welcome/screen/welcome_screen.dart';
import 'package:hisn_almuslim/root.dart';
import 'package:hisn_almuslim/shared/app_logo.dart';

class Splash extends StatefulWidget {
  const Splash({super.key, required this.seenWelcomeScreen});

  final bool seenWelcomeScreen;

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _ayahFade;
  late final Animation<Offset> _ayahSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _logoScale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _logoFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _ayahFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1, curve: Curves.easeIn),
      ),
    );

    _ayahSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 1, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2600), _navigateNext);
  }

  void _navigateNext() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            widget.seenWelcomeScreen ? const Root() : const WelcomeScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final lightGradient = const LinearGradient(
      colors: [Color(0xFFF6FFFB), Color(0xFFE6F5EC), Color(0xFFD9F1E5)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final darkGradient = const LinearGradient(
      colors: [Color(0xff0f1316), Color(0xff1c2227)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? darkGradient : lightGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// LOGO
            FadeTransition(
              opacity: _logoFade,
              child: ScaleTransition(scale: _logoScale, child: const AppLogo()),
            ),

            Gap(40.h),

            /// AYAH
            FadeTransition(
              opacity: _ayahFade,
              child: SlideTransition(
                position: _ayahSlide,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: Text(
                    "﴿ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ ﴾",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: "AlqalamQuranMajeed2",
                      height: 1.8,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.green.shade900,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
