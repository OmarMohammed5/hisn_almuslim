import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/features/hadith/books/bukhary/screen/fehres_sahih_bukhary.dart';
import 'package:hisn_almuslim/features/hadith/books/muslim/screen/fehres_sahih_muslim.dart';
import 'package:hisn_almuslim/features/hadith/books/nawawi/screen/fehres_hadith_nawawi.dart';
import 'package:hisn_almuslim/features/hadith/books/reyad%20al%20salehin/screen/fehres_reyad_al_saliheen.dart';
import 'package:hisn_almuslim/features/hadith/widgets/book_card.dart';
import '../../core/shared/app_bar_widget.dart';

class HadithScreen extends StatelessWidget {
  const HadithScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBarWidget(title: "الأَحَادِيثُ النَّبَوِيَّةُ"),
        body: Column(
          children: [

            Expanded(
              child: GridView.count(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                crossAxisCount: 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 20.w,
                childAspectRatio: 0.83,
                children: [

                  BookCard(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.fehresSahihBukhary),
                    title: 'صحيح البخاري',
                    subtitle: 'متابعة القراءة من\nالحديث',
                    number: '١',
                  ),

                  BookCard(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.fehresSahihMuslim),
                    title: 'صحيح مسلم',
                    subtitle: 'متابعة القراءة من\nالحديث',
                    number: '١',
                  ),

                  BookCard(
                    onTap: () =>  Navigator.pushNamed(context, AppRoutes.fehresReyqdAlSaliheen),
                    title: 'رياض الصالحين',
                    subtitle: 'متابعة القراءة من\nالحديث',
                    number: '١',
                  ),

                  BookCard(
                    onTap: () =>  Navigator.pushNamed(context, AppRoutes.fehresHadithNawawi),
                    title: 'الأربعون النووية',
                    subtitle: 'متابعة القراءة من\nالحديث',
                    number: '١',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
