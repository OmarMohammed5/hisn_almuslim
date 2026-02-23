import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:hisn_almuslim/features/al%20azkar/evening%20azkar/screen/evening_azkar_screen.dart';
import 'package:hisn_almuslim/features/al%20azkar/morning%20azkar/screen/morning_azkar_screen.dart';
import 'package:hisn_almuslim/features/asma%20allah/screen/asma_allah_screen.dart';
import 'package:hisn_almuslim/features/hadith/hadith_screen.dart';
import 'package:hisn_almuslim/features/hisn%20al-muslim/screen/alazkar_screen.dart';
import 'package:hisn_almuslim/features/jami%20dua/screen/dua_screen.dart';
import 'package:hisn_almuslim/features/tasbeeh/screen/zekr_allah_screen.dart';

class CategoryModel {
  final String title;
  final IconData icon;
  final Widget screen;
  CategoryModel({
    required this.title,
    required this.icon,
    required this.screen,
  });
}

final List<CategoryModel> categories = [
  CategoryModel(
    title: "أذكار الصباح",
    icon: Icons.wb_sunny,
    screen: MorningAzkarScreen(),
  ),
  CategoryModel(
    title: "أذكار المساء",
    icon: Icons.dark_mode,
    screen: EveningAzkarScreen(),
  ),
  CategoryModel(
    title: "أسماء الله الحسنى",
    icon: FlutterIslamicIcons.allah,
    screen: AsmaAllahScreen(),
  ),
  CategoryModel(
    title: "الأذكار",
    icon: FlutterIslamicIcons.muslim,
    screen: HisnAlmuslimScreen(),
  ),
  CategoryModel(
    title: "الأحاديث",
    icon: FlutterIslamicIcons.mohammad,
    screen: HadithScreen(),
  ),
  CategoryModel(
    title: "الأدعية",
    icon: FlutterIslamicIcons.prayer,
    screen: DuaScreen(),
  ),
  CategoryModel(
    title: "السبحة",
    icon: FlutterIslamicIcons.tasbihHand,
    screen: ZekrAllahScreen(),
  ),
];
