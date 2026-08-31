import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';

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
    title: "المكتبه الصوتيه",
    icon: Icons.headphones_outlined,
    route: AppRoutes.quranAudioHome,
  ),
];
