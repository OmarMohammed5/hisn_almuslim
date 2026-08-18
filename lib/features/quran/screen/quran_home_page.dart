import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/core/shared/re_build_scroll_To_Top.dart';
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
      appBar: AppBarWidget(
        title: 'القُرْآنُ الكَرِيمُ',
      ),
      body: Column(
        children: [
          _buildSearchBar(context),

          // Dashboard
          const ReadingDashboard(),

          Expanded(
            child: BlocBuilder<QuranCubit, QuranState>(
              builder: (context, state) {
                if (state is QuranLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
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
                          Text(
                            'لا توجد نتائج',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                            ),
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
                          final highlightsForSurah = highlightState.forSurah(surah.number);
                          double highlightProgress = 0.0;
                          if (highlightsForSurah.isNotEmpty && surah.totalAyahs > 0) {
                            highlightProgress = highlightsForSurah.keys.length / surah.totalAyahs;
                          }

                          return SurahCard(
                            surah: surah,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.quranSurah,
                                arguments: {'surahNumber': surah.number},
                              );
                            },
                            progress: highlightProgress,
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: TextField(
        cursorColor: Colors.grey[500],
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'ابحث عن سورة ...',
          hintStyle: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey[500],
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 22.sp,
            color: Colors.grey[500],
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, size: 20.sp),
            onPressed: () {
              _searchController.clear();
              context.read<QuranCubit>().clearSearch();
              FocusManager.instance.primaryFocus?.unfocus();
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
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
      ),
    );
  }
}