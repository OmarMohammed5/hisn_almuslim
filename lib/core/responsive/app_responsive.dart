import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppResponsive {
  AppResponsive._();

  // ============================================================
  // BREAKPOINTS
  // ============================================================

  static const double tabletBreakpoint = 600.0;
  static const double desktopBreakpoint = 1024.0;

  // ============================================================
  // SCREEN SIZE
  // ============================================================

  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  // ============================================================
  // DEVICE / WINDOW TYPE
  // ============================================================

  static bool isMobile(BuildContext context) {
    return width(context) < tabletBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final screenWidth = width(context);

    return screenWidth >= tabletBreakpoint && screenWidth < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return width(context) >= desktopBreakpoint;
  }

  // ============================================================
  // RESPONSIVE WIDTH
  // ============================================================

  static double widthValue(BuildContext context, double value) {
    final scaledValue = value.w;

    // IMPORTANT:
    // Mobile keeps the current ScreenUtil behavior.
    if (isMobile(context)) {
      return scaledValue;
    }

    // Tablet / Desktop:
    // Prevent the mobile design from becoming huge.
    return math.min(scaledValue, value * 1.15);
  }

  // ============================================================
  // RESPONSIVE HEIGHT
  // ============================================================

  static double heightValue(BuildContext context, double value) {
    final scaledValue = value.h;

    if (isMobile(context)) {
      return scaledValue;
    }

    return math.min(scaledValue, value * 1.15);
  }

  // ============================================================
  // RESPONSIVE FONT
  // ============================================================

  static double fontSize(BuildContext context, double value) {
    final scaledValue = value.sp;

    if (isMobile(context)) {
      return scaledValue;
    }

    return math.min(scaledValue, value * 1.15);
  }

  // ============================================================
  // RESPONSIVE RADIUS
  // ============================================================

  static double radius(BuildContext context, double value) {
    final scaledValue = value.r;

    if (isMobile(context)) {
      return scaledValue;
    }

    return math.min(scaledValue, value * 1.15);
  }

  // ============================================================
  // PAGE HORIZONTAL PADDING
  // ============================================================

  static double horizontalPadding(BuildContext context) {
    if (isMobile(context)) {
      return 26.w;
    }

    if (isTablet(context)) {
      return 32.0;
    }

    return 48.0;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    return EdgeInsets.symmetric(horizontal: horizontalPadding(context));
  }

  // ============================================================
  // MAX CONTENT WIDTH
  // ============================================================

  static double maxContentWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity;
    }

    if (isTablet(context)) {
      return 600.0;
    }

    return 900.0;
  }

  // ============================================================
  // CONSTRAIN CONTENT
  // ============================================================

  static Widget constrain(
    BuildContext context, {
    required Widget child,
    double? maxWidth,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? maxContentWidth(context),
        ),
        child: child,
      ),
    );
  }

  /// Icon Size
  static double iconSize(BuildContext context, double value) {
    final scaledValue = value.r;
    if (isMobile(context)) return scaledValue;
    return math.min(scaledValue, value * 1.15);
  }

  // NAVIGATION BAR SIZES
  static double navHeight(BuildContext context) {
    if (isMobile(context)) {
      return 60.0;
    }
    if (isTablet(context)) {
      return 70.0;
    }
    return 76.0;
  }

  static double navHorizontalMargin(BuildContext context) {
    if (isMobile(context)) {
      return 16.0;
    }
    if (isTablet(context)) {
      return 32.0;
    }
    return 48.0;
  }

  static double navIconSize(BuildContext context) {
    if (isMobile(context)) {
      return 20.0;
    }
    if (isTablet(context)) {
      return 24.0;
    }
    return 28.0;
  }

  static double navFontSize(BuildContext context) {
    if (isMobile(context)) {
      return 10.0;
    }
    if (isTablet(context)) {
      return 11.0;
    }
    return 12.0;
  }

  static double navRadius(BuildContext context) {
    if (isMobile(context)) {
      return 24.0;
    }
    if (isTablet(context)) {
      return 28.0;
    }
    return 32.0;
  }

  static double navContainerSize(BuildContext context) {
    final size = navIconSize(context);
    if (isMobile(context)) {
      return size * 1.7;
    }
    if (isTablet(context)) {
      return size * 1.75;
    }
    return size * 1.8;
  }
}
