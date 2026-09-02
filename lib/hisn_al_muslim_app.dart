import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/routing/app_router.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/core/theme/app_themes.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/theme_cubit.dart';

import 'core/di/dependency_injection.dart';
import 'features/settings/data/cubit/notification_cubit.dart';

class HisnAlMuslimApp extends StatelessWidget {
  final AppRouter appRouter;
  // final bool seenWelcomeScreen;

  const HisnAlMuslimApp({
    super.key,
    // required this.seenWelcomeScreen,
    required this.appRouter,flutter
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, child) {
        return MultiBlocProvider(
          providers: [
              BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),
              // NotificationCubit
              BlocProvider<NotificationCubit>(create: (_) => sl<NotificationCubit>()),
          ],
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                navigatorObservers: [routeObserver],
                debugShowCheckedModeBanner: false,
                themeMode: themeMode,
                theme: AppThemes.light,
                darkTheme: AppThemes.dark,
                initialRoute: AppRoutes.root,
                onGenerateRoute: appRouter.generateRoute,
                builder: (context, child) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: child!,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
