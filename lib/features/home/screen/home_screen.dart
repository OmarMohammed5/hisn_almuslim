import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/home/data/models/category_model.dart';
import 'package:hisn_almuslim/features/home/widgets/hijri_calender.dart';
import 'package:hisn_almuslim/features/home/widgets/categories_header.dart';
import 'package:hisn_almuslim/features/home/widgets/islamic_divider.dart';
import 'package:hisn_almuslim/features/home/widgets/custom_card_widget.dart';
import 'package:hisn_almuslim/features/quran/data/cubit/quran_cubit.dart';
import 'package:hisn_almuslim/features/quran/data/cubit/quran_state.dart';
import 'package:hisn_almuslim/features/quran/widgets/quran_dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenElegantState();
}

class _HomeScreenElegantState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<QuranCubit>().loadSurahs();
  }

  //  @override
  void didPopNext() {
    setState(() {});
    context.read<QuranCubit>().loadSurahs();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: Gap(65.h)),
          // Quran Progress Dashboard
          // Banners
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: HijriCalendarCard(),
            ),
          ),
          SliverToBoxAdapter(child: Gap(16.h)),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: BlocBuilder<QuranCubit, QuranState>(
                builder: (context, state) {
                  if (state is QuranLoaded) {
                    return QuranProgressDashboard(surahs: state.surahs);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),

          SliverToBoxAdapter(child: Gap(15.h)),

          SliverToBoxAdapter(child: IslamicDivider(isDark: isDark)),
          // Titel of Categories
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
                childAspectRatio: 1.h,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return CustomCardWidget(
                  title: category.title,
                  icon: category.icon,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return category.screen;
                        },
                      ),
                    );
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
