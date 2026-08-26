import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/features/quran/widgets/search_field.dart';
import 'package:hisn_almuslim/features/quran_audio/data/models/surah_audio_model.dart';
import 'package:hisn_almuslim/features/quran_audio/logic/audio_player_cubit.dart';
import 'package:hisn_almuslim/features/quran_audio/ui/widgets/error_widget_with_retry.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/features/quran_audio/ui/widgets/quran_audio_header.dart';
import '../../../../core/shared/re_build_scroll_To_Top.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/sources/surah_data_source.dart';
import '../../logic/quran_audio_cubit.dart';
import '../../logic/quran_audio_state.dart';
import '../widgets/loading_widget.dart';
import '../widgets/reciter_selector_button.dart';
import '../../data/services/audio_url_helper.dart';
import '../widgets/surah_list.dart';

class QuranAudioHomeScreen extends StatefulWidget {
  const QuranAudioHomeScreen({super.key});

  @override
  State<QuranAudioHomeScreen> createState() => _QuranAudioHomeScreenState();
}

class _QuranAudioHomeScreenState extends State<QuranAudioHomeScreen> {
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier(false);
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchSurahController = TextEditingController();

  List<SurahAudioModel> _filteredSurahs = [];

  void _searchSurah(String keyword) {
    setState(() {
      final input = keyword.trim().toLowerCase();
      final all = SurahDataSource.getAllSurahs();
      if (input.isEmpty) {
        _filteredSurahs = all;
      } else {
        _filteredSurahs = all
            .where((surah) => surah.nameArabic.toLowerCase().contains(input))
            .toList();
      }
    });
  }

