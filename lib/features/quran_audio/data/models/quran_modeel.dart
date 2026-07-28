import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:hisn_almuslim/features/quran/screen/quran_reading_screen.dart';
import 'package:hisn_almuslim/features/quran_audio/ui/screens/quran_audio_home_screen.dart';

class QuranModeel {
  final String title;
  final IconData icon;
  final Widget screen;

  QuranModeel({required this.title, required this.icon, required this.screen});
}

final List<QuranModeel> sections = [
  QuranModeel(
    title: "المصحف الشريف",
    icon: FlutterIslamicIcons.solidQuran2,
    screen: QuranReadingScreen(),
  ),
  QuranModeel(
    title: "تلاوات قرآنية",
    icon: Icons.headphones_outlined,
    screen: QuranAudioHomeScreen(),
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
