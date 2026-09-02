import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/home/data/models/category_model.dart';
import 'package:hisn_almuslim/features/home/widgets/cairo_radio_card.dart';
import 'package:hisn_almuslim/features/home/widgets/hijri_calender.dart';
import 'package:hisn_almuslim/features/home/widgets/home_categories_section.dart';
import 'package:hisn_almuslim/features/home/widgets/home_section_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../hisn_al_muslim_app.dart';
import '../../quran/data/cubit/ayah_highlight_cubit.dart';
import '../../quran/data/cubit/quran_cubit.dart';
import '../../quran/widgets/reading_dashboard.dart';
import '../widgets/featured_banners.dart';

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
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(child: Gap(18.h)),

            // Calendar
            const SliverToBoxAdapter(child: HijriCalendarCard()),

            SliverToBoxAdapter(child: Gap(24.h)),

            SliverToBoxAdapter(child: const ReadingDashboard()),

            SliverToBoxAdapter(child: Gap(30.h)),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: HomeSectionHeader(
                  title: ' الإذاعة',
                  icon: Icons.radio_outlined,
                ),
              ),
            ),

            SliverToBoxAdapter(child: Gap(16.h)),

            // Quran Radio
            const SliverToBoxAdapter(child: CairoRadioCard()),

            // // Featured content
            // const SliverToBoxAdapter(child: FeaturedBanners()),
            //
            SliverToBoxAdapter(child: Gap(24.h)),

            // Categories
            SliverToBoxAdapter(
              child: CategoriesHomeSection(
                categories: categories,
                initialVisibleCount: 2,
              ),
            ),





            // SliverToBoxAdapter(child: Gap(14.h)),
            //
            // // Lectures
            // const SliverToBoxAdapter(child: LecturesAndLessonsCard()),

            // Bottom spacing
            SliverToBoxAdapter(child: Gap(110.h)),
          ],
        ),
      ),
    );
  }
}
