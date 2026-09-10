import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/home/data/models/category_model.dart';
import 'package:hisn_almuslim/features/home/widgets/cairo_radio_card.dart';
import 'package:hisn_almuslim/features/home/widgets/hijri_calender.dart';
import 'package:hisn_almuslim/features/home/widgets/lectures_and_lessons_card.dart';
import 'package:hisn_almuslim/features/home/widgets/prayer_home_card.dart';
import 'package:hisn_almuslim/features/home/widgets/home_categories_section.dart';
import 'package:hisn_almuslim/features/home/widgets/home_section_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../hisn_al_muslim_app.dart';
import '../../quran/data/cubit/ayah_highlight_cubit.dart';
import '../../quran/data/cubit/quran_cubit.dart';
import '../../quran/widgets/reading_dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);

    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }


  @override
  void initState() {
    super.initState();
    context.read<QuranCubit>().loadAllSurahs();
    context.read<AyahHighlightCubit>().loadAll();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final maxWidth = AppResponsive.isDesktop(context)
        ? 1100.0
        : AppResponsive.isTablet(context)
        ? 820.0
        : double.infinity;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AppResponsive.constrain(
          context,
           maxWidth: maxWidth,
           child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(child: Gap(AppResponsive.heightValue(context, 18))),

            // Calendar
            const SliverToBoxAdapter(child: HijriCalendarCard()),

            SliverToBoxAdapter(child: Gap(AppResponsive.heightValue(context, 22))),

            const SliverToBoxAdapter(child: PrayerHomeCard()),

            SliverToBoxAdapter(child: Gap(AppResponsive.heightValue(context, 22))),

            SliverToBoxAdapter(child: const ReadingDashboard()),

            SliverToBoxAdapter(child: Gap(AppResponsive.heightValue(context, 24))),

            const SliverToBoxAdapter(
              child: LecturesAndLessonsCard(),
            ),

            SliverToBoxAdapter(child: Gap(AppResponsive.heightValue(context, 30))),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 16)),
                child: HomeSectionHeader(
                  title: ' الإذاعة',
                  icon: Icons.radio_outlined,
                ),
              ),
            ),

            SliverToBoxAdapter(child: Gap(AppResponsive.heightValue(context, 18))),

            // Quran Radio
            const SliverToBoxAdapter(child: CairoRadioCard()),

            // // Featured content
            // const SliverToBoxAdapter(child: FeaturedBanners()),
            //
            SliverToBoxAdapter(child: Gap(AppResponsive.heightValue(context, 30))),

            // Categories
            SliverToBoxAdapter(
              child: CategoriesHomeSection(
                categories: categories,
                initialVisibleCount: 2,
              ),
            ),

            // Bottom spacing
            SliverToBoxAdapter(child: Gap(
              AppResponsive.isMobile(context)
                  ? AppResponsive.heightValue(context, 100)
                  : AppResponsive.isTablet(context)
                      ? 82.0
                      : 88.0,
            )),
          ],
        ),
      ),
    )
    );
  }
}
