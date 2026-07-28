import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/quran/data/cubit/quran_cubit.dart';
import 'package:hisn_almuslim/features/quran/data/cubit/quran_state.dart';
import 'package:hisn_almuslim/features/quran/screen/surah_screen.dart';
import 'package:hisn_almuslim/features/quran/widgets/search_field.dart';
import 'package:hisn_almuslim/features/quran/widgets/surah_card.dart';
import '../../../core/shared/re_build_scroll_To_Top.dart';

class QuranReadingScreen extends StatefulWidget {
  const QuranReadingScreen({super.key});

  @override
  State<QuranReadingScreen> createState() => _QuranReadingScreenState();
}

class _QuranReadingScreenState extends State<QuranReadingScreen> {
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier(false);
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    context.read<QuranCubit>().loadSurahs();
    _scrollController.addListener(() {
      final showButton = _scrollController.offset > 300;
      if (_showScrollToTop.value != showButton) {
        _showScrollToTop.value = showButton;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _showScrollToTop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.h,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: SearchField(
            hint: 'ابحث في السور ...',
            onChanged: (value) {
              context.read<QuranCubit>().searchSurahs(value);
            },
          ),
        ),
        body: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) {
            if (state is QuranLoading) {
              return Center(
                child: CupertinoActivityIndicator(color: Colors.teal.shade700),
              );
            }

            if (state is QuranLoaded) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.filteredSurahs.length,

                padding: EdgeInsets.only(
                  left: 8.w,
                  right: 8.w,
                  top: 8.w,
                  bottom: 70.h,
                ),
                itemBuilder: (context, index) {
                  final surah = state.filteredSurahs[index];
                  return SurahCard(
                    surah: surah,
                    onTap: () async {
                      // print("============= ${surah.name} ============");
                      // print("============ ${surah.startPage} =============");

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SurahScreen(
                              surahIndex: state.surahs.indexOf(surah),
                              initialPage: surah.startPage,
                            );
                          },
                        ),
                      );
                      if (context.mounted) {
                        context.read<QuranCubit>().loadSurahs();
                      }
                    },
                  );
                },
              );
            } else if (state is QuranError) {
              return Center(child: Text(state.message));
            }

            return const Center(child: Text('اضغط لتحميل البيانات'));
          },
        ),

        floatingActionButton: ReBuildScrollToTop(
          showScrollToTop: _showScrollToTop,
          scrollController: _scrollController,
        ),
      ),
    );
  }
}
