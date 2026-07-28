
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/splash.dart';
import 'package:hisn_almuslim/core/theme/app_themes.dart';

import 'features/settings/data/cubit/theme_cubit.dart';

class HisnAlMuslimApp extends StatelessWidget {
  final bool seenWelcomeScreen;
  const HisnAlMuslimApp({super.key, required this.seenWelcomeScreen});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (BuildContext context, child) {
            return MaterialApp(
              // navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: AppThemes.light,
              darkTheme: AppThemes.dark,

              builder: (context, child) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: child!,
                );
              },
              home: Splash(seenWelcomeScreen: seenWelcomeScreen),
              // home: WelcomeScreen(),
            );
          },
        );
      },
    );
  }
}
