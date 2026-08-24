import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/home/data/models/category_model.dart';
import 'package:hisn_almuslim/features/home/widgets/cairo_radio_card.dart';
import 'package:hisn_almuslim/features/home/widgets/hijri_calender.dart';
import 'package:hisn_almuslim/features/home/widgets/categories_header.dart';
import 'package:hisn_almuslim/features/home/widgets/islamic_divider.dart';
import 'package:hisn_almuslim/features/home/widgets/custom_card_widget.dart';
import 'package:hisn_almuslim/features/home/widgets/lectures_and_lessons_card.dart';
import '../../../hisn_al_muslim_app.dart';
import '../widgets/featured_banners.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenElegantState();
}

class _HomeScreenElegantState extends State<HomeScreen> with RouteAware{

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: Gap(65.h)),
          /// Calender
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: HijriCalendarCard(),
            ),
          ),
          SliverToBoxAdapter(child: Gap(22.h)),

          /// Banners
          SliverToBoxAdapter(
            child: const FeaturedBanners(),
          ),

          SliverToBoxAdapter(child: Gap(24.h)),

          /// Radio Station
          SliverToBoxAdapter(child: CairoRadioCard(),),

          SliverToBoxAdapter(child: Gap(24.h)),

          SliverToBoxAdapter(child: IslamicDivider(isDark: isDark)),

          SliverToBoxAdapter(child: Gap(24.h)),

          /// Lectures
          SliverToBoxAdapter(child: LecturesAndLessonsCard()),

          SliverToBoxAdapter(child: Gap(24.h)),
          // Title of Categories
          SliverToBoxAdapter(child: CategoriesHeader(isDark: isDark)),

          // Categories
          SliverPadding(
            padding: EdgeInsets.fromLTRB(18.w, 4.h, 18.w, 12.h),
            sliver: SliverGrid.builder(
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 0.93.h,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                final screen = categories[index];
                return CustomCardWidget(
                  title: category.title,
                  icon: category.icon,
                  onTap: () {
                    Navigator.pushNamed(context,category.route);
                  },
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: Gap(100.h)),
        ],
      ),
    );
  }
}