  @override
  void initState() {
    _filteredSurahs = SurahDataSource.getAllSurahs();
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
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
    _searchSurahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Scaffold(
      body: BlocBuilder<QuranAudioCubit, QuranAudioState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildHeader(context, state),
              QuranAudioHeader(state: state, onSearch: _searchSurah , searchController: _searchSurahController,),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // _buildSearchField(context),
                      // SearchField(onChanged: _searchSurah, hint:  'ابحث في السور ...',controller: _searchSurahController,),
                      Expanded(child: _buildContent(context, state)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: isKeyboardOpen
          ? null
          : ReBuildScrollToTop(
        showScrollToTop: _showScrollToTop,
        scrollController: _scrollController,
      ),
    );
  }
  //
  // Widget _buildHeader(BuildContext context, QuranAudioState state) {
  //   final isDark = Theme.of(context).brightness == Brightness.dark;
  //   final double statusBarHeight = MediaQuery.paddingOf(context).top;
  //
  //   return Container(
  //     width: double.infinity,
  //     padding: EdgeInsets.fromLTRB(
  //       16.w,
  //       statusBarHeight + 8.h,
  //       16.w,
  //       30.h,
  //     ),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(36.r),
  //         bottomRight: Radius.circular(36.r),
  //       ),
  //       gradient: LinearGradient(
  //         begin: Alignment.topRight,
  //         end: Alignment.bottomLeft,
  //         colors: isDark
  //             ? [
  //           Colors.teal.shade800.withOpacity(0.9),
  //           Colors.teal.shade900.withOpacity(0.2),
  //         ]
  //             : [Colors.teal.shade900, Colors.teal.shade800 , ],
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppColors.kPrimary.withValues(alpha: 0.28),
  //           blurRadius: 0,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _buildTopBar(context, isDark),
  //         Gap(6.h),
  //         Padding(
  //           padding: EdgeInsets.only(left: 44.w, right: 8.w),
  //           child: Row(
  //             children: [
  //               Icon(
  //                 Icons.menu_book_rounded,
  //                 size: 12.sp,
  //                 color: Colors.white.withValues(alpha: 0.7),
  //               ),
  //               SizedBox(width: 6.w),
  //               Expanded(
  //                 child: CustomText(
  //                   'استمع للقرآن الكريم بأصوات نخبة من القراء',
  //                   color: Colors.white.withValues(alpha: 0.78),
  //                   fontSize: 10.5.sp,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Gap(24.h),
  //         _buildReciterSection(context, state),
  //         Gap(24.h),
  //
  //         SearchField(onChanged: _searchSurah, hint:  'ابحث في السور ...',controller: _searchSurahController,),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildReciterSection(BuildContext context, QuranAudioState state) {
  //   if (state is QuranAudioLoaded) {
  //     final audioCubit = context.read<AudioPlayerCubit>();
  //
  //     return BlocProvider.value(
  //       value: audioCubit,
  //       child: ReciterSelectorButton(
  //         currentReciter: state.effectiveSelectedReciter,
  //         reciters: state.reciters,
  //         onReciterSelected: (reciter) {
  //           context.read<QuranAudioCubit>().selectReciter(reciter);
  //         },
  //       ),
  //     );
  //   } else if (state is QuranAudioLoading) {
  //     return _glassContainer(
  //       child: Row(
  //         spacing: 12.w,
  //         children: [
  //           SizedBox(
  //             height: 18.h,
  //             width: 18.w,
  //             child: const CupertinoActivityIndicator(color: Colors.white),
  //           ),
  //           CustomText(
  //             'جاري تحميل القراء...',
  //             color: Colors.white,
  //             fontSize: 11.sp,
  //           ),
  //         ],
  //       ),
  //     );
  //   } else if (state is QuranAudioError) {
  //     return _glassContainer(
  //       child: Row(
  //         spacing: 12.w,
  //         children: [
  //           const Icon(Icons.error_outline_rounded, color: Colors.white),
  //           Expanded(child: CustomText(state.message, color: Colors.white)),
  //         ],
  //       ),
  //     );
  //   }
  //   return const SizedBox.shrink();
  // }
  //
  // Widget _glassContainer({required Widget child}) {
  //   return Container(
  //     width: double.infinity,
  //     padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
  //     decoration: BoxDecoration(
  //       color: Colors.white.withValues(alpha: 0.14),
  //       borderRadius: BorderRadius.circular(18.r),
  //       border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha: 0.08),
  //           blurRadius: 12,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: child,
  //   );
  // }
  //
  // Widget _buildTopBar(BuildContext context, bool isDark) {
  //   return Row(
  //     children: [
  //       _headerIconButton(
  //         icon: Icons.arrow_back_ios_rounded,
  //         isDark: isDark,
  //         onTap: () => Navigator.pop(context),
  //       ),
  //       Gap(12.w),
  //       Icon(FlutterIslamicIcons.solidQuran2, color: Colors.white, size: 20.sp),
  //       Gap(8.w),
  //       Expanded(
  //         child: CustomText(
  //           'المصحف (صوتيات)',
  //           color: Colors.white,
  //           fontSize: 15.sp,
  //           fontWeight: FontWeight.bold,
  //           maxLines: 1,
  //         ),
  //       ),
  //     ],
  //   );
  // }
  //
  // Widget _headerIconButton({
  //   required IconData icon,
  //   required bool isDark,
  //   required VoidCallback onTap,
  // }) {
  //   return Material(
  //     color: isDark
  //         ? Colors.teal.shade900.withValues(alpha: 0.3)
  //         : Colors.white.withValues(alpha: 0.15),
  //     shape: const CircleBorder(),
  //     child: InkWell(
  //       customBorder: const CircleBorder(),
  //       onTap: onTap,
  //       child: SizedBox(
  //         width: 36.w,
  //         height: 36.w,
  //         child: Icon(icon, color: Colors.white, size: 16.sp),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildContent(BuildContext context, QuranAudioState state) {
    if (state is QuranAudioLoading) {
      return const LoadingWidget();
    } else if (state is QuranAudioError) {
      return ErrorWidgetWithRetry(
        message: state.message,
        onRetry: () => context.read<QuranAudioCubit>().loadReciters(),
      );
    } else if (state is QuranAudioLoaded) {
      if (_filteredSurahs.isEmpty) {
        return _buildEmptyResults();
      }

      return Column(
        children: [
          Expanded(
            child: SurahList(
              controller: _scrollController,
              surahs: _filteredSurahs,
              selectedReciter: state.effectiveSelectedReciter ?? state.reciters.first,
              onSurahPressed: (surahNumber) {
                final reciter = state.effectiveSelectedReciter ?? state.reciters.first;
                _handleSurahPressed(context, reciter.server, surahNumber);
              },
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildEmptyResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 48.sp, color: Colors.grey.shade400),
          Gap(12.h),
          CustomText(
            'لا توجد نتائج مطابقة',
            color: Colors.grey.shade600,
            fontSize: 13.sp,
          ),
        ],
      ),
    );
  }

  void _handleSurahPressed(BuildContext context, String server, int surahNumber) {
    try {
      final state = context.read<QuranAudioCubit>().state;
      if (state is! QuranAudioLoaded) {
        _showSnack(context, 'No reciter selected');
        return;
      }

      final reciter = state.effectiveSelectedReciter;
      if (reciter == null) {
        _showSnack(context, 'No reciter selected');
        return;
      }


      final String audioUrl = AudioUrlHelper.generateAudioUrl(server, surahNumber);
      final surah = SurahDataSource.getSurahByNumber(surahNumber);
      if (surah == null) {
        _showSnack(context, 'Surah not found');
        return;
      }

      final allSurahs = SurahDataSource.getAllSurahs();

      Navigator.pushNamed(context, AppRoutes.playerAudio, arguments: {
        'surah': surah,
        'reciter': reciter,
        'audioUrl': audioUrl,
        'surahs': allSurahs,
      });
    } catch (e) {
      _showSnack(context, 'Error generating audio URL: $e');
    }
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}