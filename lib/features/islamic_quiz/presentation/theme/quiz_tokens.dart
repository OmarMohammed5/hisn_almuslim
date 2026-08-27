import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';


class QuizColors {
  QuizColors._();

  // ---- Light theme surfaces ----
  static const Color lightBackground = Color(0xFFF7FAF8);
  static const Color lightCard = Colors.white;
  static const Color lightPrimarySoft = Color(0xFFE6F5EC);
  static const Color lightBorder = Color(0x14101B14);
  static const Color lightTextPrimary = Color(0xFF14211A);
  static const Color lightTextSecondary = Color(0x9914211A);

  // ---- Dark theme surfaces ----
  static const Color darkBackground = Color(0xFF101513);
  static const Color darkCard = Color(0xFF1C2420);
  static const Color darkPrimarySoft = Color(0x1F4FBE85);
  static const Color darkBorder = Colors.white10;
  static const Color darkTextPrimary = Color(0xFFF3F6F4);
  static const Color darkTextSecondary = Color(0x99F3F6F4);

  // ---- Semantic (same in both themes, chosen to hold contrast) ----
  static const Color success = Color(0xFF2E9E5B);
  static const Color successSoft = Color(0x1F2E9E5B);
  static const Color error = Color(0xFFD9483C);
  static const Color errorSoft = Color(0x1FD9483C);
  static const Color warning = Color(0xFFC98A2B);
  static const Color locked = Color(0xFF98A39D);
  static const Color lockedSoft = Color(0x1498A39D);

  static bool _isDark(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark;

  static Color background(BuildContext c) =>
      _isDark(c) ? darkBackground : lightBackground;

  static Color card(BuildContext c) => _isDark(c) ? darkCard : lightCard;

  static Color border(BuildContext c) => _isDark(c) ? darkBorder : lightBorder;

  static Color textPrimary(BuildContext c) =>
      _isDark(c) ? darkTextPrimary : lightTextPrimary;

  static Color textSecondary(BuildContext c) =>
      _isDark(c) ? darkTextSecondary : lightTextSecondary;

  /// Reuses the app's existing primary color when available.
  static Color primary(BuildContext c) => AppColors.kPrimary;

  static Color primarySoft(BuildContext c) =>
      _isDark(c) ? darkPrimarySoft : lightPrimarySoft;

  static Color shadow(BuildContext c) =>
      Colors.black.withValues(alpha: _isDark(c) ? .22 : .05);
}

class QuizRadius {
  QuizRadius._();
  static const double sm = 14;
  static const double md = 20;
  static const double lg = 26;
  static const double xl = 32;
  static const double pill = 999;
}

class QuizSpacing {
  QuizSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
}

class QuizDurations {
  QuizDurations._();
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration normal = Duration(milliseconds: 280);
  static const Duration slow = Duration(milliseconds: 420);

  static const Duration entranceStep = Duration(milliseconds: 55);
}

class QuizText {
  QuizText._();

  static TextStyle screenTitle(BuildContext c) => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: QuizColors.textPrimary(c),
        height: 1.3,
      );

  static TextStyle sectionSubtitle(BuildContext c) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: QuizColors.textSecondary(c),
        height: 1.5,
      );

  static TextStyle cardTitle(BuildContext c) => TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: QuizColors.textPrimary(c),
      );

  static TextStyle cardMeta(BuildContext c) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: QuizColors.textSecondary(c),
      );

  static TextStyle question(BuildContext c) => TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        height: 1.75,
        color: QuizColors.textPrimary(c),
      );

  static TextStyle answer(BuildContext c, {bool emphasized = false}) =>
      TextStyle(
        fontSize: 16,
        height: 1.6,
        fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
        color: QuizColors.textPrimary(c),
      );
}
