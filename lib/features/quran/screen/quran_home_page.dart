import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/shared/re_build_scroll_To_Top.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import 'package:hisn_almuslim/features/quran/widgets/search_field.dart';
import '../../../core/routing/app_routes.dart';
import '../data/cubit/quran_cubit.dart';
import '../data/cubit/quran_state.dart';
import '../data/cubit/ayah_highlight_cubit.dart';
import '../data/cubit/ayah_highlight_state.dart';
import '../widgets/surah_card.dart';
import '../widgets/reading_dashboard.dart';

class QuranHomePage extends StatefulWidget {
  const QuranHomePage({super.key});

  @override
  State<QuranHomePage> createState() => _QuranHomePageState();
}

class _QuranHomePageState extends State<QuranHomePage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier(false);
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
    context.read<QuranCubit>().loadAllSurahs();
    context.read<AyahHighlightCubit>().loadAll();
    _scrollController.addListener(() {
      final shouldShow = _scrollController.offset > 300;
      if (_showScrollToTop.value != shouldShow) {
        _showScrollToTop.value = shouldShow;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(
        title: "المصحف الشريف",
      ),
      body: Column(
        children: [
          _buildSearchBar(context),

          // Dashboard
          // const ReadingDashboard(),

          Expanded(
            child: BlocBuilder<QuranCubit, QuranState>(
              builder: (context, state) {
                if (state is QuranLoading) {
                  return  Center(
                    child: CupertinoActivityIndicator(color: AppColors.kPrimary,),
                  );
                }

                if (state is QuranLoaded) {
                  final surahs = state.displaySurahs;

                  if (surahs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60.sp,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16.h),
                          CustomText(
                            'لا توجد نتائج',
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                          ),
                        ],
                      ),
                    );
                  }

                  return BlocBuilder<AyahHighlightCubit, AyahHighlightState>(
                    builder: (context, highlightState) {
                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        itemCount: surahs.length,
                        itemBuilder: (context, index) {
                          final surah = surahs[index];

                          return SurahCard(
                            surah: surah,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.quranSurah,
                                arguments: {'surahNumber': surah.number},
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }

                if (state is QuranError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60.sp,
                          color: Colors.red[300],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          state.message,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () => context.read<QuranCubit>().loadAllSurahs(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ReBuildScrollToTop(
        showScrollToTop: _showScrollToTop,
        scrollController: _scrollController,
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(12.w),
      child: SearchField(
        controller: _searchController,
        onChanged: (value) {
        _searchDebounce?.cancel();
        _searchDebounce = Timer(
          const Duration(milliseconds: 300),
              () {
            if (value.isEmpty) {
              context.read<QuranCubit>().clearSearch();
            } else {
              context.read<QuranCubit>().searchSurahs(value);
            }
          },
        );
        },
          hint: 'ابحث عن سورة ...',
      ),
    );
  }
}