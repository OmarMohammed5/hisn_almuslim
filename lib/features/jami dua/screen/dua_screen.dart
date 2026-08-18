import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/features/jami%20dua/screen/dead_dua_screen.dart';
import 'package:hisn_almuslim/features/jami%20dua/screen/etiquette_dua_screen.dart';
import 'package:hisn_almuslim/features/jami%20dua/screen/hajj_and_omra_screen.dart';
import 'package:hisn_almuslim/features/jami%20dua/screen/last_ten_duas_screen.dart';
import 'package:hisn_almuslim/features/jami%20dua/screen/quran_dua_screen.dart';
import 'package:hisn_almuslim/features/jami%20dua/screen/sunnah_dua_screen.dart';
import 'package:hisn_almuslim/features/jami%20dua/widgets/category_card.dart';
import '../../../core/shared/app_bar_widget.dart';

class DuaScreen extends StatelessWidget {
  const DuaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      // appBar: CustomAppBar(title: "الأدعية", isDark: isDark),
      appBar: AppBarWidget(title: "الأدعية"),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            CategoryCard(
              title: 'آداب الدعاء',
              onTap: () {
              Navigator.pushNamed(context, AppRoutes.etiquetteDua);
              },
            ),
            CategoryCard(
              title: 'أدعية من القرآن',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.quranDua);
              },
            ),
            CategoryCard(
              title: 'أدعية من السنة',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.sunnahDua);
              },
            ),
            CategoryCard(
              title: 'أدعية الحج و العمرة',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.hajjAndOmraDua);
              },
            ),

            CategoryCard(
              title: 'أدعية للمتوفي',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.deadDua);
              },
            ),
            CategoryCard(
              title: 'أدعية العشر الأواخر',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.lastTenDuas);
              },
            ),
          ],
        ),
      ),
    );
  }
}
