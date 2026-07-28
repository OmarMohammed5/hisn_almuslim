import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/quran_audio/data/models/reciter_model.dart';
import 'package:hisn_almuslim/features/quran_audio/data/models/reciter_name_model.dart';
import 'package:hisn_almuslim/features/quran_audio/ui/widgets/error_widget_with_retry.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../../core/shared/re_build_scroll_To_Top.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/surah_audio_model.dart';
import '../../data/sources/surah_data_source.dart';
import '../../logic/quran_audio_cubit.dart';
import '../../logic/quran_audio_state.dart';
import '../widgets/loading_widget.dart';
import '../widgets/reciter_selector_button.dart';
import '../../data/services/audio_url_helper.dart';
import '../widgets/surah_list.dart';
import 'audio_player_screen.dart';

class QuranAudioHomeScreen extends StatefulWidget {
  const QuranAudioHomeScreen({super.key});

  @override
  State<QuranAudioHomeScreen> createState() => _QuranAudioHomeScreenState();
}

class _QuranAudioHomeScreenState extends State<QuranAudioHomeScreen> {
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier(false);
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchSurahController = TextEditingController();



  // Search Of Surah
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
    return Scaffold(
      // backgroundColor: AppColors.kPrimary,
      // extendBodyBehindAppBar: true,
      body: BlocBuilder<QuranAudioCubit, QuranAudioState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, state),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // spacing: 12.h,
                      children: [
                        _buildSearchField(context),
                        Expanded(child: _buildContent(context, state)),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: ReBuildScrollToTop(
        showScrollToTop: _showScrollToTop,
        scrollController: _scrollController,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, QuranAudioState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double statusBarHeight = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      // statusBarHeight pushes the *content* down so nothing sits
      // under the notch/status bar icons, while the gradient behind
      // it still fills all the way up to y = 0.
      padding: EdgeInsets.fromLTRB(
        16.w,
        statusBarHeight + 8.h,
        16.w,
        30.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36.r),
          bottomRight: Radius.circular(36.r),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.kPrimary,
            AppColors.kPrimary.withValues(alpha: 0.92),
            Colors.teal.shade700,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimary.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Layered decorative glows for depth — purely visual.
          Positioned(
            top: -40,
            right: -30,
            child: IgnorePointer(
              child: Container(
                width: 150.w,
                height: 150.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -40,
            child: IgnorePointer(
              child: Container(
                width: 130.w,
                height: 130.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
          ),
          Positioned(
            top: 30.h,
            right: 60.w,
            child: IgnorePointer(
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 16,
                color: Colors.white.withValues(alpha: 0.18),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context, isDark),
              Gap(6.h),
              Padding(
                padding: EdgeInsets.only(left: 44.w, right: 8.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 12.sp,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: CustomText(
                        'استمع للقرآن الكريم بأصوات نخبة من القراء',
                        color: Colors.white.withValues(alpha: 0.78),
                        fontSize: 10.5.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(24.h),
              _buildReciterSection(context, state),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReciterSection(BuildContext context, QuranAudioState state) {
    if (state is QuranAudioLoaded) {
      return ReciterSelectorButton(
        currentReciter: state.effectiveSelectedReciter,
        reciters: state.reciters,
        onReciterSelected: (reciter) {
          context.read<QuranAudioCubit>().selectReciter(reciter);
        },
      );
    } else if (state is QuranAudioLoading) {
      return _glassContainer(
        child: Row(
          spacing: 12.w,
          children: [
            SizedBox(
              height: 18.h,
              width: 18.w,
              child: const CupertinoActivityIndicator(color: Colors.white),
            ),
            CustomText(
              'جاري تحميل القراء...',
              color: Colors.white,
              fontSize: 11.sp,
            ),
          ],
        ),
      );
    } else if (state is QuranAudioError) {
      return _glassContainer(
        child: Row(
          spacing: 12.w,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white),
            Expanded(child: CustomText(state.message, color: Colors.white)),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _glassContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDark) {
    return Row(
      children: [
        _headerIconButton(
          icon: Icons.arrow_back_ios_rounded,
          isDark: isDark,
          onTap: () => Navigator.pop(context),
        ),
        Gap(12.w),
        Icon(FlutterIslamicIcons.solidQuran2, color: Colors.white, size: 20.sp),
        Gap(8.w),
        Expanded(
          child: CustomText(
            'المصحف (صوتيات)',
            color: Colors.white,
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            maxLines: 1,
          ),
        ),
      ],
    );
  }




  Widget _headerIconButton({
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isDark
          ? Colors.teal.shade900.withValues(alpha: 0.3)
          : Colors.white.withValues(alpha: 0.15),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 36.w,
          height: 36.w,
          child: Icon(icon, color: Colors.white, size: 16.sp),
        ),
      ),
    );
  }


  Widget _buildSearchField(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      cursorColor: AppColors.kIconColor,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: _searchSurahController,
      onChanged: _searchSurah,
      decoration: InputDecoration(
        hintText: 'ابحث في السور ...',
        hintStyle: TextStyle(
          fontSize: 11.sp,
          fontFamily: "Cairo",
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: Colors.grey.shade400,
          size: 20.sp,
        ),
        suffixIcon: _searchSurahController.text.isNotEmpty
            ? GestureDetector(
          onTap: () {
            _searchSurahController.clear();
            _searchSurah('');
          },
          child: const Icon(CupertinoIcons.clear, size: 18),
        )
            : const SizedBox.shrink(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: isDark ? Color(0xff1f242a) :Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.kIconColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8.h),
        filled: true,
        fillColor: isDark ? Color(0xff1f242a) : Colors.white,
      ),
    );
  }

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
      return SurahList(
        controller: _scrollController,
        surahs: _filteredSurahs, // <-- filtered (number, name) pairs, now actually used
        selectedReciter: state.effectiveSelectedReciter ?? state.reciters.first,
        onSurahPressed: (surahNumber) {
          final reciter = state.effectiveSelectedReciter ?? state.reciters.first;
          _handleSurahPressed(context, reciter.server, surahNumber);
        },
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
      final String audioUrl = AudioUrlHelper.generateAudioUrl(server, surahNumber);

      final surah = SurahDataSource.getSurahByNumber(surahNumber);
      if (surah == null) {
        _showSnack(context, 'Surah not found');
        return;
      }

      final state = context.read<QuranAudioCubit>().state;
      if (state is! QuranAudioLoaded) {
        _showSnack(context, 'No reciter selected');
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AudioPlayerScreen(
            surah: surah,
            reciter: state.selectedReciter ?? state.reciters.first,
            audioUrl: audioUrl,
          ),
        ),
      );
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