import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/features/quran/screen/quran_home_page.dart';
import 'package:hisn_almuslim/features/quran_audio/ui/screens/quran_audio_home_screen.dart';

class QuranModeel {
  final String title;
  final IconData icon;
  final String route;

  QuranModeel({required this.title, required this.icon, required this.route});
}

final List<QuranModeel> sections = [
  QuranModeel(
    title: "المصحف الشريف",
    icon: FlutterIslamicIcons.solidQuran2,
    route: AppRoutes.quranHome,
  ),
  QuranModeel(
    title: "تلاوات قرآنية",
    icon: Icons.headphones_outlined,
    route: AppRoutes.quranAudioHome,
  ),
  //  QuranModeel(
  //   title: "المصحف تفسير",
  //   icon: FlutterIslamicIcons.allahText,
  //   screen: QuranReadingScreen(),
  // ),
  //  QuranModeel(
  //   title: "المصحف ترجمة",
  //   icon: FlutterIslamicIcons.solidQuran2,
  //   screen: QuranReadingScreen(),
  // ),
];
