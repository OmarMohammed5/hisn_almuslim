import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/jami%20dua/screen/dead_dua_screen.dart';
import 'package:hisn_almuslim/features/jami%20dua/screen/etiquette_dua_screen.dart';
import 'package:hisn_almuslim/features/jami%20dua/screen/hajj_and_omra_screen.dart';
import 'package:hisn_almuslim/features/jami%20dua/screen/last_ten_duas_screen.dart';
import 'package:hisn_almuslim/features/jami%20dua/screen/quran_dua_screen.dart';
import 'package:hisn_almuslim/features/jami%20dua/screen/sunnah_dua_screen.dart';
import 'package:hisn_almuslim/features/jami%20dua/widgets/category_card.dart';
import 'package:hisn_almuslim/shared/app_bar_widget.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return EtiquetteDuaScreen();
                    },
                  ),
                );
              },
            ),
            CategoryCard(
              title: 'أدعية من القرآن',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return QuranDuaScreen();
                    },
                  ),
                );
              },
            ),
            CategoryCard(
              title: 'أدعية من السنة',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SunnahDuaScreen();
                    },
                  ),
                );
              },
            ),
            CategoryCard(
              title: 'أدعية الحج و العمرة',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HajjAndOmraScreen();
                    },
                  ),
                );
              },
            ),

            CategoryCard(
              title: 'أدعية للمتوفي',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return DeadDuaScreen();
                    },
                  ),
                );
              },
            ),
            CategoryCard(
              title: 'أدعية العشر الأواخر',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LastTenDuasScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
