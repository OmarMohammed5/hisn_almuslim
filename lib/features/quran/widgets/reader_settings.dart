import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

enum QuranReadingMode { continuous, focus, page, qari, tajweed }

class QuranReaderSettings {
  final QuranReadingMode mode;
  final double fontSize;
  final bool darkMode;

  const QuranReaderSettings({
    this.mode = QuranReadingMode.continuous,
    this.fontSize = 16,
    this.darkMode = false,
  });

  QuranReaderSettings copyWith({
    QuranReadingMode? mode,
    double? fontSize,
    bool? darkMode,
  }) {
    return QuranReaderSettings(
      mode: mode ?? this.mode,
      fontSize: fontSize ?? this.fontSize,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is QuranReaderSettings &&
        other.mode == mode &&
        other.fontSize == fontSize &&
        other.darkMode == darkMode;
  }

  @override
  int get hashCode {
    return Object.hash(mode, fontSize, darkMode);
  }
}

/// ===============================================================
/// MODE INFO
/// ===============================================================

class QuranReadingModeInfo {
  final QuranReadingMode mode;
  final String title;
  final String subtitle;
  final IconData icon;

  const QuranReadingModeInfo({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

const List<QuranReadingModeInfo> quranReadingModes = [
  QuranReadingModeInfo(
    mode: QuranReadingMode.continuous,
    title: 'القراءة المتصلة',
    subtitle: 'تدفّق مريح للقراءة الطويلة',
    icon: Icons.menu_book_rounded,
  ),
  QuranReadingModeInfo(
    mode: QuranReadingMode.focus,
    title: 'التركيز على الآية',
    subtitle: 'كل آية في مساحتها الخاصة',
    icon: Icons.center_focus_strong_rounded,
  ),
  QuranReadingModeInfo(
    mode: QuranReadingMode.page,
    title: 'صفحة المصحف',
    subtitle: 'تجربة أقرب إلى المصحف الورقي',
    icon: Icons.auto_stories_rounded,
  ),

  QuranReadingModeInfo(
    mode: QuranReadingMode.qari,
    title: 'القراءة الغامرة',
    subtitle: 'القراءة المتتاليه للأيات',
    icon: Icons.filter_list,
  ),
];



