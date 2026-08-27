import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/features/al%20azkar/evening%20azkar/screen/evening_azkar_screen.dart';
import 'package:hisn_almuslim/features/al%20azkar/morning%20azkar/screen/morning_azkar_screen.dart';
import 'package:hisn_almuslim/features/asma%20allah/screen/asma_allah_screen.dart';
import 'package:hisn_almuslim/features/hadith/hadith_screen.dart';
import 'package:hisn_almuslim/features/hisn%20al-muslim/screen/hisn_al_muslim_screen.dart';
import 'package:hisn_almuslim/features/jami%20dua/screen/dua_screen.dart';
import 'package:hisn_almuslim/features/tasbeeh/screen/zekr_allah_screen.dart';

class CategoryModel {
  final String title;
  final IconData icon;
  final String route;
  CategoryModel({
    required this.title,
    required this.icon,
    required this.route,
  });
}

final List<CategoryModel> categories = [
  CategoryModel(
    title: "أذكار الصباح",
    icon: Icons.wb_sunny,
    route: AppRoutes.morningAzkar,
  ),
  CategoryModel(
    title: "أذكار المساء",
    icon: Icons.dark_mode,
    route: AppRoutes.eveningAzkar,
  ),
  CategoryModel(
    title: "الأذكار",
    icon: FlutterIslamicIcons.muslim,
    route: AppRoutes.hisnAlMuslim,
  ),
  CategoryModel(
    title: "الأحاديث",
    icon: FlutterIslamicIcons.mohammad,
    route: AppRoutes.hadith,
  ),
  CategoryModel(
    title: "الأدعية",
    icon: FlutterIslamicIcons.prayer,
    route: AppRoutes.dua,
  ),
  CategoryModel(
    title: "أسماء الله الحسنى",
    icon: FlutterIslamicIcons.allah,
    route: AppRoutes.asmaAllah,
  ),
  CategoryModel(
    title: "قصص الأنبياء",
    icon: Icons.auto_stories_outlined,
    route: AppRoutes.stories,
  ),
  CategoryModel(
    title: "السبحة",
    icon: FlutterIslamicIcons.tasbihHand,
    route: AppRoutes.zekrAllah,
  ),
  CategoryModel(
    title: "اسئلة دينيه",
    icon: Icons.quiz_sharp,
    route: AppRoutes.quizCategories,
  ),
];
